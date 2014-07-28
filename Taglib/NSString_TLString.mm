//
//  NSString_TLString.m
//  iD3
//
//  Created by Qiang Yu on 7/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "NSString_TLString.h"

@implementation NSString(TLString)
+ (NSString *) newStringFromTLString: (TagLib::String &) str {
    if (str == TagLib::String::null) {
        return @"";
    } else {
        TagLib::ByteVector bv = str.data(TagLib::String::Type::UTF16BE);
        NSString * str = [[NSString alloc] initWithBytes:bv.data() length:bv.size() encoding:NSUTF16BigEndianStringEncoding];
        return str;
    }
}
@end
