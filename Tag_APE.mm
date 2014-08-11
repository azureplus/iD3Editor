//
//  Tag_APE.m
//  iD3
//
//  Created by Qiang Yu on 8/8/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//


#import "Tag_APE.h"
#import "taglib/tag.h"
#import "taglib/apeitem.h"
#import "NSString_TLString.h"

@implementation Tag(APE)
-(void)setAPEFrames:(NSDictionary *)frames withTag:(TagLib::APE::Tag *) apeTag {
    for (NSString * key in frames) {
        NSString * value = frames[key];
        if ([key isEqualToString:@"DATE"]) {
            int year = [value intValue];
            apeTag->setYear(year);
        } else if ([key isEqualToString:@"TRACKNUMBER"]) {
            int track = [value intValue];
            apeTag->setTrack(track);
        } else if ([key isEqualToString:@"ARTIST"]) {
            apeTag->setArtist([value toTLString]);
        } else if ([key isEqualToString:@"ALBUM"]) {
            apeTag->setAlbum([value toTLString]);
        } else if ([key isEqualToString:@"COMMENT"]) {
            apeTag->setComment([value toTLString]);
        } else if ([key isEqualToString:@"GRENER"]) {
            apeTag->setGenre([value toTLString]);
        } else if ([key isEqualToString:@"TITLE"]) {
            apeTag->setTitle([value toTLString]);
        } else {
            apeTag->addValue([key toTLString], [value toTLString], true);
        }        
    }
}

-(NSDictionary *)getAPEFramesWithTag:(TagLib::APE::Tag *)tag {
    NSMutableDictionary * dict = [self getStandardFramesWithTag:tag];
    
    const TagLib::APE::ItemListMap & itemMap = tag->itemListMap();
    
    if (!itemMap["COMPOSER"].isEmpty()){
        dict[@"COMPOSER"] = [NSString newStringFromTLString:itemMap["COMPOSER"].toString()];
    } else {
        dict[@"COMPOSER"] = @"";
    }

    if (!itemMap["COPYRIGHT"].isEmpty()){
        dict[@"COPYRIGHT"] = [NSString newStringFromTLString:itemMap["COPYRIGHT"].toString()];
    } else {
        dict[@"COPYRIGHT"] = @"";
    }
    return dict;
}

//
// the dictionary returned doesnt include tags that dont need conversion. For example, tags already in UTF-8
//
-(NSDictionary *)getAPEFramesWithTag:(TagLib::APE::Tag *)tag andCharEncoding:(unsigned int)encoding {
    NSMutableDictionary * dict = [self getStandardFramesWithTag:tag andCharEncoding:encoding];

    const TagLib::APE::ItemListMap & itemMap = tag->itemListMap();
    
    if (!itemMap["COMPOSER"].isEmpty()){
        NSString * str = [self convertTLString:itemMap["COMPOSER"].toString() toEncoding:encoding];
        if (str) {
            dict[@"COMPOSER"] = str;
        }
    } else {
        dict[@"COMPOSER"] = @"";
    }
    
    if (!itemMap["COPYRIGHT"].isEmpty()){
        NSString * str = [self convertTLString:itemMap["COPYRIGHT"].toString() toEncoding:encoding];
        if (str) {
            dict[@"COPYRIGHT"] = str;
        }
    } else {
        dict[@"COPYRIGHT"] = @"";
    }
    return dict;
}

@end
