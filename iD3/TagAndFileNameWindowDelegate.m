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

- (IBAction) cancel:(id)sender {
    [NSApp stopModalWithCode:0];
}

- (IBAction) preview: (id)sender {
    NSString * tabID = [[self.tabview selectedTabViewItem] identifier];

    if ([tabID isEqualToString:@"NAME_TAG"]) {
        NSString * pattern = [self.n2tPattern stringValue];
        [(AppDelegate *)[NSApp delegate] filenameToTag:pattern];
    } else if ([tabID isEqualTo:@"TAG_NAME"]){
        
    }
}

- (void) controlTextDidChange: (NSNotification *)notice {
    NSTextField * textField = [notice object];
    NSString * pattern = [textField stringValue];
    
    if (textField == _n2tPattern) {
        [self _clearN2TFields];
        NSString * filename = [_n2tFilename stringValue];
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
            } else if ([key isEqualToString:@"comment"]) {
                field = _n2tComment;
            } else if ([key isEqualToString:@"genre"]) {
                field = _n2tGenre;
            } else if ([key isEqualToString:@"year"]) {
                field = _n2tYear;
            }
            
            [field setStringValue:tagFrames[key]];
        }
    }
}

-(void) _clearN2TFields {
    [_n2tArtist setStringValue:@""];
    [_n2tAlbum setStringValue:@""];
    [_n2tTitle setStringValue:@""];
    [_n2tTrack setStringValue:@""];
    [_n2tComment setStringValue:@""];
    [_n2tYear setStringValue:@""];
    [_n2tGenre setStringValue:@""];
}

@end
