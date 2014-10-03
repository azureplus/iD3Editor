//
//  TagIOXIPH.m
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "TagIOXIPH.h"
#import "taglib/xiphcomment.h"
#import "taglib/attachedpictureframe.h"
#import "TagBase.h"
#import "NSString_TLString.h"

@implementation TagIOXIPH
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib {
    TagBase * tag = [super readTaglib:taglib];
    
    TagLib::Ogg::XiphComment * xiphTag = dynamic_cast<TagLib::Ogg::XiphComment *>(taglib);
    if (xiphTag) {
        const TagLib::Ogg::FieldListMap & fieldMap = xiphTag->fieldListMap();
        if (!fieldMap[COMPOSER_FRAME].isEmpty()) {
            tag.composerTL = fieldMap[COMPOSER_FRAME].front();
        }
        
        if (!fieldMap[COPYRIGHT_FRAME].isEmpty()) {
            tag.copyrightTL = fieldMap[COPYRIGHT_FRAME].front();
        }
        
        [self _readPicturesFrom:xiphTag to:tag];
    }
    
    return tag;
}

// currently only supports front cover (the first one found)
-(void) _readPicturesFrom:(TagLib::Ogg::XiphComment *) taglib to:(TagBase *) tag {
    const TagLib::Ogg::FieldListMap & fieldMap = taglib->fieldListMap();
    TagLib::StringList mimeList = fieldMap["COVERARTMIME"];
    TagLib::StringList artList = fieldMap["COVERART"];
    
    NSData * data = nil;
    
    if (mimeList.size() !=0  && artList.size() != 0) {
        data = [[NSData alloc] initWithBase64EncodedString:[NSString newStringFromTLString:artList[0]] options:0];
    } else {
        artList = fieldMap["METADATA_BLOCK_PICTURE"];
        
        for (TagLib::StringList::Iterator itor = artList.begin(); itor != artList.end(); itor++) {
            data = [[NSData alloc] initWithBase64EncodedString:[NSString newStringFromTLString:(*itor)]options:0];

            if ([data length] < 4 + 4 + 4 + 4 * 4 + 4) {
                continue;
            }
            
            const Byte * bytes = (const Byte *)[data bytes];
            int32_t type = CFSwapInt32BigToHost(*(int32_t *)bytes);
            
            if (type != TagLib::ID3v2::AttachedPictureFrame::Type::FrontCover) { // only process COVER ART
                continue;
            }
            
            // skip mime
            const Byte * ptr = bytes + 4;
            int32_t mimeLen = CFSwapInt32BigToHost(*(int32_t *)ptr);
            if (mimeLen < 0) {
                continue;
            }
            
            ptr += 4 + mimeLen;
            if (ptr - bytes + 4 > [data length]) {
                continue;
            }
            
            // skip description
            int32_t descLen = CFSwapInt32BigToHost(*(int32_t *)ptr);
            if (descLen < 0) {
                continue;
            }
            
            ptr += 4 + descLen;
            if (ptr - bytes + 4 > [data length]) {
                continue;
            }
            
            // pic data is here
            int32_t picLen = CFSwapInt32BigToHost(*(int32_t *)ptr);
            if (picLen < 0 || ptr + 4 + picLen - bytes > [data length]) {
                continue;
            }
            ptr += 4;
            data = [data subdataWithRange:NSMakeRange(ptr - bytes, picLen)];
            NSImage * image = [[NSImage alloc] initWithData:data];
            if (image) {
                [tag.pictureTL setObject:image forKey:@COVER_ART];
            }
        }
    }
}


-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {                return;
    }
    
    [super write:tag toTaglib:taglib];
    
    TagLib::Ogg::XiphComment * xiphTag = dynamic_cast<TagLib::Ogg::XiphComment *>(taglib);
    
    if (xiphTag) {
        xiphTag->addField(COMPOSER_FRAME, [NSString TLStringFromString:tag.composer]);
        xiphTag->addField(COPYRIGHT_FRAME, [NSString TLStringFromString:tag.copyright]);
    }
}
@end
