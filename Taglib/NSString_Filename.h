//
//  NSString.h
//  iD3
//
//  Created by Qiang Yu on 7/31/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagEntity.h"
@interface NSString(FileName)
-(NSDictionary *) tagFromFileNameWithPattern:(NSString *)pattern;
+(NSString *) fromTag:(TagEntity *)tag withPattern:(NSString *)pattern;
@end
