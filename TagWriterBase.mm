//
//  TagWriterBase.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagWriterBase.h"
#import "NSString_TLString.h"

@implementation TagWriterBase
-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {
        return;
    }
        
    taglib->setArtist([tag.artist toTLString]);
    taglib->setAlbum([tag.album toTLString]);
    taglib->setTitle([tag.title toTLString]);
    taglib->setGenre([tag.genre toTLString]);
    taglib->setComment([tag.comment toTLString]);
    
    taglib->setYear([tag.year unsignedIntValue]);
    taglib->setTrack([tag.track unsignedIntValue]);
}
@end
