//
//  NSArray_KVO.m
//  iD3
//
//  Created by Qiang Yu on 8/4/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "NSArray_KVO.h"

//
// http://stackoverflow.com/questions/12054846/keypath-for-first-element-in-embedded-nsarray
//
@implementation NSArray(KVO)
-(id)_firstForKeyPath:(NSString *) keyPath {
    NSArray* array = [self valueForKeyPath: keyPath];
    if( [array respondsToSelector: @selector(objectAtIndex:)] &&
       [array respondsToSelector: @selector(count)]) {
        if( [array count] )
            return [array objectAtIndex: 0];
        else
            return nil;
    }
    else {
        return nil;
    }
}
@end
