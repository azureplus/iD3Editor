//
//  tagWriterXIPH.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "tagWriterXIPH.h"
#import "taglib/xiphcomment.h"
#import "NSString_TLString.h"


@implementation TagWriterXIPH
-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {
        return;
    }
        
    [super write:tag toTaglib:taglib];
    
    TagLib::Ogg::XiphComment * xiphTag = dynamic_cast<TagLib::Ogg::XiphComment *>(taglib);
    
    if (xiphTag) {
        xiphTag->addField(COMPOSER, [tag.composer toTLString]);
        xiphTag->addField(COPYRIGHT, [tag.copyright toTLString]);
    }
}
@end
