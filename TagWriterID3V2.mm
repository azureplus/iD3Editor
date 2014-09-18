//
//  TagWriterID3V2.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagWriterID3V2.h"
#import "taglib/id3v2tag.h"
#import "NSString_TLString.h"

@implementation TagWriterID3V2
-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    [super write:tag toTaglib:taglib];
    
    TagLib::ID3v2::Tag * id3Tag = dynamic_cast<TagLib::ID3v2::Tag *>(taglib);
    
    if (id3Tag != nil) {
        id3Tag->setTextFrame("TCOM", [tag.composer toTLString]);
        id3Tag->setTextFrame("TCOP", [tag.copyright toTLString]);
    }
}
@end
