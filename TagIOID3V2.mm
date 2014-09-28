//
//  TagIOID3V2.m
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagIOID3V2.h"
#import "taglib/id3v2tag.h"
#import "taglib/attachedpictureframe.h"
#import "TagBase.h"
#import "NSString_TLString.h"
#import "NSImage_NSData.h"

@implementation TagIOID3V2
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib {
    TagBase * tag = [super readTaglib:taglib];
    
    TagLib::ID3v2::Tag * id3Tag = dynamic_cast<TagLib::ID3v2::Tag *>(taglib);
    if (id3Tag) {
        const TagLib::ID3v2::FrameList & tcomFrameList = id3Tag->frameList("TCOM");
        if (!tcomFrameList.isEmpty()) {
            tag.composerTL = tcomFrameList[0]->toString();
        }
        
        const TagLib::ID3v2::FrameList & tcopFrameList = id3Tag->frameList("TCOP");
        if (!tcopFrameList.isEmpty()) {
            tag.copyrightTL =  tcopFrameList[0]->toString();
        }
        
        [self _readPicturesFrom:id3Tag to:tag];
    }
    
    return tag;
}


// currently only supports front cover (the first one found)
-(void) _readPicturesFrom:(TagLib::ID3v2::Tag *) taglib to:(TagBase *) tag {
    TagLib::ID3v2::FrameList picFrames = taglib->frameList("APIC");

    for (std::list<TagLib::ID3v2::Frame *>::iterator it = picFrames.begin(); it != picFrames.end(); it++) {
        TagLib::ID3v2::AttachedPictureFrame * pic = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
        if (!pic || pic->type() != TagLib::ID3v2::AttachedPictureFrame::Type::FrontCover) {
            continue;
        }
        
        const TagLib::ByteVector & bv = pic->picture();
        NSData * picData = [NSData dataWithBytes:bv.data() length:bv.size()];
        NSImage * image = [[NSImage alloc] initWithData:picData];
        [tag.pictureTL setObject:image forKey:@COVER_ART];
    }
}

-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {
        return;
    }
    
    [super write:tag toTaglib:taglib];
    
    TagLib::ID3v2::Tag * id3Tag = dynamic_cast<TagLib::ID3v2::Tag *>(taglib);
    
    if (id3Tag == nil) {
        return;
    }

    id3Tag->setTextFrame("TCOM", [NSString TLStringFromString:tag.composer]);
    id3Tag->setTextFrame("TCOP", [NSString TLStringFromString:tag.copyright]);

    // currenlty only supports front cover
    [self _writePic:[tag coverArt] to:id3Tag withType:TagLib::ID3v2::AttachedPictureFrame::Type::FrontCover];
}


-(void) _writePic:(NSImage *) pic to:(TagLib::ID3v2::Tag *) taglib withType:(TagLib::ID3v2::AttachedPictureFrame::Type) type {
    TagLib::ID3v2::FrameList picFrames = taglib->frameList("APIC");
    TagLib::ID3v2::AttachedPictureFrame * frameFound = nil;
    
    for (std::list<TagLib::ID3v2::Frame *>::iterator it = picFrames.begin(); it != picFrames.end(); it++) {
        TagLib::ID3v2::AttachedPictureFrame * pic = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
        if (pic && pic->type() == type) {
            frameFound = pic;
            break;
        }
    }
    
    if (!frameFound) {
        frameFound = new TagLib::ID3v2::AttachedPictureFrame();
        taglib->addFrame(frameFound);
    }
    
    NSData * picData = [pic toData];
    TagLib::ByteVector bv((const char *)[picData bytes], (uint)[picData length]);
    
    frameFound->setType(type);
    frameFound->setMimeType("image/png");
    frameFound->setPicture(bv);
}
@end
