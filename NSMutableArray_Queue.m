//
//  NSMutableArray+NSMutableArray_Queue.m
//  iD3
//
//  Created by Qiang Yu on 11/7/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "NSMutableArray_Queue.h"

@implementation NSMutableArray (NSMutableArray_Queue)
-(BOOL) isEmpty {
    return self.count == 0;
}

-(id) dequeue {
    if ([self isEmpty]) {
        return nil;
    } else {
        id obj = [self objectAtIndex:0];
        [self removeObjectAtIndex:0];
        return obj;
    }
}

-(void) enqueue:(id)obj {
    if (obj) {
        [self addObject:obj];
    }
}

-(void) enqueueArray:(NSArray *)array {
    [self addObjectsFromArray:array];
}

@end
