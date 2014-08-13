//
//  EncodingWindowDelegate.m
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "EncodingWindowDelegate.h"
#import "AppDelegate.h"

@implementation EncodingWindowDelegate
-(void) windowWillClose:(NSNotification *)notification {
    [NSApp stopModalWithCode:0];
}

- (IBAction) cancel:(id)sender {
    [(AppDelegate *)[NSApp delegate] resetChanges:nil];
    [NSApp stopModalWithCode:0];
}

- (IBAction) ok: (id)sender {
//    [(AppDelegate *)[NSApp delegate] saveChanges:nil];
    [NSApp stopModalWithCode:1];
}
@end
