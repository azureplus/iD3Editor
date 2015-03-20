//
//  NSString+ToIntegerCompare.h
//  iD3
//
//  Created by Qiang Yu on 3/19/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ToIntegerCompare)
- (NSComparisonResult)toIntegerCompare:(NSString *)aString;
@end
