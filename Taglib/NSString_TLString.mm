//
//  NSString_TLString.m
//  iD3
//
//  Created by Qiang Yu on 7/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "NSString_TLString.h"

@implementation NSString(TLString)
+ (NSString *) newStringFromTLString: (const TagLib::String &) value {
    return [self newStringFromTLString:value withEncoding:DEFAULT_ENCODING];
}

+ (NSString *) newStringFromTLString:(const TagLib::String &)value withEncoding: (unsigned int) encoding {
    if (value == TagLib::String::null || value.isEmpty()) {
        return @"";
    } else if (encoding != DEFAULT_ENCODING && (value.isAscii() || value.isLatin1())) {
        TagLib::ByteVector bv = value.data(TagLib::String::Type::Latin1);
        NSStringEncoding target = CFStringConvertEncodingToNSStringEncoding(encoding);
        NSString * result = [[NSString alloc] initWithData:[NSData dataWithBytes:bv.data() length:bv.size()] encoding:target];
        return result;
    } else {
        TagLib::ByteVector bv = value.data(TagLib::String::Type::UTF16BE);
        NSString * str = [[NSString alloc] initWithBytes:bv.data() length:bv.size() encoding:NSUTF16BigEndianStringEncoding];
        return str;
    }
}

+ (TagLib::String) TLStringFromString: (NSString *)str {
    if (str) {
        return TagLib::String([str UTF8String], TagLib::String::Type::UTF8);
    } else {
        return TagLib::String::null;
    }
}

@end
