//
//  AppDelegate.m
//  iD3
//
//  Created by Qiang Yu on 7/25/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "AppDelegate.h"
#import "Tag.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _tags = [[NSMutableArray alloc] initWithCapacity:32];
}

-(void)_addFile:(NSURL *)fileURL {
    NSString * filename = [fileURL path];
    
    for (Tag * tag in _tags) {
        if ([[tag filename] isEqualToString:filename])
            return;
    }
    
    Tag * tag = [[Tag alloc] initWithFile:filename];
    [_tags addObject:tag];
}

-(IBAction) openFiles:(id)sender {
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSUInteger oldSize = [_tags count];
            NSArray * urls = [panel URLs];
            for (NSURL * url in urls) {
                [self _addFile:url];
            }
            NSRange range = NSMakeRange(oldSize, [_tags count] - oldSize);
            if (range.length > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWTAGS" object:[_tags subarrayWithRange:range]];
            }
        }
    }];
}

@end
