//
//  TagWriterInfo.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagWriterInfo.h"
#import "taglib/infotag.h"
#import "NSString_TLString.h"

@implementation TagWriterInfo
-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    [super write:tag toTaglib:taglib];
    
    TagLib::RIFF::Info::Tag * infoTag = dynamic_cast<TagLib::RIFF::Info::Tag *>(taglib);
    
    if (infoTag != nil) {
        infoTag->setFieldText(COMPOSER, [tag.composer toTLString]);
        infoTag->setFieldText(COPYRIGHT, [tag.copyright toTLString]);
    }
}
@end
