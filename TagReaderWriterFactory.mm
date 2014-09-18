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

#import "TagReaderApe.h"
#import "TagReaderInfo.h"
#import "TagReaderID3V1.h"
#import "TagReaderID3V2.h"
#import "TagReaderXIPH.h"

#import "TagWriterApe.h"
#import "TagWriterInfo.h"
#import "TagWriterID3V1.h"
#import "TagWriterID3V2.h"
#import "TagWriterXIPH.h"

#import "taglib/tag.h"
#import "taglib/apetag.h"
#import "taglib/infotag.h"
#import "taglib/id3v1tag.h"
#import "taglib/id3v2tag.h"
#import "taglib/xiphcomment.h"

#define INDEX_APE   0
#define INDEX_INFO  1
#define INDEX_ID3V1 2
#define INDEX_ID3V2 3
#define INDEX_XIPH  4

static NSArray * readers = nil;
static NSArray * writers = nil;

@implementation TagReaderWriterFactory
+(void) initialize {
    if (self == [TagReaderWriterFactory class]) {
        readers = @[[[TagReaderApe alloc] init],
                    [[TagReaderInfo alloc] init],
                    [[TagReaderID3V1 alloc] init],
                    [[TagReaderID3V2 alloc] init],
                    [[TagReaderXIPH alloc] init]];

        writers = @[[[TagWriterApe alloc] init],
                    [[TagWriterInfo alloc] init],
                    [[TagWriterID3V1 alloc] init],
                    [[TagWriterID3V2 alloc] init],
                    [[tagWriterXIPH alloc] init]];
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
    }
    
    return rv;
}
@end
