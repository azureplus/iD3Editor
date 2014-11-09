//
//  TagAndFileNameWindowDelegate.m
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "TagAndFileNameWindowDelegate.h"
#import "AppDelegate.h"
#import "AppDelegate_Filename.h"
#import "NSString_Filename.h"

@interface TagAndFileNameWindowDelegate()

// n2t (name to tag) tab
@property (nonatomic, assign) IBOutlet NSComboBox * n2tPattern;
@property (nonatomic, assign) IBOutlet NSTextField * n2tFilename;
@property (nonatomic, assign) IBOutlet NSTextField * n2tArtist;
@property (nonatomic, assign) IBOutlet NSTextField * n2tAlbum;
@property (nonatomic, assign) IBOutlet NSTextField * n2tTitle;
@property (nonatomic, assign) IBOutlet NSTextField * n2tTrack;
@property (nonatomic, assign) IBOutlet NSTextField * n2tComposer;
@property (nonatomic, assign) IBOutlet NSTextField * n2tGenre;
@property (nonatomic, assign) IBOutlet NSTextField * n2tYear;


// t2n (tag to name) tab
@property (nonatomic, assign) IBOutlet NSComboBox * t2nPattern;
@property (nonatomic, assign) IBOutlet NSTextField * t2nFilename;
@property (nonatomic, assign) IBOutlet NSTextField * t2nArtist;
@property (nonatomic, assign) IBOutlet NSTextField * t2nAlbum;
@property (nonatomic, assign) IBOutlet NSTextField * t2nTitle;
@property (nonatomic, assign) IBOutlet NSTextField * t2nTrack;
@property (nonatomic, assign) IBOutlet NSTextField * t2nComposer;
@property (nonatomic, assign) IBOutlet NSTextField * t2nGenre;
@property (nonatomic, assign) IBOutlet NSTextField * t2nYear;

@property (nonatomic, assign) IBOutlet NSButton * filenameOnly;


// rename tab
@property (nonatomic, assign) IBOutlet NSComboBox * renameFormat;
@property (nonatomic, assign) IBOutlet NSTextField * renameReplacementFrom;
@property (nonatomic, assign) IBOutlet NSTextField * renameReplacementTo;
@property (nonatomic, assign) IBOutlet NSTextField * renameNew;
@property (nonatomic, assign) IBOutlet NSTextField * renameOld;

@end


@implementation TagAndFileNameWindowDelegate
-(void) windowWillClose:(NSNotification *)notification {
    [NSApp stopModalWithCode:0];
}

- (void)windowDidBecomeMain:(NSNotification *)notification {
     unsigned int pathDepth = [(AppDelegate *)[NSApp delegate] pathDepth];
    if (pathDepth == 0) {
        [self.filenameOnly setState:NSOnState];
    } else {
        [self.filenameOnly setState:NSOffState];
    }
    
    //
    [self.t2nPattern setToolTip:@":a artist\n:A alnum\n:g genre\n:t Title\n:T track\n:y year"];
    [self.n2tPattern setToolTip:@":a artist\n:A alnum\n:g genre\n:t Title\n:T track\n:y year"];
}

- (IBAction) close:(id)sender {
    [NSApp stopModalWithCode:0];
}

- (IBAction) apply: (id)sender {
    NSString * tabID = [[self.tabview selectedTabViewItem] identifier];

    if ([tabID isEqualToString:@"NAME_TAG"]) {
        NSString * pattern = [self.n2tPattern stringValue];
        [(AppDelegate *)[NSApp delegate] addN2TPattern:pattern];
        [(AppDelegate *)[NSApp delegate] filenameToTag:pattern];
    } else if ([tabID isEqualTo:@"TAG_NAME"]) {
        NSString * pattern = [self.t2nPattern stringValue];
        [(AppDelegate *)[NSApp delegate] addT2NPattern:pattern];
        [(AppDelegate *)[NSApp delegate] tagToFilename:pattern];
    } else if ([tabID isEqualTo:@"RENAME"]) {
        NSString * replaceFrom = [self.renameReplacementFrom stringValue];
        NSString * replaceTo = [self.renameReplacementTo stringValue];
        NSUInteger capitalization = [self.renameFormat indexOfSelectedItem];
        
        [(AppDelegate *)[NSApp delegate] renameFilesByReplacing:replaceFrom with:replaceTo andCapitalization:capitalization];
    }
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    if ([notification object] == self.n2tPattern) {
        [self _n2tPatternUpdated: YES];
    } else if ([notification object] == self.t2nPattern){
        [self _t2nPatternUpdated: YES];
    } else if ([notification object] == self.renameFormat) {
        [self _renameFormatUpdated];
    }
}

