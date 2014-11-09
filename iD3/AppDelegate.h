//
//  AppDelegate.h
//  iD3
//
//  Created by Qiang Yu on 7/25/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TagEntity.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> 

@property(assign)  BOOL closeProgressWindow;

@property (assign) IBOutlet NSWindow * window;
@property (assign) IBOutlet NSWindow * encodingWindow;
@property (assign) IBOutlet NSWindow * filenameWindow;
@property (assign) IBOutlet NSTextField * album;
@property (assign) IBOutlet NSTextField * artist;
@property (assign) IBOutlet NSTextField * genre;

// saving progress window
@property (assign) IBOutlet NSWindow * progressWindow;
@property (assign) IBOutlet NSProgressIndicator * progressIndicator;
@property (assign) IBOutlet NSTextField * filenameField;

// frame checkboxs
@property (assign) IBOutlet NSButton * chkTitle;
@property (assign) IBOutlet NSButton * chkAlbum;
@property (assign) IBOutlet NSButton * chkArtist;
@property (assign) IBOutlet NSButton * chkGenre;
@property (assign) IBOutlet NSButton * chkComment;
@property (assign) IBOutlet NSButton * chkComposer;
@property (assign) IBOutlet NSButton * chkCopyright;

@property (assign) IBOutlet NSImageView * coverArtView;

// format tag
@property (assign) IBOutlet NSComboBox * cbFormat;

/// core data
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (weak, nonatomic) IBOutlet NSArrayController * tagArrayController;
@property (weak, nonatomic) IBOutlet NSArrayController * encodingArrayController;
@property (weak, nonatomic) IBOutlet NSArrayController * n2tHistoryController;
@property (weak, nonatomic) IBOutlet NSArrayController * t2nHistoryController;

@property (readonly, nonatomic) NSMutableArray * supportedFileTypes;

/// actions
-(IBAction) openFiles:(id)sender;
-(IBAction) showEncodingWindow:(id)sender;
-(IBAction) showFileNameAndTagWindow:(id)sender;
-(IBAction) saveChanges:(id)sender;
-(IBAction) resetValues:(id)sender;
-(IBAction) clearFileList:(id)sender;
-(IBAction) setAlbumToAll:(id)sender;
-(IBAction) setArtistToAll:(id)sender;
-(IBAction) setGenreToAll:(id)sender;
-(IBAction) formatTags:(id)sender;
-(IBAction) deleteCoverArt:(id)sender;
-(IBAction) closeProgressWindow:(id)sender;

///
-(void) removeTagEntity: (TagEntity *) tagEntity;
-(void) removeSelectedTags;

///
-(void) addN2TPattern:(NSString *)pattern;
-(void) addT2NPattern:(NSString *)pattern;

@end
