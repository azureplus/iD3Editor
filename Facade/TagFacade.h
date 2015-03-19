//
//  TagFacade.h
//  iD3
//
//  Created by Qiang Yu on 3/17/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagConstants.h"

@protocol TagFacade
// get value(s) of given frame
-(NSMutableArray *) getFrame:(NSString *) frameName;

// set values of given tag
-(void) setFrame:(NSString *) frameName withStringValues:(NSArray *) values;
-(void) setFrame:(NSString *) frameName withNumberValues:(NSArray *) values;
-(void) setFrame:(NSString *) frameName withImageValues:(NSArray *) values;

// set string encoding
-(void) setCharEncoding: (unsigned int) encoding;

//
-(NSUInteger) tagType;
@end
