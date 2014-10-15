//
//  TagReaderWriterFactory.h
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
# include "taglib/tag.h"
#endif

#import "TagReader.h"
#import "TagWriter.h"

@interface TagReaderWriterFactory : NSObject
+(id<TagReader>) getReader:(TagLib::Tag *)tag;
+(id<TagWriter>) getWriter:(TagLib::Tag *)tag;
@end
