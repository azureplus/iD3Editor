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

-(void)setTag:(Tag *)tag {
    _tag = tag;
    [self resetValue];
}

-(void) resetValue {
    self.filename = _tag.filename;
    self.artist = [_tag getFrame:@"artist"];
    self.album = [_tag getFrame:@"album"];
    self.title = [_tag getFrame:@"title"];
    self.comment = [_tag getFrame:@"comment"];
    self.genre = [_tag getFrame:@"genre"];
    self.year = [_tag getFrame:@"year"];
    self.track = [_tag getFrame:@"track"];
}
@end
