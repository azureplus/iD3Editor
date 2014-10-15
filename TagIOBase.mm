//
//  TagIOBase.m
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "TagIOBase.h"
#import "NSString_TLString.h"
#import "TagBase.h"

@implementation TagIOBase
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib {
    return [[TagBase alloc] initWithTag:taglib];;
}

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