- (IBAction) filenameOnlyClicked: (id)sender {
    NSButton * filenameOnlyCheckBox = sender;
    if (filenameOnlyCheckBox.state == NSOnState) {
        [(AppDelegate *)[NSApp delegate] setPathDepth:0];
    } else {
        [(AppDelegate *)[NSApp delegate] setPathDepth:1];
    }
    [self _n2tPatternUpdated:NO];
}

-(void) _n2tPatternUpdated :(BOOL) bySelection {
    [self _clearN2TFields];
    NSString * filename = [self.n2tFilename stringValue];
    NSString * pattern = [self.n2tPattern stringValue];
    
    if (bySelection) {
        NSInteger index = [self.n2tPattern indexOfSelectedItem];
        // if index == -1, use stringValue
        if (index >= 0) {
            pattern = [self.n2tPattern itemObjectValueAtIndex:index];
        }
    }
    
    NSDictionary * tagFrames = [filename parse:pattern];
    for (NSString * key in tagFrames) {
        NSTextField * field = nil;
        if ([key isEqualToString:@"artist"]) {
            field = self.n2tArtist;
        } else if ([key isEqualToString:@"album"]) {
            field = self.n2tAlbum;
        } else if ([key isEqualToString:@"title"]) {
            field = self.n2tTitle;
        } else if ([key isEqualToString:@"track"]) {
            field = self.n2tTrack;
        } else if ([key isEqualToString:@"composer"]) {
            field = self.n2tComposer;
        } else if ([key isEqualToString:@"genre"]) {
            field = self.n2tGenre;
        } else if ([key isEqualToString:@"year"]) {
            field = self.n2tYear;
        }
        
        [field setStringValue:tagFrames[key]];
    }
}

- (void) _renameFormatUpdated {
    NSString * replaceFrom = [self.renameReplacementFrom stringValue];
    NSString * replaceTo = [self.renameReplacementTo stringValue];
    NSString * fileName = [self.renameOld stringValue];
    NSString * extension = [fileName pathExtension];
    fileName = [fileName stringByDeletingPathExtension];
    
    fileName = [NSString formatString:fileName byReplacing:replaceFrom with:replaceTo andCapitalization:[self.renameFormat indexOfSelectedItem]];
    
    fileName = [fileName stringByAppendingPathExtension:extension];
    [self.renameNew setStringValue:fileName];
}

-(void) _t2nPatternUpdated: (BOOL) bySelection {
    NSString * pattern = [self.t2nPattern stringValue];
    
    if (bySelection) {
        NSInteger index = [self.t2nPattern indexOfSelectedItem];
        // if index == -1, use stringValue        
        if (index >= 0) {
            pattern = [self.t2nPattern itemObjectValueAtIndex:index];
        }
    }
    
    NSMutableDictionary * frames = [NSMutableDictionary dictionaryWithCapacity:7];
    frames[@"artist"] = [self.t2nArtist stringValue];
    frames[@"album"] = [self.t2nAlbum stringValue];
    frames[@"title"] = [self.t2nTitle stringValue];
    frames[@"composer"] = [self.t2nComposer stringValue];
    frames[@"genre"] = [self.t2nGenre stringValue];
    frames[@"track"] = [self.t2nTrack stringValue];
    frames[@"year"] = [self.t2nYear stringValue];
    
    [self.t2nFilename setStringValue:[NSString fromFrames:frames withPattern:pattern andTrackSize:0]];
}

// instant pattern recognition
- (void) controlTextDidChange: (NSNotification *)notice {
    NSComboBox * textField = [notice object];
    if (textField == self.n2tPattern) {
        [self _n2tPatternUpdated: NO];
    } else if (textField == self.t2nPattern) {
        [self _t2nPatternUpdated: NO];
    } else if (textField == self.renameReplacementFrom || textField == self.renameReplacementTo) {
        [self _renameFormatUpdated];
    }
}

-(void) _clearN2TFields {
    [self.n2tArtist setStringValue:@""];
    [self.n2tAlbum setStringValue:@""];
    [self.n2tTitle setStringValue:@""];
    [self.n2tTrack setStringValue:@""];
    [self.n2tComposer setStringValue:@""];
    [self.n2tYear setStringValue:@""];
    [self.n2tGenre setStringValue:@""];
}
@end
