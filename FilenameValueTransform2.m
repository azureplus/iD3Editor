//
//  FilenameValueTransform2.m
//  iD3
//
//  Created by Qiang Yu on 9/19/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "FilenameValueTransform2.h"

static unsigned int pathDepth = 0;

@implementation FilenameValueTransform2
+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

+ (void) setPathDepth: (unsigned int)depth {
    pathDepth = depth;
}

+ (unsigned int) pathDepth {
    return pathDepth;
}

+ (NSString *) filenameToParse:(NSString *) filename {
    NSArray * components = [filename pathComponents];
    NSMutableString * rv = [NSMutableString stringWithCapacity:256];
 
    NSUInteger cc = components.count;
    NSInteger start = cc - 1 - pathDepth;
    start = start >= 0 ? start : 0;
    NSInteger index = start;
 
    while (index < cc) {
        if (index > start && ![components[index - 1] isEqualToString:@"/"]) {
            [rv appendString:@"/"];
        }
        [rv appendString:components[index]];
        index++;
    }
 
    return rv;
 }

- (id)transformedValue:(id) value {
    return [FilenameValueTransform2 filenameToParse:value];
}
@end
