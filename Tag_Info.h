//
//  Tag_Info.h
//  iD3
//
//  Created by Qiang Yu on 8/12/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//
#import "Tag.h"
#import "taglib/infotag.h"

@interface Tag(Info)
-(void)setINFOFrames:(NSDictionary *)frames withTag:(TagLib::RIFF::Info::Tag *) tag;
-(NSDictionary *)getINFOFramesWithTag:(TagLib::RIFF::Info::Tag *)tag;
-(NSDictionary *)getINFOFramesWithTag:(TagLib::RIFF::Info::Tag *)tag andCharEncoding:(unsigned int)encoding;
@end
