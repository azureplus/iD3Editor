//
//  TagEntity.m
//  iD3
//
//  Created by Qiang Yu on 7/29/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "TagEntity.h"

#define DECL_GETTER_1(FRAME) \
-(NSString *) FRAME { \
    return [self.tag FRAME]; \
}


//
// The setters change null value to @""
// as null value in TagBase indicates value not changed
//
#define DECL_SETTER_1(FRAME) \
-(void) set##FRAME:(NSString *)value { \
    if (!value) { \
        value = @""; \
    } \
    NSString * frame = [@#FRAME lowercaseString]; \
    [self willChangeValueForKey:frame]; \
    [self.tag set##FRAME:value]; \
    [self didChangeValueForKey:frame]; \
}

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
@dynamic coverArt;
@synthesize tag = _tag;

-(void) resetValue {
    NSArray * frames = @[@"artist", @"album", @"title",
                         @"genre", @"comment", @"composer",
                         @"copyright", @"year", @"track", @"coverArt"];
    for (NSString * frame in frames) {
        [self willChangeValueForKey:frame];
    }
    [self.tag discardChanges];
    for (NSString * frame in frames) {
        [self didChangeValueForKey:frame];
    }
}

DECL_GETTER_1(artist);
DECL_GETTER_1(album);
DECL_GETTER_1(title);
DECL_GETTER_1(genre);
DECL_GETTER_1(comment);
DECL_GETTER_1(composer);
DECL_GETTER_1(copyright);

-(NSString *) year {
    if ([[self.tag year] intValue] == 0) {
        return @"";
    } else {
        return [[self.tag year] stringValue];
    }
}

-(NSString *) track {
    if ([[self.tag track] intValue] == 0) {
        return @"";
    } else {
        return [[self.tag track] stringValue];
    }
}

-(id) coverArt {
    return [self.tag coverArt];
}

DECL_SETTER_1(Artist);
DECL_SETTER_1(Album);
DECL_SETTER_1(Title);
DECL_SETTER_1(Genre);
DECL_SETTER_1(Comment);
DECL_SETTER_1(Composer);
DECL_SETTER_1(Copyright);

-(void)setYear:(NSString *)value {
    [self willChangeValueForKey:@"year"];
    [self.tag setYear:[NSNumber numberWithInt:[value intValue]]];
    [self didChangeValueForKey:@"year"];
}

-(void)setTrack:(NSString *)value {
    [self willChangeValueForKey:@"track"];
    [self.tag setTrack:[NSNumber numberWithInt:[value intValue]]];
    [self didChangeValueForKey:@"track"];
}

-(void)setCoverArt:(id)coverArt {
    [self willChangeValueForKey:@"coverArt"];
    [self.tag setCoverArt:coverArt];
    [self didChangeValueForKey:@"coverArt"];
}

-(void) setCharEncoding: (unsigned int) charEncoding {
    NSArray * frames = @[@"artist", @"album", @"title",
                         @"genre", @"comment", @"composer",
                         @"copyright", @"year", @"track"];
    for (NSString * frame in frames) {
        [self willChangeValueForKey:frame];
    }
    [self.tag setCharEncoding:charEncoding];
    for (NSString * frame in frames) {
        [self didChangeValueForKey:frame];
    }
}

-(BOOL) updated {
    return [_tag updated];
}
@end
