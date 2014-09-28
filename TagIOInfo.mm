//
//  TagIOInfo.m
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagIOInfo.h"
#import "taglib/infotag.h"
#import "TagBase.h"
#import "NSString_TLString.h"

@implementation TagIOInfo
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

-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {
        return;
    }
    
    [super write:tag toTaglib:taglib];
    
    TagLib::RIFF::Info::Tag * infoTag = dynamic_cast<TagLib::RIFF::Info::Tag *>(taglib);
    
    if (infoTag != nil) {
        infoTag->setFieldText(COMPOSER_FRAME, [NSString TLStringFromString:tag.composer]);
        infoTag->setFieldText(COPYRIGHT_FRAME, [NSString TLStringFromString:tag.copyright]);
    }
}
@end
