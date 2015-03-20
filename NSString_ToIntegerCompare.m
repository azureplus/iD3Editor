//
//  NSString+ToIntegerCompare.m
//  iD3
//
//  Created by Qiang Yu on 3/19/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import "NSString_ToIntegerCompare.h"

@implementation NSString (ToIntegerCompare)
- (NSComparisonResult)toIntegerCompare:(NSString *)aString {
    int v1 = [self intValue];
    int v2 = [aString intValue];
    
    if (v1 == v2) {
        return NSOrderedSame;
    } else if (v1 < v2) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}
@end
