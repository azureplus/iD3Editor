//
//  Tag_Info.m
//  iD3
//
//  Created by Qiang Yu on 8/12/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag_Info.h"
#import "NSString_TLString.h"

@implementation Tag(Info)
-(void)setINFOFrames:(NSDictionary *)frames withTag:(TagLib::RIFF::Info::Tag *) tag {
    for (NSString * key in frames) {
        NSString * value = frames[key];
        
        if ([key isEqualToString:@"DATE"]) {
            int year = [value intValue];
            tag->setYear(year);
        } else if ([key isEqualToString:@"TRACKNUMBER"]) {
            int track = [value intValue];
            tag->setTrack(track);
        } else if ([key isEqualToString:@"ARTIST"]) {
            tag->setArtist([value toTLString]);
        } else if ([key isEqualToString:@"ALBUM"]) {
            tag->setAlbum([value toTLString]);
        } else if ([key isEqualToString:@"COMMENT"]) {
            tag->setComment([value toTLString]);
        } else if ([key isEqualToString:@"GRENER"]) {
            tag->setGenre([value toTLString]);
        } else if ([key isEqualToString:@"TITLE"]) {
            tag->setTitle([value toTLString]);
        } else {
            tag->setFieldText([key cStringUsingEncoding:NSASCIIStringEncoding], [value toTLString]);
        }
    }
}

-(NSDictionary *)getINFOFramesWithTag:(TagLib::RIFF::Info::Tag *)tag {
    NSMutableDictionary * dict = [self getStandardFramesWithTag:tag];
    
    const TagLib::RIFF::Info::FieldListMap & fieldMap = tag->fieldListMap();
    if (!fieldMap["COMPOSER"].isEmpty()) {
        dict[@"COMPOSER"] = [NSString newStringFromTLString:fieldMap["COMPOSER"]];
    } else {
        dict[@"COMPOSER"] = @"";
    }
    
    if (!fieldMap["COPYRIGHT"].isEmpty()) {
        dict[@"COPYRIGHT"] = [NSString newStringFromTLString:fieldMap["COPYRIGHT"]];
    } else {
        dict[@"COPYRIGHT"] = @"";
    }
    return dict;
}

-(NSDictionary *)getINFOFramesWithTag:(TagLib::RIFF::Info::Tag *)tag andCharEncoding:(unsigned int)encoding {
    NSMutableDictionary * dict = [self getStandardFramesWithTag:tag];
    
    const TagLib::RIFF::Info::FieldListMap & fieldMap = tag->fieldListMap();
    if (!fieldMap["COMPOSER"].isEmpty()) {
        NSString * value = [NSString newStringFromTLString:fieldMap["COMPOSER"]];
        if (value) {
            dict[@"COMPOSER"] = value;
        }
    } else {
        dict[@"COMPOSER"] = @"";
    }
    
    if (!fieldMap["COPYRIGHT"].isEmpty()) {
        NSString * value = [NSString newStringFromTLString:fieldMap["COPYRIGHT"]];
        if (value) {
            dict[@"COPYRIGHT"] = value;
        }
    } else {
        dict[@"COPYRIGHT"] = @"";
    }
    
    return dict;
}
@end
