//
//  AppDelegate.m
//  iD3
//
//  Created by Qiang Yu on 7/25/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "AppDelegate.h"
#import "TagEntity.h"
#import "FileResolver.h"

// tag encodings
#import "EncodingEntity.h"

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

//
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self _initSupportedEncodings];
    [self _initSupportedFileTypes];
    
    // set the sort descriptor of array controller
    NSSortDescriptor * accessSort = [[NSSortDescriptor alloc] initWithKey:@"access" ascending:NO];
    [self.t2nHistoryController setSortDescriptors:@[accessSort]];
    [self.n2tHistoryController setSortDescriptors:@[accessSort]];
    
    // observes char encoding changes
    [_encodingArrayController addObserver:self forKeyPath:@"selection" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)  context:nil];
    
    // register default preferences
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultPreferences" ofType:@"plist"]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) windowWillClose:(NSNotification *)notification {
    [self saveChanges:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

// add a file
-(TagEntity *)_addFile:(NSURL *)fileURL {
    NSString * filename = [fileURL path];
    
    for (TagEntity * tag in [self.tagArrayController arrangedObjects]) {
        if ([[tag filename] isEqualToString:filename])
            return nil;
    }
    
    return [self _addTag:filename];
}

// add a tag into (managed) tag entity array
-(TagEntity *)_addTag: (NSString *) filename {
    NSEntityDescription * tagDescription = [[_managedObjectModel entitiesByName] objectForKey:@"Tag"];
    TagEntity * tagEntity = [[TagEntity alloc] initWithEntity:tagDescription insertIntoManagedObjectContext:_managedObjectContext];
    tagEntity.tag = [FileResolver read:filename];
    tagEntity.filename = filename;
    [_tagArrayController addObject:tagEntity];
    
    return tagEntity;
}

// remove a managed tag entity
-(void) removeTagEntity: (TagEntity *) tagEntity {
    [_tagArrayController removeObject:tagEntity];
    // WARNING!
    // dont forget deleting the object from the managed object context
    [_managedObjectContext deleteObject:tagEntity];
}

// remove selected tag entities
-(void) removeSelectedTags {
    NSArray * selectedTags = [NSArray arrayWithArray:[_tagArrayController selectedObjects]];
    [self _saveHelp:selectedTags];
    for (id obj in selectedTags) {
        [self removeTagEntity:obj];
    }
}

// init supported char encoding
-(void)_initSupportedEncodings {
    NSString *filePath   = [[NSBundle mainBundle] pathForResource:@"iD3" ofType:@"plist"];
    NSDictionary * plist = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSDictionary * encodings = plist[@"Encoding"];

    NSEntityDescription * encodingDescription = [[_managedObjectModel entitiesByName] objectForKey:@"Encoding"];
    NSArray * regions = plist[@"Ordered Encoding Regions"];
    
    for (NSString * region in regions) {
        NSDictionary * encoding = encodings[region];
        for (NSString * name in encoding) {
            NSString * code = encoding[name];
            UInt intCode = 0;
            NSScanner * scanner = [NSScanner scannerWithString:code];
            [scanner scanHexInt: &intCode];
            
            EncodingEntity * encodingEntity = [[EncodingEntity alloc] initWithEntity:encodingDescription insertIntoManagedObjectContext:_managedObjectContext];
            encodingEntity.name = [NSString stringWithFormat:@"%@(%@)", region, name];
            encodingEntity.code = [NSNumber numberWithUnsignedInteger:intCode];
            [_encodingArrayController addObject:encodingEntity];
            [_encodingArrayController setSelectedObjects:@[]];
        }
    }
}

// init supported file types
-(void)_initSupportedFileTypes {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iD3" ofType:@"plist"];
    NSDictionary * plist = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    _supportedFileTypes = [NSMutableArray arrayWithCapacity:12];
    
    for (NSString * type in plist[@"Supported Files"]) {
        if (![type hasPrefix:@"--"]) {
            [_supportedFileTypes addObject:type];
        }
    }
}

- (NSURL *)applicationDocumentsDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.id3editor.editor"];
}

//// core data ////
- (NSManagedObjectModel *)managedObjectModel{
    if (!_managedObjectModel) {
        [self _initCoreData];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        [self _initCoreData];
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        [self _initCoreData];
    }
    
    return _managedObjectContext;
}

