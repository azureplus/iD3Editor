//
//  CoverArtTransformer.m
//  iD3
//
//  Created by Qiang Yu on 3/24/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import "CoverArtTransformer.h"
#import "NSImage_NSData.h"

@implementation CoverArtTransformer
+ (Class)transformedValueClass {
    return [NSImage class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id) value {
    if (value == nil) {
        value = [NSImage coverartNoImage];
    } else {
        value = [NSImage coverartYesImage];
    }

    return value;
}
@end
