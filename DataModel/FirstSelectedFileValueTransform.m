//
//  FirstSelectedFileValueTransform.m
//  iD3
//
//  Created by Qiang Yu on 8/3/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "FirstSelectedFileValueTransform.h"

// This value transform is being used in window "Tag and File Name".
// In the window, there is a multi-line label showing a sample selected filename.
// This multi-line label makes use of this transform to display the name of first selected files.
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
