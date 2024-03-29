//
//  TagWriter.h
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagProtocol.h"

@protocol TagWriter <NSObject>
#ifdef __cplusplus
-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib;
#endif
@end
