//
//  TagEntity_Encoding.m
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagEntity_Encoding.h"
#import "Tag.h"

@implementation TagEntity(Encoding)

-(void)convertFrame:(NSString *)frame toEncoding:(unsigned int)encoding {
    NSString * value = [self.tag getFrame:frame withCharEncoding:encoding];
    if (value) {
        [self setValue:value forKey:frame];
    }
}

-(void)convertFramestoEncoding:(unsigned int)encoding {
    [self convertFrame:@"ARTIST" toEncoding:encoding];
    [self convertFrame:@"ALBUM" toEncoding:encoding];
    [self convertFrame:@"COMMENT" toEncoding:encoding];
    [self convertFrame:@"TITLE" toEncoding:encoding];
    [self convertFrame:@"GENRE" toEncoding:encoding];
    [self convertFrame:@"DATE" toEncoding:encoding];
    [self convertFrame:@"TRACKNUMBER" toEncoding:encoding];
    [self convertFrame:@"PERFORMER" toEncoding:encoding];
    [self convertFrame:@"COMPOSER" toEncoding:encoding];
    [self convertFrame:@"COPYRIGHT" toEncoding:encoding];
}
@end
