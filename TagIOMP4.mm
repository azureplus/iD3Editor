//
//  TagIOMP4.m
//  iD3
//
//  Created by Qiang Yu on 10/10/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagIOMP4.h"
#import "TagBase.h"

#import "taglib/mp4tag.h"
#import "taglib/tstringlist.h"
#import "NSString_TLString.h"
#import "NSImage_NSData.h"

#define MP4_COMPOSER "\251wrt"
#define MP4_COPYRIGHT "cprt"
#define MP4_COVER_ART "covr"
#define MP4_STRINGLIST_DELIMITER ", "

@implementation TagIOMP4
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib {
    TagBase * tag = [super readTaglib:taglib];
    
    TagLib::MP4::Tag * mp4Tag = dynamic_cast<TagLib::MP4::Tag *>(taglib);
    if (mp4Tag) {
        const TagLib::MP4::ItemListMap & itemListMap = mp4Tag->itemListMap();
        if (itemListMap.contains(MP4_COMPOSER)) {
            tag.composerTL = itemListMap[MP4_COMPOSER].toStringList().toString(MP4_STRINGLIST_DELIMITER);
        }
        
        if (itemListMap.contains(MP4_COPYRIGHT)) {
            tag.copyrightTL = itemListMap[MP4_COPYRIGHT].toStringList().toString(MP4_STRINGLIST_DELIMITER);
        }
        
        [self _readPicturesFrom:mp4Tag to:tag];
    }
    
    return tag;
}

-(void) _readPicturesFrom:(TagLib::MP4::Tag *) taglib to:(TagBase *) tag {
    TagLib::MP4::CoverArtList picFrames = taglib->itemListMap()[MP4_COVER_ART].toCoverArtList();
    if (!picFrames.size()) {
        return;
    }
    
    const TagLib::ByteVector & bv = picFrames[0].data();
    NSData * picData = [NSData dataWithBytes:bv.data() length:bv.size()];
    NSImage * image = [[NSImage alloc] initWithData:picData];
    if (image) {
        [tag.pictureTL setObject:image forKey:@COVER_ART];
    }
}

-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {
        return;
    }
    
    [super write:tag toTaglib:taglib];
    
    TagLib::MP4::Tag * mp4Tag = dynamic_cast<TagLib::MP4::Tag *>(taglib);
    
    if (mp4Tag == nil) {
        return;
    }
    
    TagLib::MP4::ItemListMap & itemListMap = mp4Tag->itemListMap();
    itemListMap[MP4_COMPOSER] = TagLib::StringList([NSString TLStringFromString:tag.composer]);
    itemListMap[MP4_COPYRIGHT] = TagLib::StringList([NSString TLStringFromString:tag.copyright]);
    
    [self _writePic:[tag coverArt] to:mp4Tag withType:MP4_COVER_ART];
}

-(void) _writePic:(NSImage *) pic to:(TagLib::MP4::Tag *) mp4Tag withType:(const std::string &) type {
    if (!pic) {
        return;
    }
    
    BOOL coverArtListFound = false;
    
    TagLib::MP4::ItemListMap & itemListMap = mp4Tag->itemListMap();
    TagLib::MP4::CoverArtList cr = TagLib::MP4::CoverArtList();
    
    if (itemListMap.contains(type)) {
        cr = itemListMap[type].toCoverArtList();
        coverArtListFound = true;
    }
    
    if (pic == [NSImage nullImage]) {
        if (coverArtListFound && cr.size()) {
            cr.erase(cr.begin());
            itemListMap[type] = cr;            
        }
        return;
    }
    
    NSData * picData = [pic toData];
    TagLib::ByteVector bv((const char *)[picData bytes], (uint)[picData length]);
    
    TagLib::MP4::CoverArt coverArt(TagLib::MP4::CoverArt::Format::JPEG, bv);
    if (cr.size()) {
        cr.erase(cr.begin());
    }
    cr.prepend(coverArt);
    itemListMap[type] = cr;
}
@end
