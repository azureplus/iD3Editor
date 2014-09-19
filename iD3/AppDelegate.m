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
#import "NSString_Filename.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _tags = [[NSMutableArray alloc] initWithCapacity:32];
    [self _initCoreData];
    [self _initSupportedEncodings];
    [self _initSupportedFileTypes];
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

-(TagEntity *)_addFile:(NSURL *)fileURL {
    NSString * filename = [fileURL path];
    
//    for (TagEntity * tag in _tags) {
//        if ([[tag filename] isEqualToString:filename])
//            return nil;
//    }
    
    return [self _addTag:filename];
}



-(TagEntity *)_addTag: (NSString *) filename {
    NSNumber * pathDepth = [NSNumber numberWithInt:0];
    if ([_tagArrayController.arrangedObjects count]) {
        pathDepth = ((TagEntity *)[_tagArrayController.arrangedObjects objectAtIndex:0]).pathDepth;
    }
    
    NSEntityDescription * tagDescription = [[_managedObjectModel entitiesByName] objectForKey:@"Tag"];
    TagEntity * tagEntity = [[TagEntity alloc] initWithEntity:tagDescription insertIntoManagedObjectContext:_managedObjectContext];
    tagEntity.pathDepth = pathDepth;
    tagEntity.tag = [FileResolver read:filename];
    [_tagArrayController addObject:tagEntity];
    
    return tagEntity;
}

-(void) removeTagEntity: (TagEntity *) tagEntity {
    [_tagArrayController removeObject:tagEntity];
    // WARNING!
    // dont forget deleting the object from the managed object context
    [_managedObjectContext deleteObject:tagEntity];
}

-(void) removeSelectedTags {
    for (id obj in [_tagArrayController selectedObjects]) {
        [self removeTagEntity:obj];
    }
}

// suppored char encoding
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
//    if (object == _encodingArrayController && [keyPath isEqualTo:@"selection"]) {
//        NSArray * selectedEncodings = _encodingArrayController.selectedObjects;
//        if (selectedEncodings.count >= 1) {
//            EncodingEntity * encodignEntity = selectedEncodings[0];
//            NSArray * selectedTags = _tagArrayController.selectedObjects;
//            for (TagEntity * tag in selectedTags) {
//                [tag convertFramestoEncoding:[encodignEntity.code unsignedIntValue]];
//            }
//        }
//    }
}



