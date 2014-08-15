//
//  Tag_XIPHComment.m
//  iD3
//
//  Created by Qiang Yu on 8/8/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag_XIPHComment.h"
#import "NSString_TLString.h"

@implementation Tag(XIPHComment)
-(void)setXIPHCOMMENTFrames:(NSDictionary *)frames withTag:(TagLib::Ogg::XiphComment *)xiph {
    if (xiph == nil) {
        return;
    }
    
    for (NSString * key in frames) {
        NSString * value = frames[key];
                
        if ([key isEqualToString:@"DATE"]) {
            int year = [value intValue];
            xiph->setYear(year);
        } else if ([key isEqualToString:@"TRACKNUMBER"]) {
            int track = [value intValue];
            xiph->setTrack(track);
        } else if ([key isEqualToString:@"ARTIST"]) {
            xiph->setArtist([value toTLString]);
        } else if ([key isEqualToString:@"ALBUM"]) {
            xiph->setAlbum([value toTLString]);
        } else if ([key isEqualToString:@"COMMENT"]) {
            xiph->setComment([value toTLString]);
        } else if ([key isEqualToString:@"GRENER"]) {
            xiph->setGenre([value toTLString]);
        } else if ([key isEqualToString:@"TITLE"]) {
            xiph->setTitle([value toTLString]);
        } else {
            xiph->addField([key toTLString], [value toTLString], true);
        }
    }
}

-(NSDictionary *)getXIPHCOMMENTFramesWithTag:(TagLib::Ogg::XiphComment *)tag {
    NSMutableDictionary * dict = [self getStandardFramesWithTag:tag];

    const TagLib::Ogg::FieldListMap & fieldMap = tag->fieldListMap();
    if (!fieldMap["COMPOSER"].isEmpty()) {
        dict[@"COMPOSER"] = [NSString newStringFromTLString:fieldMap["COMPOSER"].front()];
    } else {
        dict[@"COMPOSER"] = @"";
    }
    
    if (!fieldMap["COPYRIGHT"].isEmpty()) {
        dict[@"COPYRIGHT"] = [NSString newStringFromTLString:fieldMap["COPYRIGHT"].front()];
    } else {
        dict[@"COPYRIGHT"] = @"";
    }
    return dict;
}

-(NSDictionary *)getXIPHCOMMENTFramesWithTag:(TagLib::Ogg::XiphComment *)tag andCharEncoding:(unsigned int)encoding {
    NSMutableDictionary * dict = [self getStandardFramesWithTag:tag];

    const TagLib::Ogg::FieldListMap & fieldMap = tag->fieldListMap();
    if (!fieldMap["COMPOSER"].isEmpty()) {
        NSString * value = [NSString newStringFromTLString:fieldMap["COMPOSER"].front()];
        if (value) {
            dict[@"COMPOSER"] = value;
        }
    } else {
        dict[@"COMPOSER"] = @"";
    }
    
    if (!fieldMap["COPYRIGHT"].isEmpty()) {
        NSString * value = [NSString newStringFromTLString:fieldMap["COPYRIGHT"].front()];
        if (value) {
            dict[@"COPYRIGHT"] = value;
        }
    } else {
        dict[@"COPYRIGHT"] = @"";
    }
    
    return dict;
}
@end
