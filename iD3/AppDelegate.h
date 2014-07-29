//
//  AppDelegate.h
//  iD3
//
//  Created by Qiang Yu on 7/25/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TagSource.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, TagSource> {
    NSMutableArray * _tags;
}

@property (readonly, nonatomic) NSArray * tags;
@property (assign) IBOutlet NSWindow *window;

-(IBAction) openFiles:(id)sender;

@end
