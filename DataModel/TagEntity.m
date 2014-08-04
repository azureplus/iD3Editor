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
@dynamic pathDepth;
@synthesize tag = _tag;

-(void)setTag:(Tag *)tag {
    _tag = tag;
    [self resetValue];
}

-(void) resetValue {
    self.filename = [self _filename:_tag.filename withPathDepth:[self.pathDepth intValue]];
    self.artist = [_tag getFrame:@"artist"];
    self.album = [_tag getFrame:@"album"];
    self.title = [_tag getFrame:@"title"];
    self.comment = [_tag getFrame:@"comment"];
    self.genre = [_tag getFrame:@"genre"];
    self.year = [_tag getFrame:@"year"];
    self.track = [_tag getFrame:@"track"];
}

- (void)didChangeValueForKey:(NSString *)key {
    if ([key isEqualToString:@"pathDepth"]) {
        self.filename = [self _filename:_tag.filename withPathDepth:[self.pathDepth intValue]];
    }
    [super didChangeValueForKey:key];
}

-(NSString *)_filename:(NSString *) filename withPathDepth:(int) depth {
    NSArray * components = [filename pathComponents];
    NSMutableString * rv = [NSMutableString stringWithCapacity:256];
    
    NSUInteger cc = components.count;
    NSInteger start = cc - 1 - depth;
    start = start >= 0 ? start : 0;
    NSInteger index = start;
    
    while (index < cc) {
        if (index > start && ![components[index - 1] isEqualToString:@"/"])
            [rv appendString:@"/"];
        [rv appendString:components[index]];
        index++;
    }
    
    return rv;
}
@end
