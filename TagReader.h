//
//  TagReader.h
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagProtocol.h"

@protocol TagReader <NSObject>
#ifdef __cplusplus 
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib;
#endif
@end
