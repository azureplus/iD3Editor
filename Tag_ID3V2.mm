//
//  Tag_FLAC.m
//  iD3
//
//  Created by Qiang Yu on 8/8/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag_ID3V2.h"
#import "Tag.h"
#import "taglib/tag.h"

#import "NSString_TLString.h"

@implementation Tag(ID3V2)
-(void)setID3V2Frames:(NSDictionary *)frames withTag:(TagLib::ID3v2::Tag *) id3v2Tag {
    for (NSString * key in frames) {
        TagLib::String value = [frames[key] toTLString];
        if ([key isEqualToString:@"ARTIST"]) {
            id3v2Tag->setArtist(value);
        } else if ([key isEqualToString:@"ALBUM"]) {
            id3v2Tag->setAlbum(value);
        } else if ([key isEqualToString:@"COMMENT"]) {
            id3v2Tag->setComment(value);
        } else if ([key isEqualToString:@"TRACKNUMBER"]) {
            id3v2Tag->setTrack([frames[key] intValue]);
        } else if ([key isEqualToString:@"DATE"]) {
            id3v2Tag->setYear([frames[key] intValue]);
        } else if ([key isEqualToString:@"GENRE"]) {
            id3v2Tag->setGenre(value);
        } else if ([key isEqualToString:@"TITLE"]) {
            id3v2Tag->setTitle(value);
        } else if ([key isEqualToString:@"COMPOSER"]) {
            id3v2Tag->setTextFrame("TCOM", value);
        } else if ([key isEqualToString:@"COPYRIGHT"]) {
            id3v2Tag->setTextFrame("TCOP", value);
        }
    }
}

-(NSDictionary *)getID3V2FramesWithTag:(TagLib::ID3v2::Tag *)tag {
    NSMutableDictionary * dict = [self getStandardFramesWithTag:tag];

    const TagLib::ID3v2::FrameList & tcomFrameList = tag->frameList("TCOM");
    if (!tcomFrameList.isEmpty()) {
        dict[@"COMPOSER"] = [NSString newStringFromTLString:tcomFrameList[0]->toString()];
    } else {
        dict[@"COMPOSER"] = @"";
    }

    const TagLib::ID3v2::FrameList & tcopFrameList = tag->frameList("TCOP");
    if (!tcopFrameList.isEmpty()) {
        dict[@"COPYRIGHT"] = [NSString newStringFromTLString:tcopFrameList[0]->toString()];
    } else {
        dict[@"COPYRIGHT"] = @"";
    }
    
    return dict;
}

-(NSDictionary *)getID3V2FramesWithTag:(TagLib::ID3v2::Tag *)tag andCharEncoding:(unsigned int)encoding {
    NSMutableDictionary * dict = [self getStandardFramesWithTag:tag andCharEncoding:encoding];
    
    const TagLib::ID3v2::FrameList & tcomFrameList = tag->frameList("TCOM");
    if (!tcomFrameList.isEmpty()) {
        TagLib::String text = tcomFrameList[0]->toString();
        NSString * value = [self convertTLString:text toEncoding:encoding];
        if (value) {
            dict[@"COMPOSER"] = value;
        }
    } else {
        dict[@"COMPOSER"] = @"";
    }
    
    const TagLib::ID3v2::FrameList & tcopFrameList = tag->frameList("TCOP");
    if (!tcopFrameList.isEmpty()) {
        TagLib::String text = tcopFrameList[0]->toString();
        NSString * value = [self convertTLString:text toEncoding:encoding];
        if (value) {
            dict[@"COPYRIGHT"] = value;
        }
    } else {
        dict[@"COPYRIGHT"] = @"";
    }
    
    return dict;
}

@end
