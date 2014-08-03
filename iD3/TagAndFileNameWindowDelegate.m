//
//  TagAndFileNameWindowDelegate.m
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagAndFileNameWindowDelegate.h"
#import "AppDelegate.h"

@implementation TagAndFileNameWindowDelegate
-(void) windowWillClose:(NSNotification *)notification {
    [NSApp stopModalWithCode:0];
}

- (IBAction) cancel:(id)sender {
    [NSApp stopModalWithCode:0];
}

- (IBAction) preview: (id)sender {
    NSString * tabID = [[self.tabview selectedTabViewItem] identifier];
    NSLog(@"--->%@", tabID);
    if ([tabID isEqualToString:@"NAME_TAG"]) {
        NSString * pattern = [self.n2tPattern stringValue];
        NSLog(@"-->pattern %@ <<<<", pattern);
        [(AppDelegate *)[NSApp delegate] filenameToTag:pattern];
    } else if ([tabID isEqualTo:@"TAG_NAME"]){
        
    }
}

@end
