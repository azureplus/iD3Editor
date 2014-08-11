//
//  Tag_APE.h
//  iD3
//
//  Created by Qiang Yu on 8/8/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag.h"
#import "taglib/apefile.h"
#import "taglib/apetag.h"

@interface Tag(APE)
-(void)setAPEFrames:(NSDictionary *)frames withTag:(TagLib::APE::Tag *) tag;
-(NSDictionary *)getAPEFramesWithTag:(TagLib::APE::Tag *)tag;
-(NSDictionary *)getAPEFramesWithTag:(TagLib::APE::Tag *)tag andCharEncoding:(unsigned int)encoding;
@end