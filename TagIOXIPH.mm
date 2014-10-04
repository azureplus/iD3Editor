//
//  TagIOXIPH.m
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "TagIOXIPH.h"
#import "taglib/xiphcomment.h"
#import "taglib/attachedpictureframe.h"
#import "TagBase.h"
#import "NSString_TLString.h"

@implementation TagIOXIPH
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib {
    TagBase * tag = [super readTaglib:taglib];
    TagLib::Ogg::XiphComment * xiphTag = dynamic_cast<TagLib::Ogg::XiphComment *>(taglib);
    if (xiphTag) {
        const TagLib::Ogg::FieldListMap & fieldMap = xiphTag->fieldListMap();
        if (!fieldMap[COMPOSER_FRAME].isEmpty()) {
            tag.composerTL = fieldMap[COMPOSER_FRAME].front();
        }
        
        if (!fieldMap[COPYRIGHT_FRAME].isEmpty()) {
            tag.copyrightTL = fieldMap[COPYRIGHT_FRAME].front();
        }
    }
    
    return tag;
}

-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {                return;
    }
    
    [super write:tag toTaglib:taglib];
    
    TagLib::Ogg::XiphComment * xiphTag = dynamic_cast<TagLib::Ogg::XiphComment *>(taglib);
    
    if (xiphTag) {
        xiphTag->addField(COMPOSER_FRAME, [NSString TLStringFromString:tag.composer]);
        xiphTag->addField(COPYRIGHT_FRAME, [NSString TLStringFromString:tag.copyright]);
    }
}
@end
