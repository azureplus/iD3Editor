//
//  Tag_FLAC.h
//  iD3
//
//  Created by Qiang Yu on 8/8/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//
#import "Tag.h"
#import "taglib/id3v2tag.h"
@interface Tag(ID3V2)
-(void)setID3V2Frames:(NSDictionary *)frames withTag:(TagLib::ID3v2::Tag *) tag;
@end
