//
//  TagEntity_Encoding.h
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagEntity.h"

@interface TagEntity(Encoding)
-(void)convertFrame:(NSString *)frame toEncoding:(unsigned int)encoding;
-(void)convertFramestoEncoding:(unsigned int)encoding;
@end
