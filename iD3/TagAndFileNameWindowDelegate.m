//
//  TagAndFileNameWindowDelegate.m
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagAndFileNameWindowDelegate.h"
#import "AppDelegate.h"
#import "NSString_Filename.h"

@implementation TagAndFileNameWindowDelegate
-(void) windowWillClose:(NSNotification *)notification {
    [NSApp stopModalWithCode:0];
}

- (void)windowDidBecomeMain:(NSNotification *)notification {
     NSUInteger pathDepth = [(AppDelegate *) [NSApp delegate] pathDepth];
    if (pathDepth == 0) {
        [_filenameOnly setState:NSOnState];
    } else {
        [_filenameOnly setState:NSOffState];
    }
    
    //
    [_t2nPattern setToolTip:@":a artist\n:A alnum\n:g genre\n:t Title\n:T track\n:y year"];
    [_n2tPattern setToolTip:@":a artist\n:A alnum\n:g genre\n:t Title\n:T track\n:y year"];
}

- (IBAction) close:(id)sender {
    [NSApp stopModalWithCode:0];
}

- (IBAction) apply: (id)sender {
    NSString * tabID = [[self.tabview selectedTabViewItem] identifier];

    if ([tabID isEqualToString:@"NAME_TAG"]) {
        NSString * pattern = [self.n2tPattern stringValue];
        [(AppDelegate *)[NSApp delegate] filenameToTag:pattern];
    } else if ([tabID isEqualTo:@"TAG_NAME"]){
        NSString * pattern = [self.t2nPattern stringValue];
        [(AppDelegate *)[NSApp delegate] tagToFilename:pattern];
    }
    
//    [(AppDelegate *)[NSApp delegate] saveChanges:nil];
}

- (IBAction) filenameOnlyClicked: (id)sender {
    AppDelegate * delegate = [NSApp delegate];
    NSButton * filenameOnlyCheckBox = sender;
    if (filenameOnlyCheckBox.state == NSOnState) {
        [delegate setPathDepth:0];
    } else {
        [delegate setPathDepth:1];
    }
    
    [self _n2tPatternUpdated];
}

-(void) _n2tPatternUpdated {
    [self _clearN2TFields];
    NSString * filename = [_n2tFilename stringValue];
    NSString * pattern = [_n2tPattern stringValue];
    
    NSDictionary * tagFrames = [filename parse:pattern];
    for (NSString * key in tagFrames) {
        NSTextField * field = nil;
        if ([key isEqualToString:@"artist"]) {
            field = _n2tArtist;
        } else if ([key isEqualToString:@"album"]) {
            field = _n2tAlbum;
        } else if ([key isEqualToString:@"title"]) {
            field = _n2tTitle;
        } else if ([key isEqualToString:@"track"]) {
            field = _n2tTrack;
        } else if ([key isEqualToString:@"composer"]) {
            field = _n2tComposer;
        } else if ([key isEqualToString:@"genre"]) {
            field = _n2tGenre;
        } else if ([key isEqualToString:@"year"]) {
            field = _n2tYear;
        }
        
        [field setStringValue:tagFrames[key]];
    }
}

-(void) _t2nPatternUpdated {
    NSString * pattern = [_t2nPattern stringValue];
    
    NSMutableDictionary * frames = [NSMutableDictionary dictionaryWithCapacity:7];
    frames[@"artist"] = [_t2nArtist stringValue];
    frames[@"album"] = [_t2nAlbum stringValue];
    frames[@"title"] = [_t2nTitle stringValue];
    frames[@"composer"] = [_t2nComposer stringValue];
    frames[@"genre"] = [_t2nGenre stringValue];
    frames[@"track"] = [_t2nTrack stringValue];
    frames[@"year"] = [_t2nYear stringValue];
    
    [_t2nFilename setStringValue:[NSString fromFrames:frames withPattern:pattern andTrackSize:0]];
}

// instant pattern recognition
- (void) controlTextDidChange: (NSNotification *)notice {
    NSTextField * textField = [notice object];
    if (textField == _n2tPattern) {
        [self _n2tPatternUpdated];
    } else if (textField == _t2nPattern) {
        [self _t2nPatternUpdated];
    }
}

-(void) _clearN2TFields {
    [_n2tArtist setStringValue:@""];
    [_n2tAlbum setStringValue:@""];
    [_n2tTitle setStringValue:@""];
    [_n2tTrack setStringValue:@""];
    [_n2tComposer setStringValue:@""];
    [_n2tYear setStringValue:@""];
    [_n2tGenre setStringValue:@""];
}
@end
