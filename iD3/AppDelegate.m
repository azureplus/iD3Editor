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
#import "TagEntity_Encoding.h"
#import "EncodingEntity.h" // tag char encoding

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _tags = [[NSMutableArray alloc] initWithCapacity:32];
    [self _initCoreData];
    [self _initSupportedEncodings];
    [_encodingArrayController addObserver:self forKeyPath:@"selection" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)  context:nil];
}

-(void)_addFile:(NSURL *)fileURL {
    NSString * filename = [fileURL path];
    
    for (Tag * tag in _tags) {
        if ([[tag filename] isEqualToString:filename])
            return;
    }
    
    [self _addTag:[[Tag alloc] initWithFile:filename]];
}

-(void)_addTag: (Tag *) tag {
    [_tags addObject:tag];
    NSEntityDescription * tagDescription = [[_managedObjectModel entitiesByName] objectForKey:@"Tag"];
    TagEntity * tagEntity = [[TagEntity alloc] initWithEntity:tagDescription insertIntoManagedObjectContext:_managedObjectContext];
    
    tagEntity.tag = tag;
    [_tagArrayController addObject:tagEntity];
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
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSUInteger oldSize = [_tags count];
            NSArray * urls = [panel URLs];
            for (NSURL * url in urls) {
                [self _addFile:url];
            }
            NSRange range = NSMakeRange(oldSize, [_tags count] - oldSize);
            if (range.length > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWTAGS" object:[_tags subarrayWithRange:range]];
            }
        }
    }];
}

-(IBAction) showToolWindow:(id)sender {
    [_encodingArrayController setSelectedObjects:@[]];
    NSUInteger toolCode = [NSApp runModalForWindow:self.toolWindow];
    [self.toolWindow orderOut:nil];
    for (TagEntity * entity in _tagArrayController.arrangedObjects) {
        if (toolCode) {
            //TODO write tag back to file
        } else {
            [entity resetValue];
        }
    }
}

-(IBAction) toolWindowCancel:(id)sender {
    [NSApp stopModalWithCode:0];
}

-(IBAction) toolWindowSave:(id)sender {
    [NSApp stopModalWithCode:1];
}

@end
