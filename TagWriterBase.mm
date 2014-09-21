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
        
    taglib->setArtist([NSString TLStringFromString:tag.artist]);
    taglib->setAlbum([NSString TLStringFromString:tag.album]);
    taglib->setTitle([NSString TLStringFromString:tag.title]);
    taglib->setGenre([NSString TLStringFromString:tag.genre]);
    taglib->setComment([NSString TLStringFromString:tag.comment]);
    
    taglib->setYear([tag.year unsignedIntValue]);
    taglib->setTrack([tag.track unsignedIntValue]);
}
@end
