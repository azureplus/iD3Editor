//
//  Tag_ID3V1.m
//  iD3
//
//  Created by Qiang Yu on 8/12/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag_ID3V1.h"
#import "Tag.h"
#import "taglib/tag.h"

#import "NSString_TLString.h"

@implementation Tag(ID3V1)
-(void)setID3V1Frames:(NSDictionary *)frames withTag:(TagLib::ID3v1::Tag *) tag {
    for (NSString * key in frames) {
        TagLib::String value = [frames[key] toTLString];
        if ([key isEqualToString:@"ARTIST"]) {
            tag->setArtist(value);
        } else if ([key isEqualToString:@"ALBUM"]) {
            tag->setAlbum(value);
        } else if ([key isEqualToString:@"COMMENT"]) {
            tag->setComment(value);
        } else if ([key isEqualToString:@"TRACKNUMBER"]) {
            tag->setTrack([frames[key] intValue]);
        } else if ([key isEqualToString:@"DATE"]) {
            tag->setYear([frames[key] intValue]);
        } else if ([key isEqualToString:@"GENRE"]) {
            tag->setGenre(value);
        } else if ([key isEqualToString:@"TITLE"]) {
            tag->setTitle(value);
        }
    }
}

-(NSDictionary *)getID3V1FramesWithTag:(TagLib::ID3v1::Tag *)tag {
    NSMutableDictionary * dict = [self getStandardFramesWithTag:tag];
    return dict;
}


-(NSDictionary *)getID3V1FramesWithTag:(TagLib::ID3v1::Tag *)tag andCharEncoding:(unsigned int) encoding {
    NSMutableDictionary * dict = [self getStandardFramesWithTag:tag andCharEncoding:encoding];
    return dict;
}
@end
