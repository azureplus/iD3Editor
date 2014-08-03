//
//  TagAndFileNameWindowDelegate.m
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagAndFileNameWindowDelegate.h"

@implementation TagAndFileNameWindowDelegate
-(void) windowWillClose:(NSNotification *)notification {
    [NSApp stopModalWithCode:0];
}

- (IBAction) cancel:(id)sender {
    [NSApp stopModalWithCode:0];
}

- (IBAction) preview: (id)sender {
    
}

@end
