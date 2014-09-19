//
//  TagReaderInfo.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagReaderInfo.h"
#import "taglib/infotag.h"
#import "TagBase.h"

@implementation TagReaderInfo
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib {
    TagBase * tag = [super readTaglib:taglib];
    
    TagLib::RIFF::Info::Tag * infoTag = dynamic_cast<TagLib::RIFF::Info::Tag *>(taglib);
    if (infoTag) {
        const TagLib::RIFF::Info::FieldListMap & fieldMap = infoTag->fieldListMap();
        if (!fieldMap[COMPOSER_FRAME].isEmpty()) {
            tag.composerTL = fieldMap[COMPOSER_FRAME];
        }
        
        if (!fieldMap[COPYRIGHT_FRAME].isEmpty()) {
            tag.copyrightTL = fieldMap[COPYRIGHT_FRAME];
        }
    }
    
    return tag;
}
@end
