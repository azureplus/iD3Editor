//
//  FileTags.h
//  iD3
//
//  Created by Qiang Yu on 3/18/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "taglib/fileref.h"
#import "TagFacade.h"

@interface FileTags : NSObject
@property (nonatomic, strong) NSMutableArray * tagFacades;
-(id) initWithFileRef:(NSString *) fileName;
@end
