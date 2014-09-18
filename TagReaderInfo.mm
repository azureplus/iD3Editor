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
        if (!fieldMap[COMPOSER].isEmpty()) {
            tag.composerTL = fieldMap[COMPOSER];
        }
        
        if (!fieldMap[COPYRIGHT].isEmpty()) {
            tag.copyrightTL = fieldMap[COPYRIGHT];
        }
    }
    
    return tag;
}
@end
