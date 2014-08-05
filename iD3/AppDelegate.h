//
//  AppDelegate.h
//  iD3
//
//  Created by Qiang Yu on 7/25/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableArray * _tags;
}

// tag lib tags
@property (readonly, nonatomic) NSArray * tags;
@property (assign) IBOutlet NSWindow * window;
@property (assign) IBOutlet NSWindow * encodingWindow;
@property (assign) IBOutlet NSWindow * filenameWindow;

/// core data
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (weak, nonatomic) IBOutlet NSArrayController * tagArrayController;
@property (weak, nonatomic) IBOutlet NSArrayController * encodingArrayController;

/// actions
-(IBAction) openFiles:(id)sender;
-(IBAction) showEncodingWindow:(id)sender;
-(IBAction) showFileNameAndTagWindow:(id)sender;

/// filename to tag
-(void) filenameToTag:(NSString *)pattern;

/// tag to filename (rename files)
-(void) tagToFilename: (NSString *)pattern;

/// filename path depth
-(NSUInteger) pathDepth;
-(void) setPathDepth: (NSUInteger) depth;
@end
