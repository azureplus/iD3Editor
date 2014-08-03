//
//  TagEntity_Filename.h
//  iD3
//
//  Created by Qiang Yu on 8/3/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagEntity.h"

@interface TagEntity(filename)
-(void) fromFilenameWithPattern: (NSString *)pattern;
@end
