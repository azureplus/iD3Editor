//
//  TagXIPH.m
//  iD3
//
//  Created by Qiang Yu on 9/14/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagXIPH.h"
#import "taglib/xiphcomment.h"
#import "NSString_TLString.h"

@implementation TagXIPH
-(id) initWithTag: (TagLib::Tag *) tag {
    if (self = [super initWithTag:tag]) {
        TagLib::Ogg::XiphComment * xiphTag = dynamic_cast<TagLib::Ogg::XiphComment *>(tag);
        
        const TagLib::Ogg::FieldListMap & fieldMap = xiphTag->fieldListMap();
        if (!fieldMap[COMPOSER].isEmpty()) {
            self.composerTL = fieldMap[COMPOSER].front();
        }
        
        if (!fieldMap[COPYRIGHT].isEmpty()) {
            self.copyrightTL = fieldMap[COPYRIGHT].front();
        }
    }
    
    return self;
}

-(void) writeFramesToTag:(TagLib::Tag *) tag {
    [super writeFramesToTag:tag];
    
    TagLib::Ogg::XiphComment * xiphTag = dynamic_cast<TagLib::Ogg::XiphComment *>(tag);
    
    if (xiphTag != nil) {
        xiphTag->addField(COMPOSER, [self.composer toTLString]);
        xiphTag->addField(COPYRIGHT, [self.copyright toTLString]);
    }
}
@end
