//
//  AppDelegate.h
//  iD3
//
//  Created by Qiang Yu on 7/25/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TagSource.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, TagSource> {
    NSMutableArray * _tags;
}

@property (readonly, nonatomic) NSArray * tags;
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSWindow *toolWindow;

/// core data
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (weak, nonatomic) IBOutlet NSArrayController * tagArrayController;
@property (weak, nonatomic) IBOutlet NSArrayController * encodingArrayController;

/// actions
-(IBAction) openFiles:(id)sender;
-(IBAction) showToolWindow:(id)sender;
-(IBAction) toolWindowCancel:(id)sender;
-(IBAction) toolWindowSave:(id)sender;
@end
