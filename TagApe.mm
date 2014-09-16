//
//  TagApe.m
//  iD3
//
//  Created by Qiang Yu on 9/14/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagApe.h"
#import "taglib/apetag.h"
#import "NSString_TLString.h"

@implementation TagApe
-(id) initWithTag: (TagLib::Tag *) tag {
    if (self = [super initWithTag:tag]) {
        TagLib::APE::Tag * apeTag = dynamic_cast<TagLib::APE::Tag *>(tag);
        if (apeTag != nil) {
            const TagLib::APE::ItemListMap & itemMap = apeTag->itemListMap();
            
            if (!itemMap[COMPOSER].isEmpty()){
                self.composerTL = itemMap[COMPOSER].toString();
            } 
            
            if (!itemMap[COPYRIGHT].isEmpty()){
                self.copyrightTL = itemMap[COPYRIGHT].toString();
            }
        }
    }
    
    return self;
}

-(void) writeFramesToTag:(TagLib::Tag *) tag {
    [super writeFramesToTag:tag];
    
    TagLib::APE::Tag * apeTag = dynamic_cast<TagLib::APE::Tag *>(tag);
    
    if (apeTag != nil) {
        apeTag->addValue(COMPOSER, [self.composer toTLString], true);
        apeTag->addValue(COPYRIGHT, [self.copyright toTLString], true);
    }
}
@end
