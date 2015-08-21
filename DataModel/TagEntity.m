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
#define DECL_SETTER_1(FRAME, FRAME1) \
-(void) set##FRAME:(NSString *)value { \
    if (!value) { \
        value = @""; \
    } \
    NSString * frame = @#FRAME1; \
    [self willChangeValueForKey:frame]; \
    [self.tag set##FRAME:value]; \
    [self didChangeValueForKey:frame]; \
}

@implementation TagEntity

@dynamic album;
@dynamic artist;
@dynamic albumArtist;
@dynamic composer;
@dynamic comment;
@dynamic filename;
@dynamic genre;
@dynamic title;
@dynamic track;
@dynamic year;
@dynamic copyright;
@dynamic coverArt;
@dynamic discNum;
@dynamic discTotal;
@synthesize tag = _tag;

-(void) resetValue {
    NSArray * frames = @[@"artist", @"album", @"albumArtist", @"title",
                         @"genre", @"comment", @"composer",
                         @"copyright", @"year", @"track", @"discNum", @"discTotal", @"coverArt"];
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
DECL_GETTER_1(albumArtist);
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

-(NSString *) discNum {
    if ([[self.tag discNum] intValue] == 0) {
        return @"";
    } else {
        return [[self.tag discNum] stringValue];
    }
}

-(NSString *) discTotal {
    if ([[self.tag discTotal] intValue] == 0) {
        return @"";
    } else {
        return [[self.tag discTotal] stringValue];
    }
}

-(id) coverArt {
    return [self.tag coverArt];
}

DECL_SETTER_1(Artist, artist);
DECL_SETTER_1(Album, album);
DECL_SETTER_1(AlbumArtist, albumArtist);
DECL_SETTER_1(Title, title);
DECL_SETTER_1(Genre, genre);
DECL_SETTER_1(Comment, comment);
DECL_SETTER_1(Composer, composer);
DECL_SETTER_1(Copyright, copyright);

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

-(void)setDiscNum:(NSString *)value {
    [self willChangeValueForKey:@"discNum"];
    [self.tag setDiscNum:[NSNumber numberWithInt:[value intValue]]];
    [self didChangeValueForKey:@"discNum"];
}

-(void)setDiscTotal:(NSString *)value {
    [self willChangeValueForKey:@"discTotal"];
    [self.tag setDiscTotal:[NSNumber numberWithInt:[value intValue]]];
    [self didChangeValueForKey:@"discTotal"];
}

-(void)setCoverArt:(id)coverArt {
    [self willChangeValueForKey:@"coverArt"];
    [self.tag setCoverArt:coverArt];
    [self didChangeValueForKey:@"coverArt"];
}

-(void) setCharEncoding: (unsigned int) charEncoding {
    NSArray * frames = @[@"artist", @"album", @"albumArtist", @"title",
                         @"genre", @"comment", @"composer",
                         @"copyright", @"year", @"track", @"discNum", @"discTotal"];
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
