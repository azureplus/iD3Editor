//
//  TagEntity.m
//  iD3
//
//  Created by Qiang Yu on 7/29/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagEntity.h"


@implementation TagEntity

@dynamic album;
@dynamic artist;
@dynamic attribute;
@dynamic comment;
@dynamic filename;
@dynamic genre;
@dynamic title;
@dynamic track;
@dynamic year;
@synthesize tag = _tag;

-(void)didChangeValueForKey:(NSString *)key {
    if ([self isUpdated]) {
        [_tag setFrame:key withValue:[self valueForKey:key]];
        [_tag writeTag];
    }
    [super didChangeValueForKey:key];
}

@end
