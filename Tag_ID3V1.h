//
//  Tag_ID3V1.h
//  iD3
//
//  Created by Qiang Yu on 8/12/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//
#import "Tag.h"
#import "taglib/id3v1tag.h"

@interface Tag(ID3V1)
-(void)setID3V1Frames:(NSDictionary *)frames withTag:(TagLib::ID3v1::Tag *) tag;
-(NSDictionary *)getID3V1FramesWithTag:(TagLib::ID3v1::Tag *)tag;
-(NSDictionary *)getID3V1FramesWithTag:(TagLib::ID3v1::Tag *)tag andCharEncoding:(unsigned int)encoding;
@end
