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
        
        if (!itemMap[COMPOSER].isEmpty()){
            tag.composerTL = itemMap[COMPOSER].toString();
        }
        
        if (!itemMap[COPYRIGHT].isEmpty()){
            tag.copyrightTL = itemMap[COPYRIGHT].toString();
        }
    }
    
    return tag;
}
@end
