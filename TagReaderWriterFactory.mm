//
//  TagReaderWriterFactory.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagReaderWriterFactory.h"

#import "TagWriter.h"
#import "TagReader.h"

#import "TagIOApe.h"
#import "TagIOInfo.h"
#import "TagIOID3V1.h"
#import "TagIOID3V2.h"
#import "TagIOXIPH.h"
#import "TagIOMP4.h"

#import "taglib/tag.h"
#import "taglib/apetag.h"
#import "taglib/infotag.h"
#import "taglib/id3v1tag.h"
#import "taglib/id3v2tag.h"
#import "taglib/xiphcomment.h"
#import "taglib/mp4tag.h"

#define INDEX_APE   0
#define INDEX_INFO  1
#define INDEX_ID3V1 2
#define INDEX_ID3V2 3
#define INDEX_XIPH  4
#define INDEX_MP4   5

static NSArray * readers = nil;
static NSArray * writers = nil;

@implementation TagReaderWriterFactory
+(void) initialize {
    if (self == [TagReaderWriterFactory class]) {
        readers = @[[[TagIOApe alloc] init],
                    [[TagIOInfo alloc] init],
                    [[TagIOID3V1 alloc] init],
                    [[TagIOID3V2 alloc] init],
                    [[TagIOXIPH alloc] init],
                    [[TagIOMP4 alloc] init]];

        writers = @[[[TagIOApe alloc] init],
                    [[TagIOInfo alloc] init],
                    [[TagIOID3V1 alloc] init],
                    [[TagIOID3V2 alloc] init],
                    [[TagIOXIPH alloc] init],
                    [[TagIOMP4 alloc] init]];
    }
}

+(id<TagReader>) getReader:(TagLib::Tag *)tag {
    int index = [TagReaderWriterFactory typeOf:tag];
    if (index >= 0)
        return readers[index];
    else
        return nil;
}

+(id<TagWriter>) getWriter:(TagLib::Tag *)tag {
    int index = [TagReaderWriterFactory typeOf:tag];
    if (index >= 0)
        return writers[index];
    else
        return nil;
}


+(int) typeOf:(TagLib::Tag *) tag {
    int rv = -1;
    
    if (dynamic_cast<TagLib::APE::Tag *>(tag)) {
        rv = INDEX_APE;
    } else if (dynamic_cast<TagLib::RIFF::Info::Tag *>(tag)) {
        rv = INDEX_INFO;
    } else if (dynamic_cast<TagLib::ID3v1::Tag *>(tag)) {
        rv = INDEX_ID3V1;
    } else if (dynamic_cast<TagLib::ID3v2::Tag *>(tag)) {
        rv = INDEX_ID3V2;
    } else if (dynamic_cast<TagLib::Ogg::XiphComment *>(tag)) {
        rv = INDEX_XIPH;
    } else if (dynamic_cast<TagLib::MP4::Tag *>(tag)) {
        rv = INDEX_MP4;
    }
    
    return rv;
}
@end
