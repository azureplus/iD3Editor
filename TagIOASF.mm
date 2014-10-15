//
//  TagIOASF.m
//  iD3
//
//  Created by Qiang Yu on 10/11/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "TagIOASF.h"
#import "TagBase.h"

#import "taglib/asftag.h"
#import "NSString_TLString.h"
#import "NSImage_NSData.h"

#define ASF_COMPOSER "WM/Composer"
#define ASF_PICTURE "WM/Picture"

@implementation TagIOASF
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib {
    TagBase * tag = [super readTaglib:taglib];
    
    TagLib::ASF::Tag * asfTag = dynamic_cast<TagLib::ASF::Tag *>(taglib);
    
    if (asfTag) {
        const TagLib::ASF::AttributeListMap & attributeListMap = asfTag->attributeListMap();
        
        if (attributeListMap.contains(ASF_COMPOSER)) {
            const TagLib::ASF::AttributeList & composers = attributeListMap[ASF_COMPOSER];
            if (composers.size() > 0) {
                TagLib::ASF::Attribute composer = composers.front();
                tag.composerTL = composer.toString();
            }
        }
        
        const TagLib::String & copyright = asfTag->copyright();
        if (copyright != TagLib::String::null) {
            tag.copyrightTL = copyright;
        }
        
        [self _readPicturesFrom:asfTag to:tag];
    }
    
    return tag;
}

-(void) _readPicturesFrom:(TagLib::ASF::Tag *) taglib to:(TagBase *) tag {
    const TagLib::ASF::AttributeListMap & attributeListMap = taglib->attributeListMap();
    if (!attributeListMap.contains(ASF_PICTURE)) {
        return;
    }
    
    const TagLib::ASF::AttributeList & picList = attributeListMap[ASF_PICTURE];
    
    for (TagLib::ASF::AttributeList::ConstIterator it = picList.begin(); it !=picList.end(); it++) {
        const TagLib::ASF::Picture & pic = (*it).toPicture();
        if (pic.type() == TagLib::ASF::Picture::Type::FrontCover) {
            const TagLib::ByteVector & bv = pic.picture();
            NSData * picData = [NSData dataWithBytes:bv.data() length:bv.size()];
            NSImage * image = [[NSImage alloc] initWithData:picData];
            if (image) {
                [tag.pictureTL setObject:image forKey:@COVER_ART];
                break;
            }
        }
    }
}

-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {
        return;
    }
    
    [super write:tag toTaglib:taglib];
    
    TagLib::ASF::Tag * asfTag = dynamic_cast<TagLib::ASF::Tag *>(taglib);
    
    if (asfTag != nil) {
        TagLib::ASF::AttributeListMap & attributeListMap = asfTag->attributeListMap();
        TagLib::ASF::AttributeList composerList = TagLib::ASF::AttributeList();
        if (attributeListMap.contains(ASF_COMPOSER)) {
            composerList = attributeListMap[ASF_COMPOSER];
            if (composerList.size()) {
                composerList.erase(composerList.begin());
            }
        }
        
        TagLib::ASF::Attribute composer([NSString TLStringFromString:tag.composer]);
        composerList.prepend(composer);
        attributeListMap[ASF_COMPOSER] = composerList;
        
        asfTag->setCopyright([NSString TLStringFromString:tag.copyright]);
        [self _writePic:[tag coverArt] to:asfTag withType:TagLib::ASF::Picture::Type::FrontCover];
    }
}


-(void) _writePic:(NSImage *) pic to:(TagLib::ASF::Tag *) asfTag withType:(TagLib::ASF::Picture::Type) type {
    if (!pic) {
        return;
    }
    
    BOOL coverArtListFound = false;

    TagLib::ASF::AttributeListMap & attributeListMap = asfTag->attributeListMap();
    TagLib::ASF::AttributeList cr = TagLib::ASF::AttributeList();
    
    if (attributeListMap.contains(ASF_PICTURE)) {
        cr = attributeListMap[ASF_PICTURE];
        coverArtListFound = true;
    }
    
    for (TagLib::ASF::AttributeList::Iterator it = cr.begin(); it !=cr.end(); it++) {
        const TagLib::ASF::Picture & pic = (*it).toPicture();
        if (pic.type() == TagLib::ASF::Picture::Type::FrontCover) {
            cr.erase(it);
            break;
        }
    }
    
    if (pic == [NSImage nullImage]) {
        attributeListMap[ASF_PICTURE] = cr;
        return;
    }
    
    NSData * picData = [pic toData];
    TagLib::ByteVector bv((const char *)[picData bytes], (uint)[picData length]);
    
    TagLib::ASF::Picture picture;
    picture.setType(type);
    picture.setMimeType("image/jpeg");
    picture.setDescription("frontcover");
    picture.setPicture(bv);
    
    cr.prepend(picture);
    attributeListMap[ASF_PICTURE] = cr;
}

@end
