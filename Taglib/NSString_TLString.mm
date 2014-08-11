//
//  NSString_TLString.m
//  iD3
//
//  Created by Qiang Yu on 7/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "NSString_TLString.h"

@implementation NSString(TLString)
+ (NSString *) newStringFromTLString: (const TagLib::String &) str {
    if (str == TagLib::String::null || str.isEmpty()) {
        return @"";
    } else {
        TagLib::ByteVector bv = str.data(TagLib::String::Type::UTF16BE);
        NSString * str = [[NSString alloc] initWithBytes:bv.data() length:bv.size() encoding:NSUTF16BigEndianStringEncoding];
        return str;
    }
}

- (TagLib::String) toTLString {
    return TagLib::String([self UTF8String], TagLib::String::Type::UTF8);
}
@end
