//
//  TagNameMapping.m
//  iD3
//
//  Created by Qiang Yu on 3/17/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import "TagNameMapping.h"
#import "TagConstants.h"

@implementation TagNameMapping

+(TagNameMapping *) sharedInstance {
    static TagNameMapping * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(NSString *) frameNameOfAttribute:(NSString *) attribute withTagType:(NSUInteger)tagType {
    return @"";
}

-(NSUInteger) frameTypeOfAttribute:(NSString *) attribute withTagType:(NSUInteger)tagType {
    return FRAME_TYPE_STRING;
}
@end
