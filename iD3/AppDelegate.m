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

//
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self _initCoreData];
    [self _initSupportedEncodings];
    [self _initSupportedFileTypes];
    
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
    NSString *filePath   = [[NSBundle mainBundle] pathForResource:@"iD3" ofType:@"plist"];
    NSDictionary * plist = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    _supportedFileTypes = [NSMutableArray arrayWithCapacity:12];
    
    for (NSString * type in plist[@"Supported Files"]) {
        if (![type hasPrefix:@"--"]) {
            [_supportedFileTypes addObject:type];
        }
    }
}

//// core data ////
-(void) _initCoreData {
    // the model definition file
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    
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
    for (TagEntity * tag in _tagArrayController.arrangedObjects) {
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
@end
