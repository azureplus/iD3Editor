//
//  TagInfo.m
//  iD3
//
//  Created by Qiang Yu on 9/14/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagInfo.h"
#import "taglib/infotag.h"
#import "NSString_TLString.h"

@implementation TagInfo
-(id) initWithTag: (TagLib::Tag *) tag {
    if (self = [super initWithTag:tag]) {
        TagLib::RIFF::Info::Tag * infoTag = dynamic_cast<TagLib::RIFF::Info::Tag *>(tag);
        
        if (infoTag != nil) {
            const TagLib::RIFF::Info::FieldListMap & fieldMap = infoTag->fieldListMap();
            if (!fieldMap[COMPOSER].isEmpty()) {
                self.composerTL = fieldMap[COMPOSER];
            }
            
            if (!fieldMap[COPYRIGHT].isEmpty()) {
                self.copyrightTL = fieldMap[COPYRIGHT];
            }
        }
    }
    
    return self;
}

-(void) writeFramesToTag:(TagLib::Tag *) tag {
    [super writeFramesToTag:tag];
    
    TagLib::RIFF::Info::Tag * infoTag = dynamic_cast<TagLib::RIFF::Info::Tag *>(tag);
    
    if (infoTag != nil) {
        infoTag->setFieldText(COMPOSER, [self.composer toTLString]);
        infoTag->setFieldText(COPYRIGHT, [self.copyright toTLString]);
    }
}
@end
