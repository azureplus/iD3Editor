//
//  FirstSelectedFileValueTransform.m
//  iD3
//
//  Created by Qiang Yu on 8/3/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "FirstSelectedFileValueTransform.h"

// returns the first selected file name
@implementation FirstSelectedFileValueTransform
+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id) value {
    NSArray * filenames = value;
    if (filenames.count > 0)
        return filenames[0];
    else
        return @"";
}
@end
