//
//  TagCollection.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
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
        self.valid = YES;
    }
    return self;
}

-(id<TagProtocol>)addTagLib: (TagLib::Tag *) tag {
    id<TagReader> tagReader = [TagReaderWriterFactory getReader:tag];
    id<TagProtocol> newTag = [tagReader readTaglib:tag];
    [_tags addObject:newTag];
    return newTag;
}

DECL_GETTER_1(artist);
DECL_GETTER_1(album);
DECL_GETTER_1(albumArtist);
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
        if ([selected track] && [[selected track] intValue] > 0) {
            break;
        }
    }
    
    return [selected track];
}

-(NSNumber *) discNum {
    id<TagProtocol> selected = nil;
    for (id<TagProtocol> tag : _tags) {
        selected = tag;
        if ([selected discNum] && [[selected discNum] intValue] > 0) {
            break;
        }
    }
    
    return [selected discNum];
}

-(NSNumber *) discTotal {
    id<TagProtocol> selected = nil;
    for (id<TagProtocol> tag : _tags) {
        selected = tag;
        if ([selected discTotal] && [[selected discTotal] intValue] > 0) {
            break;
        }
    }
    
    return [selected discTotal];
}

-(NSImage *) coverArt {
    NSImage * image = nil;
    for (id<TagProtocol> tag : _tags) {
        image = [tag coverArt];
        if (image) {
            break;
        }
    }    
    return image;
}

DECL_SETTER_1(Artist);
DECL_SETTER_1(Album);
DECL_SETTER_1(AlbumArtist);
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

-(void)setDiscNum:(NSNumber *)value {
    for (id<TagProtocol> tag : _tags) {
        [tag setDiscNum:value];
    }
}

-(void)setDiscTotal:(NSNumber *)value {
    for (id<TagProtocol> tag : _tags) {
        [tag setDiscTotal:value];
    }
}

-(void)setCoverArt:(NSImage *)value {
    for (id<TagProtocol> tag : _tags) {
        [tag setCoverArt:value];
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

-(void) savedChanges {
    for (id<TagProtocol> tag : _tags) {
        [tag savedChanges];
    }
}
@end
