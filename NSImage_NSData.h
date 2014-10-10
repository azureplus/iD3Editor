//
//  NSImage_NSData.h
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "TagIOBase.h"

@interface NSImage(NSData)
-(NSData *)toData;
+(NSImage *) nullImage;
+(NSImage *) placeholderImage;
+(NSImage *) multiplePlaceholderImage;
@end
