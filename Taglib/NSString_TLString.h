//
//  NSString_TLString.h
//  iD3
//
//  Created by Qiang Yu on 7/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "taglib/taglib.h"
#import "taglib/tstring.h"

#define DEFAULT_ENCODING 0xFFFFFFFF

@interface NSString(TLString)
+ (NSString *) newStringFromTLString: (const TagLib::String &) value;
+ (NSString *) newStringFromTLString:(const TagLib::String &)value withEncoding: (unsigned int) encoding;
- (TagLib::String) toTLString;
@end
