//
//  NSString.h
//  iD3
//
//  Created by Qiang Yu on 7/31/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagEntity.h"
@interface NSString(FileName)
-(NSDictionary *) parse:(NSString *)pattern;
+(NSString *) fromTag:(TagEntity *)tag withPattern:(NSString *)pattern andTrackSize:(NSUInteger)trackSize;
+(NSString *) fromFrames: (NSDictionary *)frames withPattern:(NSString *)pattern andTrackSize:(NSUInteger)trackSize;
@end
