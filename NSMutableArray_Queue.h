//
//  NSMutableArray+NSMutableArray_Queue.h
//  iD3
//
//  Created by Qiang Yu on 11/7/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NSMutableArray_Queue)
-(BOOL) isEmpty;
-(id) dequeue;
-(void) enqueue:(id)obj;
-(void) enqueueArray:(NSArray *)array;
@end
