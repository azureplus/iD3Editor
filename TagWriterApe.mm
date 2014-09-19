//
//  TagWriterApe.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagWriterApe.h"
#import "taglib/apetag.h"
#import "NSString_TLString.h"

@implementation TagWriterApe
-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {
        return;
    }

    [super write:tag toTaglib:taglib];

    TagLib::APE::Tag * apeTag = dynamic_cast<TagLib::APE::Tag *>(taglib);
    if (apeTag) {
        apeTag->addValue(COMPOSER_FRAME, [tag.composer toTLString], true);
        apeTag->addValue(COPYRIGHT_FRAME, [tag.copyright toTLString], true);
    }
}
@end
