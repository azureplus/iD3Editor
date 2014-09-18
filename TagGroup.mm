//
//  TagCollection.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagGroup.h"
#import "TagReaderWriterFactory.h"

#define DECL_GETTER_1(FRAME)\
-(NSString *) FRAME { \
    id<TagProtocol> selected = nil; \
    for (id<TagProtocol> tag : _tags) { \
        selected = tag; \
        if ([[selected FRAME] length]) { \
            break; \
        } \
    } \
    return [selected FRAME]; \
}

#define DECL_SETTER_1(FRAME) \
-(void) set##FRAME:(NSString *) value { \
    for (id<TagProtocol> tag : _tags) { \
        [tag set##FRAME: value]; \
    } \
}

@interface TagGroup()
@property(nonatomic, strong) NSMutableArray * tags;
@end

@implementation TagGroup

-(id)init {
    if (self = [super init]) {
        self.tags = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

-(void)addTagLib: (TagLib::Tag *) tag {
    id<TagReader> tagReader = [TagReaderWriterFactory getReader:tag];
    [_tags addObject:[tagReader readTaglib:tag]];
}

DECL_GETTER_1(artist);
DECL_GETTER_1(album);
DECL_GETTER_1(title);
DECL_GETTER_1(genre);
DECL_GETTER_1(comment);
DECL_GETTER_1(composer);
DECL_GETTER_1(copyright);

-(NSNumber *) year {
    id<TagProtocol> selected = nil;
    for (id<TagProtocol> tag : _tags) {
        selected = tag;
        if ([selected year] && [[selected year] intValue] > 0) {
            break;
        }
    }
    
    return [selected year];
}

-(NSNumber *) track {
    id<TagProtocol> selected = nil;
    for (id<TagProtocol> tag : _tags) {
        selected = tag;
        if ([selected year] && [[selected year] intValue] > 0) {
            break;
        }
    }
    
    return [selected year];
}

DECL_SETTER_1(Artist);
DECL_SETTER_1(Album);
DECL_SETTER_1(Title);
DECL_SETTER_1(Genre);
DECL_SETTER_1(Comment);
DECL_SETTER_1(Composer);
DECL_SETTER_1(Copyright);

-(void)setYear:(NSNumber *)value {
    for (id<TagProtocol> tag : _tags) {
        [tag setYear:value];
    }
}

-(void)setTrack:(NSNumber *)value {
    for (id<TagProtocol> tag : _tags) {
        [tag setTrack:value];
    }
}

-(void) setCharEncoding: (unsigned int) encoding {
    for (id<TagProtocol> tag : _tags) {
        [tag setCharEncoding:encoding];
    }
}

-(BOOL) updated {
    BOOL updated = false;
    for (id<TagProtocol> tag : _tags) {
        updated = updated || [tag updated];
        if (updated) {
            break;
        }
    }
    return updated;
}

-(void) discardChanges {
    for (id<TagProtocol> tag : _tags) {
        [tag discardChanges];
    }
}
@end
