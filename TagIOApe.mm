//
//  TagIOApe.m
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "TagIOApe.h"
#import "taglib/apetag.h"
#import "TagBase.h"
#import "NSString_TLString.h"
#import "NSImage_NSData.h"

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
        
        [self _readPicturesFrom:apeTag to:tag];
    }
    
    return tag;
}

//
// currently only supports front cover (the first one found)
// see the implementation in VLC taglib.cpp
//
-(void) _readPicturesFrom:(TagLib::APE::Tag *) taglib to:(TagBase *) tag {
    TagLib::APE::Item item = taglib->itemListMap()["COVER ART (FRONT)"];
    if (item.isEmpty() || item.type() != TagLib::APE::Item::Binary) {
        return;
    }

    const TagLib::ByteVector & bv = item.binaryData();
    const char *  pData = bv.data();
    unsigned iData = bv.size();
    size_t descLen = strnlen(pData, iData);
    
    if (descLen < iData) {
        pData += descLen + 1;
        iData -= descLen + 1;
        NSData * picData = [NSData dataWithBytes:pData length:iData];
        NSImage * image = [[NSImage alloc] initWithData:picData];
        if (image) {
            [tag.pictureTL setObject:image forKey:@COVER_ART];
        }
    }
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
        
        [self _writePic:[tag coverArt] to:apeTag withType:"COVER ART (FRONT)"];
    }
}

-(void) _writePic:(NSImage *) pic to:(TagLib::APE::Tag *) taglib withType:(const std::string &) type {
    if (!pic) {
        return;
    } else if (pic == [NSImage nullImage]) {
        taglib->removeItem(type);
    } else {
        NSData * name = [@"coverart.jpg" dataUsingEncoding:NSUTF8StringEncoding];
    
        NSMutableData * picData = [NSMutableData dataWithData:name];
        Byte zero = 0;
        [picData appendBytes:&zero length:1];
        [picData appendData:[pic toData]];
    
        TagLib::ByteVector bv((const char *)[picData bytes], (uint)[picData length]);
        taglib->setData(type, bv);
    }
}
@end
