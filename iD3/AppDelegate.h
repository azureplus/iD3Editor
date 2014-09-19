//
//  AppDelegate.h
//  iD3
//
//  Created by Qiang Yu on 7/25/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TagEntity.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> 

@property (assign) IBOutlet NSWindow * window;
@property (assign) IBOutlet NSWindow * encodingWindow;
@property (assign) IBOutlet NSWindow * filenameWindow;
@property (assign) IBOutlet NSTextField * album;
@property (assign) IBOutlet NSTextField * artist;
@property (assign) IBOutlet NSTextField * genre;

// saving progress window
@property (assign) IBOutlet NSWindow * progressWindow;
@property (assign) IBOutlet NSProgressIndicator * progressIndicator;
@property (assign) IBOutlet NSTextField * fileBeingSaved;

/// core data
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (weak, nonatomic) IBOutlet NSArrayController * tagArrayController;
@property (weak, nonatomic) IBOutlet NSArrayController * encodingArrayController;

@property (readonly, nonatomic) NSMutableArray * supportedFileTypes;

/// actions
-(IBAction) openFiles:(id)sender;
-(IBAction) showEncodingWindow:(id)sender;
-(IBAction) showFileNameAndTagWindow:(id)sender;
-(IBAction) saveChanges:(id)sender;
-(IBAction) resetChanges:(id)sender;
-(IBAction) clearFileList:(id)sender;
-(IBAction) setAlbumToAll:(id)sender;
-(IBAction) setArtistToAll:(id)sender;
-(IBAction) setGenreToAll:(id)sender;

/// filename to tag
-(void) filenameToTag:(NSString *)pattern;

/// tag to filename (rename files)
-(void) tagToFilename: (NSString *)pattern;

/// filename path depth
-(NSUInteger) pathDepth;
-(void) setPathDepth: (NSUInteger) depth;

//
-(void) removeTagEntity: (TagEntity *) tagEntity;
-(void) removeSelectedTags;
@end
