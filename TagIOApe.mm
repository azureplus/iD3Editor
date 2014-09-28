//
//  TagIOApe.m
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagIOApe.h"
#import "taglib/apetag.h"
#import "TagBase.h"
#import "NSString_TLString.h"

@implementation TagIOApe
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

-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {
        return;
    }
    
    [super write:tag toTaglib:taglib];
    
    TagLib::APE::Tag * apeTag = dynamic_cast<TagLib::APE::Tag *>(taglib);
    if (apeTag) {
        apeTag->addValue(COMPOSER_FRAME, [NSString TLStringFromString:tag.composer], true);
        apeTag->addValue(COPYRIGHT_FRAME, [NSString TLStringFromString:tag.copyright], true);
    }
}
@end
