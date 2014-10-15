//
//  TagIOBase.h
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagReader.h"
#import "TagWriter.h"

@interface TagIOBase : NSObject<TagReader, TagWriter>

@end
