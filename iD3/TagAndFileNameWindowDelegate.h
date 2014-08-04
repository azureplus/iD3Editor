//
//  TagAndFileNameWindowDelegate.h
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagAndFileNameWindowDelegate : NSObject<NSWindowDelegate> {
    
}

@property (nonatomic, assign) IBOutlet NSTabView * tabview;

// n2t tab
@property (nonatomic, assign) IBOutlet NSTextField * n2tPattern;
@property (nonatomic, assign) IBOutlet NSTextField * n2tFilename;
@property (nonatomic, assign) IBOutlet NSTextField * n2tArtist;
@property (nonatomic, assign) IBOutlet NSTextField * n2tAlbum;
@property (nonatomic, assign) IBOutlet NSTextField * n2tTitle;
@property (nonatomic, assign) IBOutlet NSTextField * n2tTrack;
@property (nonatomic, assign) IBOutlet NSTextField * n2tComment;
@property (nonatomic, assign) IBOutlet NSTextField * n2tGenre;
@property (nonatomic, assign) IBOutlet NSTextField * n2tYear;

@property (nonatomic, assign) IBOutlet NSButton * filenameOnly;

- (IBAction) cancel:(id)sender;
- (IBAction) preview: (id)sender;
- (IBAction) filenameOnlyClicked: (id)sender;
@end
