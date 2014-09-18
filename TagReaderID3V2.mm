//
//  TagReaderID3V2.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagReaderID3V2.h"
#import "taglib/id3v2tag.h"
#import "TagBase.h"

@implementation TagReaderID3V2
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
    }

    return tag;
}
@end
