//
//  TableViewActionOutlet.m
//  iD3
//
//  Created by Qiang Yu on 8/11/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TableViewActionOutlet.h"
#import "AppDelegate.h"

@implementation TableViewActionOutlet
-(IBAction) selectedAll:(id)sender {
    [_tagArrayController setSelectedObjects:[_tagArrayController arrangedObjects]];
}

-(IBAction) selectedNone:(id)sender {
    [_tagArrayController setSelectedObjects:@[]];
}

-(IBAction) invertSelection:(id)sender {
    NSArray * selected = [NSArray arrayWithArray:[_tagArrayController selectedObjects]];
    NSMutableArray * unselected = [NSMutableArray arrayWithCapacity:32];
    for (id obj in [_tagArrayController arrangedObjects]) {
        if (![selected containsObject:obj]) {
            [unselected addObject:obj];
        }
    }
    
    [_tagArrayController setSelectedObjects:@[]];
    [_tagArrayController setSelectedObjects:unselected];
}

-(IBAction) removeSelectedTags:(id)sender {
    AppDelegate * delegate = (AppDelegate *)[NSApp delegate];
    for (id obj in [_tagArrayController selectedObjects]) {
        [delegate removeTagEntity:obj];
    }
}
@end
