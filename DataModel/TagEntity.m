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

@synthesize tagUpdated = _tagUpdated;
@synthesize tag = _tag;

-(void)setTag:(Tag *)tag {
    _tag = tag;
    [self resetValue];
    _tagUpdated = NO;
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

-(void) _setValue: (NSString *)value forKey:(NSString *)key ofDictionary:(NSMutableDictionary *) dict {
    if (value.length == 0) {
        dict[key] = @"";
    } else {
        dict[key] = value;
    }
}

-(void) save {
    if (_tagUpdated) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:12];
        [self _setValue:self.artist forKey:@"ARTIST" ofDictionary:dict];
        [self _setValue:self.album forKey:@"ALBUM" ofDictionary:dict];
        [self _setValue:self.title forKey:@"TITLE" ofDictionary:dict];
        [self _setValue:self.comment forKey:@"COMMENT" ofDictionary:dict];
        [self _setValue:self.genre forKey:@"GENRE" ofDictionary:dict];
        [self _setValue:self.track forKey:@"TRACKNUMBER" ofDictionary:dict];
        [self _setValue:self.year forKey:@"DATE" ofDictionary:dict];
        [self _setValue:self.performer forKey:@"PERFORMER" ofDictionary:dict];
        [self _setValue:self.composer forKey:@"COMPOSER" ofDictionary:dict];
        [self _setValue:self.copyright forKey:@"COPYRIGHT" ofDictionary:dict];
    
        [_tag setFrames:dict];
        [_tag writeTag];
    }
}


- (void)didChangeValueForKey:(NSString *)key {
    _tagUpdated = YES;
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
