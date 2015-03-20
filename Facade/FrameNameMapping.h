//
//  TagNameMapping.h
//  iD3
//
//  Created by Qiang Yu on 3/17/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrameNameMapping : NSObject
+(FrameNameMapping *) sharedInstance;
-(NSString *) frameNameOfAttribute:(NSString *) attribute withTagType:(NSUInteger)tagType;
-(NSUInteger) frameTypeOfAttribute:(NSString *) attribute withTagType:(NSUInteger)tagType;
@end
