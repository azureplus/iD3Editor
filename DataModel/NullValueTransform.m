//
//  NullValueTransform.m
//  iD3
//
//  Created by Qiang Yu on 8/6/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "NullValueTransform.h"

@implementation NullValueTransform
+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id) value {
    if (value == [NSNull null]) {
        return @"";
    } else {
        return value;
    }
}
@end
