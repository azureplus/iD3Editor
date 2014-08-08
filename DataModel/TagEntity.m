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
@dynamic performer;
@dynamic composer;
@dynamic comment;
@dynamic filename;
@dynamic genre;
@dynamic title;
@dynamic track;
@dynamic year;
@dynamic copyright;
@dynamic pathDepth;
@synthesize tag = _tag;

-(void)setTag:(Tag *)tag {
    _tag = tag;
    [self resetValue];
}

-(void) resetValue {
    self.filename = [self _filename:_tag.filename withPathDepth:[self.pathDepth intValue]];
    self.artist = [_tag getFrame:@"ARTIST"];
    self.album = [_tag getFrame:@"ALBUM"];
    self.title = [_tag getFrame:@"TITLE"];
    self.comment = [_tag getFrame:@"COMMENT"];
    self.genre = [_tag getFrame:@"GENRE"];
    self.year = [_tag getFrame:@"DATE"];
    self.track = [_tag getFrame:@"TRACKNUMBER"];
    self.performer = [_tag getFrame:@"PERFORMER"];
    self.composer = [_tag getFrame:@"COMPOSER"];
    self.copyright = [_tag getFrame:@"COPYRIGHT"];
}

-(void) save {
    [_tag setFrame:@"ARTIST" withValue:self.artist];
    [_tag setFrame:@"ALBUM" withValue:self.album];
    [_tag setFrame:@"TITLE" withValue:self.title];
    [_tag setFrame:@"COMMENT" withValue:self.comment];
    [_tag setFrame:@"GENRE" withValue:self.genre];
    [_tag setFrame:@"TRACKNUMBER" withValue:self.track];
    [_tag setFrame:@"DATE" withValue:self.year];
    [_tag setFrame:@"PERFORMER" withValue:self.performer];
    [_tag setFrame:@"COMPOSER" withValue:self.composer];
    [_tag setFrame:@"COPYRIGHT" withValue:self.copyright];
    [_tag writeTag];
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
