//
//  TagEntity.m
//  iD3
//
//  Created by Qiang Yu on 7/29/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagEntity.h"

#define DECL_GETTER_1(FRAME) \
-(NSString *) FRAME { \
    return [self.tag FRAME]; \
}

#define DECL_SETTER_1(FRAME) \
-(void) set##FRAME:(NSString *)value { \
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

@synthesize tag = _tag;

-(void)didTurnIntoFault {
    [self save];
}

-(void) save {
}

-(void) resetValue {
    [self.tag discardChanges];
}

DECL_GETTER_1(artist);
DECL_GETTER_1(album);
DECL_GETTER_1(title);
DECL_GETTER_1(genre);
DECL_GETTER_1(comment);
DECL_GETTER_1(composer);
DECL_GETTER_1(copyright);

-(NSString *) year {
    return [[self.tag year] stringValue];
}

-(NSString *) track {
    return [[self.tag track] stringValue];
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

-(void) setCharEncoding: (unsigned int) charEncoding {
    NSArray * frames = @[@"artist", @"album", @"title", @"genre", @"comment", @"composer", @"copyright"];
    for (NSString * frame in frames) {
        [self willChangeValueForKey:frame];
    }
    [self.tag setCharEncoding:charEncoding];
    for (NSString * frame in frames) {
        [self didChangeValueForKey:frame];
    }
}

/*
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
 */
@end
