//
//  TagEntity_Encoding.m
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagEntity_Encoding.h"
#import "Tag.h"
#import "Tag_FileTypeResolver.h"

@implementation TagEntity(Encoding)
-(void)convertFramestoEncoding:(unsigned int)encoding {
    NSDictionary * frames = [self.tag resolveGetFramesWithEncoding:encoding];

    for (NSString * key in frames) {
        NSString * frame = [self F2f:key];
        if (frame) {
            [self setValue:frames[key] forKey:frame];
        }
    }
}
@end
