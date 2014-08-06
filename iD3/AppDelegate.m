//
//  AppDelegate.m
//  iD3
//
//  Created by Qiang Yu on 7/25/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "AppDelegate.h"
#import "Tag.h"
#import "TagEntity.h"

// tag encodings
#import "EncodingEntity.h"
#import "TagEntity_Encoding.h"

// conversion between tag and filename
#import "TagEntity_Filename.h"

#import "NSString_Filename.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _tags = [[NSMutableArray alloc] initWithCapacity:32];
    [self _initCoreData];
    [self _initSupportedEncodings];
    [_encodingArrayController addObserver:self forKeyPath:@"selection" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)  context:nil];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTimeReminder"]) {
        [self _showFirstTimeMessage];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"FirstTimeReminder"];
    }
}

-(void) windowWillClose:(NSNotification *)notification {
    [self saveChanges:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

-(TagEntity *)_addFile:(NSURL *)fileURL {
    NSString * filename = [fileURL path];
    
    for (Tag * tag in _tags) {
        if ([[tag filename] isEqualToString:filename])
            return nil;
    }
    
    return [self _addTag:[[Tag alloc] initWithFile:filename]];
}

-(TagEntity *)_addTag: (Tag *) tag {
    [_tags addObject:tag];
    
    NSNumber * pathDepth = [NSNumber numberWithInt:0];
    if ([_tagArrayController.arrangedObjects count]) {
        pathDepth = ((TagEntity *)[_tagArrayController.arrangedObjects objectAtIndex:0]).pathDepth;
    }
    
    NSEntityDescription * tagDescription = [[_managedObjectModel entitiesByName] objectForKey:@"Tag"];
    TagEntity * tagEntity = [[TagEntity alloc] initWithEntity:tagDescription insertIntoManagedObjectContext:_managedObjectContext];
    tagEntity.pathDepth = pathDepth;    
    tagEntity.tag = tag;
    [_tagArrayController addObject:tagEntity];
    
    return tagEntity;
}

-(void) _removeTagEntity: (TagEntity *) tagEntity {
    [_tagArrayController removeObject:tagEntity];
    [_tags removeObject:tagEntity.tag];
    // WARNING!
    // dont forget deleting the object from the managed object context
    [_managedObjectContext deleteObject:tagEntity];
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
                [tag convertFramestoEncoding:[encodignEntity.code unsignedIntValue]];
            }
        }
        
    }
}

/// actions
-(IBAction) openFiles:(id)sender {
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    
    //
    // music folder
    //
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES);
    NSString *musicPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    [panel setDirectoryURL:[NSURL fileURLWithPath:musicPath]];
    //
    // mp3 file type
    [panel setAllowedFileTypes:@[@"public.mp3"]];
    
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSArray * urls = [panel URLs];
            for (NSURL * url in urls) {
                [self _addFile:url];
            }
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

-(IBAction) saveChanges:(id)sender {
    for (TagEntity * tag in _tagArrayController.arrangedObjects) {
        [tag save];
    }
}

-(IBAction) resetChanges:(id)sender {
    for (TagEntity * tag in _tagArrayController.arrangedObjects) {
        [tag resetValue];
    }
}

-(IBAction) clearFileList:(id)sender {
    [self saveChanges:nil];
    [_tags removeAllObjects];
    [_tagArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet
                                                               indexSetWithIndexesInRange:NSMakeRange(0, [[_tagArrayController arrangedObjects]
                                                                                                          count])]];
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
    NSArray * selectedTags = _tagArrayController.selectedObjects;
    for (TagEntity * tag in selectedTags) {
        [tag fromFilenameWithPattern:pattern];
    }
}

-(NSUInteger)_getTrackSize:(TagEntity *)tag {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesSubentities:YES];
    [request setEntity:[NSEntityDescription entityForName:@"Tag" inManagedObjectContext:_managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"album = '%@'", tag.album]];
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
    if ([pattern length] == 0) {
        return;
    }
    
    NSMutableArray * tagsToRename = [NSMutableArray arrayWithCapacity:32];
    NSMutableArray * tagsNewlyAdded = [NSMutableArray arrayWithCapacity:32];
    
    for (TagEntity * tagEntity in _tagArrayController.selectedObjects) {
        [tagsToRename addObject:tagEntity];
    }
    
    for (TagEntity * tagEntity in tagsToRename) {
        NSString * oldFilename = tagEntity.tag.filename;
       
        NSMutableArray * components = [NSMutableArray arrayWithArray:[oldFilename pathComponents]];
        NSUInteger trackSize = [self _getTrackSize: tagEntity];
        NSString * newFilename = [NSString fromTag:tagEntity withPattern:pattern andTrackSize:trackSize];
        components[components.count - 1] = [newFilename stringByAppendingPathExtension:[oldFilename pathExtension]];
        newFilename = [NSString pathWithComponents:components];
                
        NSFileManager * fm = [[NSFileManager alloc] init];
        BOOL result = [fm moveItemAtPath:oldFilename toPath:newFilename error:nil];
        
        if (result) {
            [self _removeTagEntity:tagEntity];
            TagEntity * newTag = [self _addFile:[NSURL fileURLWithPath:newFilename isDirectory:NO]];
            [tagsNewlyAdded addObject:newTag];
        } else {
            [tagsNewlyAdded addObject:tagEntity];
        }
    }
    
    [_tagArrayController setSelectedObjects:tagsNewlyAdded];
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

//
-(void) _showFirstTimeMessage {
    ////
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES);
    NSString * musicPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    musicPath = [musicPath stringByResolvingSymlinksInPath];
    NSString * message = [NSString stringWithFormat:@"This tool can help you rename music files using their tags. But this functionality is only available for music files under folder %@.\n", musicPath];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Reminder"];
    [alert setInformativeText:message];
    [alert setAlertStyle:NSInformationalAlertStyle];
    ////
    
    [alert beginSheetModalForWindow:_window modalDelegate:self didEndSelector:nil contextInfo:nil];
}

@end
