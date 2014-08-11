//
//  TagEntity.m
//  iD3
//
//  Created by Qiang Yu on 7/29/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagEntity.h"
#import "Tag_FileTypeResolver.h"

@implementation TagEntity

@dynamic album;
@dynamic artist;
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

-(NSString *)F2f: (NSString *)F {
    static NSDictionary * F2f  = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        F2f = @{@"ARTIST": @"artist",
                @"ALBUM":@"album",
                @"TITLE":@"title",
                @"DATE":@"year",
                @"TRACKNUMBER":@"track",
                @"COMPOSER":@"composer",
                @"COPYRIGHT":@"copyright",
                @"GENRE":@"genre",
                @"COMMENT":@"comment"
                };
    });
    
    return F2f[F];
}

-(void) resetValue {
    self.filename = [self _filename:_tag.filename withPathDepth:[self.pathDepth intValue]];
    NSDictionary * frames = [_tag resolveGetFrames];
    
    for (NSString * key in frames) {
        NSString * frame = [self F2f:key];
        [self setValue:frames[key] forKey:frame];
    }
}

-(void) _setValue: (NSString *)value forKey:(NSString *)key ofDictionary:(NSMutableDictionary *) dict {
    if (value.length != 0) {
        dict[key] = value;
    } else {
        dict[key] = @"";
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
        [self _setValue:self.composer forKey:@"COMPOSER" ofDictionary:dict];
        [self _setValue:self.copyright forKey:@"COPYRIGHT" ofDictionary:dict];
    
        [_tag saveFrames:dict];
        _tagUpdated = NO;
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
