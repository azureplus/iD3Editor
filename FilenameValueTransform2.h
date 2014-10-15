//
//  FilenameValueTransform2.h
//  iD3
//
//  Created by Qiang Yu on 9/19/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilenameValueTransform2 : NSValueTransformer
+ (void) setPathDepth: (unsigned int)depth;
+ (unsigned int) pathDepth;
+ (NSString *) filenameToParse:(NSString *) filename;
@end
