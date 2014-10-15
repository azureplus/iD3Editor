//
//  FilenameValueTransform.m
//  iD3
//
//  Created by Qiang Yu on 8/4/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "FilenameValueTransform.h"

@implementation FilenameValueTransform
+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id) value {
    NSString * name = value;
    return [name lastPathComponent];
}
@end