-(void) _initCoreData {
    // the model definition file
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:@"Tag" URL:nil options:nil error:nil];
    
    /*--- COREDATA CODE COPY BEGIN ---*/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!shouldFail && !error) {
        NSURL *url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"ID3User.xml"];
        /*-- COREDATA CODE CHANGE --*/
        [_persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:@"User" URL:url options:nil error:&error];
    }
    
    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"com.id3editor" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
    }
    /*--- COREDATA CODE COPY END ---*/
    
    //
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == _encodingArrayController && [keyPath isEqualTo:@"selection"]) {
        NSArray * selectedEncodings = _encodingArrayController.selectedObjects;
        if (selectedEncodings.count >= 1) {
            EncodingEntity * encodignEntity = selectedEncodings[0];
            NSArray * selectedTags = _tagArrayController.selectedObjects;
            for (TagEntity * tag in selectedTags) {
                [tag setCharEncoding:[encodignEntity.code unsignedIntValue]];
            }
        }
    }
}


-(void) _afterFileOpenPanelClose:(NSArray *) urls {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    self.progressWindow.title = @"Opening Files";
    [_progressIndicator startAnimation:nil];
    [_filenameField setStringValue:@"opening files..."];

    NSModalSession session = [NSApp beginModalSessionForWindow:self.progressWindow];
    for (NSURL * url in urls) {
        NSArray * files = [fileManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:@[NSURLIsWritableKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
        BOOL isDirectory = NO;
        for(NSURL * file in files) {
            if ([_supportedFileTypes containsObject:[file pathExtension]]) {
                BOOL fileExists = [fileManager fileExistsAtPath:[file path]  isDirectory:&isDirectory];
                if (fileExists && !isDirectory) {
                    [_filenameField setStringValue:[file path]];
                    if ([NSApp runModalSession:session] != NSModalResponseContinue)
                        break;
                    [NSThread sleepForTimeInterval:0.3];
                    [self _addFile:file];
                }
            }
        }
    }

    [NSApp stopModal];
    [_progressIndicator startAnimation:nil];
    [self.progressWindow orderOut:nil];
    [NSApp endModalSession:session];
}


-(void)_addHistory:(NSString *)historyEntity toController:(NSArrayController *)controller withPattern:(NSString *)pattern {
    if([pattern length] == 0) {
        return;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:historyEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pattern == %@", pattern];
    [request setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject * item in result) {
        [controller removeObject:item];
        [self.managedObjectContext deleteObject:item]; //delete pre-existing ones
    }
    
    NSEntityDescription * description = [[_managedObjectModel entitiesByName] objectForKey:historyEntity];
    NSManagedObject * history = [[NSManagedObject alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
    [history setValue:pattern forKey:@"pattern"];
    [history setValue:pattern forKey:@"comment"];
    [history setValue:[NSNumber numberWithInt:(int)[NSDate timeIntervalSinceReferenceDate]] forKey:@"access"];
    [controller addObject:history];

    static int historyLen = 20;

    NSArray * items = [NSArray arrayWithArray:[controller arrangedObjects]];
    if (items.count > historyLen) {
        for (NSUInteger i = items.count - 1; i >= historyLen; i--) {
            [controller removeObject:items[i]];
            [self.managedObjectContext deleteObject:items[i]];
        }
    }
}


-(void) addN2TPattern:(NSString *)pattern {
    [self _addHistory:@"N2THistory" toController:_n2tHistoryController withPattern:pattern];
}

-(void) addT2NPattern:(NSString *)pattern {
    [self _addHistory:@"T2NHistory" toController:_t2nHistoryController withPattern:pattern];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    [[self managedObjectContext] save:nil];
    return NSTerminateNow;
}


-(IBAction) openFiles:(id)sender {
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:YES];
    
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSArray * urls = [panel URLs];
            [self performSelectorOnMainThread:@selector(_afterFileOpenPanelClose:) withObject:urls waitUntilDone:NO];
        }
    }];
}

-(IBAction) showEncodingWindow:(id)sender {
    [_encodingArrayController setSelectedObjects:@[]];
    [NSApp runModalForWindow:self.encodingWindow];
    [self.encodingWindow orderOut:nil];
}

-(IBAction) showFileNameAndTagWindow:(id)sender {
    [NSApp runModalForWindow:self.filenameWindow];
    [self.filenameWindow orderOut:nil];
}


-(void)_saveHelp:(NSArray *)tagEntitiesToSave {
    self.progressWindow.title = @"Saving Files";
    [_progressIndicator startAnimation:nil];
    [_filenameField setStringValue:@"saving files..."];
    
    NSModalSession session = [NSApp beginModalSessionForWindow:self.progressWindow];
    
    for (TagEntity * tag in tagEntitiesToSave) {
        if ([NSApp runModalSession:session] != NSModalResponseContinue)
            break;
        if ([tag updated]) {
            [_filenameField setStringValue:tag.filename];
            [NSThread sleepForTimeInterval:0.3];
            [FileResolver writeTag:tag.tag to:tag.filename];
            [tag.tag savedChanges];
        }
    }
    
    [NSApp stopModal];
    [_progressIndicator startAnimation:nil];
    [self.progressWindow orderOut:nil];
    [NSApp endModalSession:session];
}

-(IBAction) saveChanges:(id)sender {
    BOOL saveNeeded = NO;
    for (TagEntity * tag in _tagArrayController.arrangedObjects) {
        if ([tag updated]) {
            saveNeeded = YES;
            break;
        }
    }

    if (!saveNeeded) {
        return;
    }
    
    [self _saveHelp:[_tagArrayController arrangedObjects]];
}

-(IBAction) resetValues:(id)sender {
    for (TagEntity * tag in _tagArrayController.selectedObjects) {
        [tag resetValue];
    }
}

-(IBAction) clearFileList:(id)sender {
    [self saveChanges:nil];
    
    NSArray * tags = [NSArray arrayWithArray:[_tagArrayController arrangedObjects]];
    
    for (TagEntity * tag in tags) {
        [self removeTagEntity:tag];
    }
}

-(IBAction) setAlbumToAll:(id)sender {
    NSString * album = [_album stringValue];
    if ([[_tagArrayController selectedObjects] count] <= 1 || [album length] != 0) {
        for (TagEntity * tag in _tagArrayController.arrangedObjects) {
            tag.album = album;
        }
    }
}


-(IBAction) setArtistToAll:(id)sender {
    NSString * artist = [_artist stringValue];
    if ([[_tagArrayController selectedObjects] count] <= 1 || [artist length] != 0) {
        for (TagEntity * tag in _tagArrayController.arrangedObjects) {
            tag.artist = artist;
        }
    }
}

-(IBAction) setGenreToAll:(id)sender {
    NSString * genre = [_genre stringValue];
    if ([[_tagArrayController selectedObjects] count] <= 1 || [genre length] != 0) {
        for (TagEntity * tag in _tagArrayController.arrangedObjects) {
            tag.genre = genre;
        }
    }
}

-(NSString *) _formatString:(NSString *)value withFormat:(NSInteger)format {
    if (format == 0) {
        return [value lowercaseStringWithLocale:[NSLocale currentLocale]];
    } else if (format == 1) {
        return [value uppercaseStringWithLocale:[NSLocale currentLocale]];
    } else if (format == 2) {
        return [value capitalizedStringWithLocale:[NSLocale currentLocale]];
    } else {
        return value;
    }
}

-(IBAction) formatTags:(id)sender {
    NSInteger format = [self.cbFormat indexOfSelectedItem];
    BOOL formatArtist = [self.chkArtist state] == NSOnState;
    BOOL formatTitle = [self.chkTitle state] == NSOnState;
    BOOL formatAlbum = [self.chkAlbum state] == NSOnState;
    BOOL formatGenre = [self.chkGenre state] == NSOnState;
    BOOL formatComment = [self.chkComment state] == NSOnState;
    BOOL formatComposer = [self.chkComposer state] == NSOnState;
    BOOL formatCopyright = [self.chkCopyright state] == NSOnState;
    
    if (format < 0) {
        return;
    }
    
    for (TagEntity * tag in _tagArrayController.selectedObjects) {
        if (formatArtist) {
            tag.artist = [self _formatString:tag.artist withFormat:format];
        }
        
        if (formatTitle) {
            tag.title = [self _formatString:tag.title withFormat:format];
        }

        if (formatAlbum) {
            tag.album = [self _formatString:tag.album withFormat:format];
        }

        if (formatGenre) {
            tag.genre = [self _formatString:tag.genre withFormat:format];
        }

        if (formatComment) {
            tag.comment = [self _formatString:tag.comment withFormat:format];
        }

        if (formatComposer) {
            tag.composer = [self _formatString:tag.composer withFormat:format];
        }

        if (formatCopyright) {
            tag.copyright = [self _formatString:tag.copyright withFormat:format];
        }
    }
}

-(IBAction)test:(id)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"];
    NSImage * image = [[NSImage alloc] initWithContentsOfFile:filePath];
    for (TagEntity * tag in _tagArrayController.arrangedObjects) {
        [tag setCoverArt:image];
    }
}
@end