-(void) _addFilesInFolders:(NSArray *)urls {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    for (NSURL * url in urls) {
        NSArray * files = [fileManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:@[NSURLIsWritableKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
        BOOL isDirectory = NO;
        for(NSURL * file in files) {
            if ([_supportedFileTypes containsObject:[file pathExtension]]) {
                BOOL fileExists = [fileManager fileExistsAtPath:[file path]  isDirectory:&isDirectory];
                if (fileExists && !isDirectory) {
                    [_fileBeingSaved performSelectorOnMainThread:@selector(setStringValue:) withObject:[file path] waitUntilDone:YES];
                    [self performSelectorOnMainThread:@selector(_addFile:) withObject:file waitUntilDone:YES];
                }
            }
        }
    }
    
    [NSApp stopModalWithCode:0];    
}

/// actions
-(void) _afterFileOpenPanelClose:(NSArray *) urls {
    [_progressIndicator startAnimation:nil];
    [self performSelectorInBackground:@selector(_addFilesInFolders:) withObject:urls];
    self.progressWindow.title = @"Opening Files";
    [NSApp runModalForWindow:self.progressWindow];
    [_progressIndicator stopAnimation:nil];
    [self.progressWindow orderOut:nil];
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


-(void) _saveChangesHelp {
//    for (TagEntity * tag in _tagArrayController.arrangedObjects) {
//        [_fileBeingSaved performSelectorOnMainThread:@selector(setStringValue:) withObject:tag.tag.filename waitUntilDone:NO];
//        [tag save];
//    }
//    [NSApp stopModalWithCode:0];
}

-(IBAction) saveChanges:(id)sender {
//    BOOL saveNeeded = NO;
//    for (TagEntity * tag in _tagArrayController.arrangedObjects) {
//        if (tag.tagUpdated) {
//            saveNeeded = YES;
//            break;
//        }
//    }
//
//    if (!saveNeeded) {
//        return;
//    }
//    
//    [_progressIndicator startAnimation:nil];
//    [self performSelectorInBackground:@selector(_saveChangesHelp) withObject:nil];
//    self.progressWindow.title = @"Saving Files";
//    [NSApp runModalForWindow:self.progressWindow];
//    [_progressIndicator stopAnimation:nil];
//    [self.progressWindow orderOut:nil];
}


-(IBAction) resetChanges:(id)sender {
    for (TagEntity * tag in _tagArrayController.arrangedObjects) {
        [tag resetValue];
    }
}

-(IBAction) clearFileList:(id)sender {
//    [self saveChanges:nil];
//    
//    NSArray * tags = [NSArray arrayWithArray:[_tagArrayController arrangedObjects]];
//    
//    for (TagEntity * tag in tags) {
//        [self removeTagEntity:tag];
//    }
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

// convert filename to tag
-(void) filenameToTag:(NSString *)pattern {
//    NSArray * selectedTags = _tagArrayController.selectedObjects;
//    for (TagEntity * tag in selectedTags) {
//        [tag fromFilenameWithPattern:pattern];
//    }
}

-(NSUInteger)_getTrackSize:(TagEntity *)tag {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesSubentities:YES];
    [request setEntity:[NSEntityDescription entityForName:@"Tag" inManagedObjectContext:_managedObjectContext]];
    
    NSString * album = [tag.album stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"album = '%@'", album]];
    [request setPredicate:predicate];
    
    NSUInteger count = [_managedObjectContext countForFetchRequest:request error:nil];
    if(count == NSNotFound) {
        return 0;
    } else {
        int size = 1;
        while (count >= 10) {
            count = count/10;
            size++;
        }
        return size;
    }
}

// Tag to filename rename file
-(void) tagToFilename: (NSString *)pattern {
//    if ([pattern length] == 0) {
//        return;
//    }
//    
//    [self saveChanges:nil];
//    
//    NSMutableArray * tagsToRename = [NSMutableArray arrayWithCapacity:32];
//    NSMutableArray * tagsNewlyAdded = [NSMutableArray arrayWithCapacity:32];
//    
//    for (TagEntity * tagEntity in _tagArrayController.selectedObjects) {
//        [tagsToRename addObject:tagEntity];
//    }
//    
//    for (TagEntity * tagEntity in tagsToRename) {
//        NSString * oldFilename = tagEntity.tag.filename;
//       
//        NSMutableArray * components = [NSMutableArray arrayWithArray:[oldFilename pathComponents]];
//        NSUInteger trackSize = [self _getTrackSize: tagEntity];
//        NSString * newFilename = [NSString fromTag:tagEntity withPattern:pattern andTrackSize:trackSize];
//        components[components.count - 1] = [newFilename stringByAppendingPathExtension:[oldFilename pathExtension]];
//        newFilename = [NSString pathWithComponents:components];
//                
//        NSFileManager * fm = [[NSFileManager alloc] init];
//        BOOL result = [fm moveItemAtPath:oldFilename toPath:newFilename error:nil];
//        
//        if (result) {
//            [self removeTagEntity:tagEntity];
//            TagEntity * newTag = [self _addFile:[NSURL fileURLWithPath:newFilename isDirectory:NO]];
//            [tagsNewlyAdded addObject:newTag];
//        } else {
//            [tagsNewlyAdded addObject:tagEntity];
//        }
//    }
//    
//    [_tagArrayController setSelectedObjects:tagsNewlyAdded];
}

// get path depth
-(NSUInteger) pathDepth {
    if ([_tagArrayController.arrangedObjects count] > 0) {
        TagEntity * tagEntity = _tagArrayController.arrangedObjects[0];
        return [tagEntity.pathDepth unsignedIntegerValue];
    } else {
        return 0;
    }
}


// set path depth
-(void) setPathDepth: (NSUInteger) depth {
    for (TagEntity * te in _tagArrayController.arrangedObjects) {
        te.pathDepth = [NSNumber numberWithUnsignedInteger:depth];
    }
}
@end
