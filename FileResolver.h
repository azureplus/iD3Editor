//
//  FileResolver.h
//  iD3
//
//  Created by Qiang Yu on 9/17/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagProtocol.h"

@interface FileResolver : NSObject
+(id<TagProtocol>) read:(NSString *)filename;
+(void)writeTag:(id<TagProtocol>)tag to:(NSString *)filename;
@end
