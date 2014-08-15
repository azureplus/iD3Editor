//
//  TabViewDelegate.m
//  iD3
//
//  Created by Qiang Yu on 8/14/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TabViewDelegate.h"

@implementation TabViewDelegate
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTimeReminder"]) {
        NSString * tabIdentifier = tabViewItem.identifier;
        if ([tabIdentifier isEqualToString:@"TAG_NAME"]) {
            [self _showFirstTimeMessage];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"FirstTimeReminder"];
        }
    }
}

//
-(void) _showFirstTimeMessage {
    ////
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES);
    NSString * musicPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    musicPath = [musicPath stringByResolvingSymlinksInPath];
    NSString * message = [NSString stringWithFormat:@"This tool can help you rename music files using their tags. But this functionality is only available for music files under folder %@.\n", musicPath];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Reminder"];
    [alert setInformativeText:message];
    [alert setAlertStyle:NSInformationalAlertStyle];
    ////
    
    [alert beginSheetModalForWindow:_tagFileNameWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}
@end
