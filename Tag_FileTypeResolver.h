//
//  Tag_FileTypeResolver.h
//  iD3
//
//  Created by Qiang Yu on 8/9/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//
#import "Tag.h"

@interface Tag(FileTypeResolver)
-(void)resolveSetFrames: (NSDictionary *) frames;
-(NSDictionary *)resolveGetFramesWithEncoding:(unsigned int)encoding;
-(NSDictionary *)resolveGetFrames;
@end
