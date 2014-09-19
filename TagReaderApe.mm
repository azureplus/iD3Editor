//
//  TagReaderApe.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagReaderApe.h"
#import "taglib/apetag.h"
#import "TagBase.h"

@implementation TagReaderApe
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib {
    TagBase * tag = [super readTaglib:taglib];
    
    TagLib::APE::Tag * apeTag = dynamic_cast<TagLib::APE::Tag *>(taglib);
    if (apeTag) {
        const TagLib::APE::ItemListMap & itemMap = apeTag->itemListMap();
        
        if (!itemMap[COMPOSER_FRAME].isEmpty()){
            tag.composerTL = itemMap[COMPOSER_FRAME].toString();
        }
        
        if (!itemMap[COPYRIGHT_FRAME].isEmpty()){
            tag.copyrightTL = itemMap[COPYRIGHT_FRAME].toString();
        }
    }
    
    return tag;
}
@end
