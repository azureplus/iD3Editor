//
//  TagReaderXIPH.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagReaderXIPH.h"
#import "taglib/xiphcomment.h"
#import "TagBase.h"

@implementation TagReaderXIPH
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
@end
