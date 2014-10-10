//
//  ImageValueTransform.m
//  iD3
//
//  Created by Qiang Yu on 10/9/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "ImageValueTransform.h"
#import "NSImage_NSData.h"

@implementation ImageValueTransform
+ (Class)transformedValueClass {
    return [NSImage class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id) value {
    if (value == nil || value == [NSImage nullImage]) {
        value = [NSImage nullPlaceholderImage];
    }
    
    return value;
}

- (id)reverseTransformedValue:(id)value {
    return value;
}
@end
