//
//  TagEntity_Filename.m
//  iD3
//
//  Created by Qiang Yu on 8/3/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagEntity_Filename.h"
#import "NSString_Filename.h"

@implementation TagEntity(filename)
-(void) fromFilenameWithPattern: (NSString *)pattern {
    NSDictionary * frames = [self.filename parse:pattern];
    for(NSString * key in frames) {
        [self setValue:[frames objectForKey:key] forKeyPath:key];
    }
}
@end
