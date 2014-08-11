//
//  Taglib.m
//  iD3
//
//  Created by Qiang Yu on 7/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag.h"
#import "taglib/tag.h"
#import "taglib/fileref.h"
#import "taglib/tpropertymap.h"
#import "NSString_TLString.h"
#import "Tag_FileTypeResolver.h"

@implementation Tag

-(id) initWithFile: (NSString *) filename {
    if (self = [super init]) {
        _filename = filename;
    }
    return self;
}

-(NSDictionary *)getStandardFramesWithTag:(TagLib::Tag *)tag {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:12];
    if (tag->year() > 0) {
        dict[@"DATE"] = [NSString stringWithFormat:@"%d", tag->year()];
    }
    
    if (tag->track() > 0) {
        dict[@"TRACKNUMBER"] = [NSString stringWithFormat:@"%d", tag->track()];
    }
    
    dict[@"ARTIST"] = [NSString newStringFromTLString:tag->artist()];
    dict[@"ALBUM"] = [NSString newStringFromTLString:tag->album()];
    dict[@"COMMENT"] = [NSString newStringFromTLString:tag->comment()];
    dict[@"TITLE"] = [NSString newStringFromTLString:tag->title()];
    dict[@"GENRE"] = [NSString newStringFromTLString:tag->genre()];
    return dict;
}

//
// the dictionary returned doesnt include tags that dont need conversion. For example, tags already in UTF-8
//
-(NSDictionary *)getStandardFramesWithTag:(TagLib::Tag *)tag andCharEncoding:(unsigned int)encoding {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:12];
    
    NSString * value = [self convertTLString:tag->artist() toEncoding:encoding];
    if (value) {
        dict[@"ARTIST"] = value;
    }
    
    value = [self convertTLString:tag->album() toEncoding:encoding];
    if (value) {
        dict[@"ALBUM"] = value;
    }

    value = [self convertTLString:tag->comment() toEncoding:encoding];
    if (value) {
        dict[@"COMMENT"] = value;
    }

    value = [self convertTLString:tag->title() toEncoding:encoding];
    if (value) {
        dict[@"TITLE"] = value;
    }

    value = [self convertTLString:tag->genre() toEncoding:encoding];
    if (value) {
        dict[@"GENRE"] = value;
    }
    return dict;
}

-(void)saveFrames:(NSDictionary *)frames {
    [self resolveSetFrames:frames];
}

-(NSDictionary *)getFrames {
    return [self resolveGetFrames];
}

//
// return null if stirng is already UTF-8
//
-(NSString *)convertTLString: (const TagLib::String &) value toEncoding: (unsigned int) encoding{
    if (value == TagLib::String::null) {
        return nil;
    } else if (value.isAscii() || value.isLatin1()) {
        TagLib::ByteVector bv = value.data(TagLib::String::Type::Latin1);
        NSStringEncoding target = CFStringConvertEncodingToNSStringEncoding(encoding);
        NSString * result = [[NSString alloc] initWithData:[NSData dataWithBytes:bv.data() length:bv.size()] encoding:target];
        return result;
    } else {
        return nil;
    }
}
@end
