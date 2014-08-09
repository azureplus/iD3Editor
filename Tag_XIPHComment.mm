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
    for (NSString * key in frames) {
        TagLib::String value = [frames[key] toTLString];
        xiph->addField([key toTLString], value, true);
    }
}
@end
