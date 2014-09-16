//
//  TagID3V2.m
//  iD3
//
//  Created by Qiang Yu on 9/14/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagID3V2.h"
#import "taglib/id3v2tag.h"
#import "NSString_TLString.h"

@implementation TagID3V2
-(id) initWithTag: (TagLib::Tag *) tag {
    if (self = [super initWithTag:tag]) {
        TagLib::ID3v2::Tag * id3Tag = dynamic_cast<TagLib::ID3v2::Tag *>(tag);
        
        const TagLib::ID3v2::FrameList & tcomFrameList = id3Tag->frameList("TCOM");
        if (!tcomFrameList.isEmpty()) {
            self.composerTL = tcomFrameList[0]->toString();
        }
        
        const TagLib::ID3v2::FrameList & tcopFrameList = id3Tag->frameList("TCOP");
        if (!tcopFrameList.isEmpty()) {
            self.copyrightTL =  tcopFrameList[0]->toString();
        }
    }
    
    return self;
}

-(void) writeFramesToTag:(TagLib::Tag *) tag {
    [super writeFramesToTag:tag];
    
    TagLib::ID3v2::Tag * id3Tag = dynamic_cast<TagLib::ID3v2::Tag *>(tag);
    
    if (id3Tag != nil) {
        id3Tag->setTextFrame("TCOM", [self.composer toTLString]);        
        id3Tag->setTextFrame("TCOP", [self.copyright toTLString]);
    }
}
@end
