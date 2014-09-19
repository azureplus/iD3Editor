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
    [self.tag set##FRAME:value]; \
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
@dynamic pathDepth;

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
    [self.tag setYear:[NSNumber numberWithInt:[value intValue]]];
}

-(void)setTrack:(NSString *)value {
    [self.tag setTrack:[NSNumber numberWithInt:[value intValue]]];
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
