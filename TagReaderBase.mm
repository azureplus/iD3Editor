//
//  TagReaderBase.m
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagReaderBase.h"
#import "NSString_TLString.h"
#import "TagBase.h"


@implementation TagReaderBase
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib {
    TagBase * tag = [[TagBase alloc] init];
    
    tag.charEncoding  = DEFAULT_ENCODING;
    
    tag.artistTL = taglib->artist();
    tag.albumTL = taglib->album();
    tag.titleTL = taglib->title();
    tag.genreTL = taglib->genre();
    tag.commentTL = taglib->comment();
    
    tag.yearTL = taglib->year();
    tag.trackTL = taglib->track();
    tag.copyrightTL = TagLib::String::null;
    tag.composerTL = TagLib::String::null;
    
    return tag;
}
@end
