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
    [self convertFrame:@"artist" toEncoding:encoding];
    [self convertFrame:@"album" toEncoding:encoding];
    [self convertFrame:@"comment" toEncoding:encoding];
    [self convertFrame:@"title" toEncoding:encoding];
    [self convertFrame:@"genre" toEncoding:encoding];
    [self convertFrame:@"year" toEncoding:encoding];
    [self convertFrame:@"track" toEncoding:encoding];
    [self convertFrame:@"performer" toEncoding:encoding];
    [self convertFrame:@"composer" toEncoding:encoding];
    [self convertFrame:@"copyright" toEncoding:encoding];
}
@end
