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
        } else if ([key isEqualToString:@"GRENER"]) {
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
@end
