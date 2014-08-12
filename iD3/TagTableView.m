//
//  TagTableView.m
//  iD3
//
//  Created by Qiang Yu on 8/11/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagTableView.h"
#import "AppDelegate.h"

@implementation TagTableView
- (void)keyDown:(NSEvent *)event {
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    if(key == NSDeleteCharacter) {
        if([self selectedRow] == -1) {
            NSBeep();
        } else {
            AppDelegate * delegate = (AppDelegate *)[NSApp delegate];
            [delegate removeSelectedTags];
        }
    } else {
        [super keyDown:event];
    }
}
@end
