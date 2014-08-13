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

// n2t (name to tag) tab
@property (nonatomic, assign) IBOutlet NSTextField * n2tPattern;
@property (nonatomic, assign) IBOutlet NSTextField * n2tFilename;
@property (nonatomic, assign) IBOutlet NSTextField * n2tArtist;
@property (nonatomic, assign) IBOutlet NSTextField * n2tAlbum;
@property (nonatomic, assign) IBOutlet NSTextField * n2tTitle;
@property (nonatomic, assign) IBOutlet NSTextField * n2tTrack;
@property (nonatomic, assign) IBOutlet NSTextField * n2tComposer;
@property (nonatomic, assign) IBOutlet NSTextField * n2tGenre;
@property (nonatomic, assign) IBOutlet NSTextField * n2tYear;


// t2n (tag to name) tab
@property (nonatomic, assign) IBOutlet NSTextField * t2nPattern;
@property (nonatomic, assign) IBOutlet NSTextField * t2nFilename;
@property (nonatomic, assign) IBOutlet NSTextField * t2nArtist;
@property (nonatomic, assign) IBOutlet NSTextField * t2nAlbum;
@property (nonatomic, assign) IBOutlet NSTextField * t2nTitle;
@property (nonatomic, assign) IBOutlet NSTextField * t2nTrack;
@property (nonatomic, assign) IBOutlet NSTextField * t2nComposer;
@property (nonatomic, assign) IBOutlet NSTextField * t2nGenre;
@property (nonatomic, assign) IBOutlet NSTextField * t2nYear;


@property (nonatomic, assign) IBOutlet NSButton * filenameOnly;

- (IBAction) close:(id)sender;
- (IBAction) apply: (id)sender;
- (IBAction) filenameOnlyClicked: (id)sender;
@end
