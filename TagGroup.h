//
//  TagCollection.h
//  iD3
//
//  Created by Qiang Yu on 9/16/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagProtocol.h"
#import "TagBase.h"

@interface TagGroup : NSObject<TagProtocol>
@property(assign, nonatomic) BOOL valid;
-(id<TagProtocol>)addTagLib: (TagLib::Tag *) tag;
@end
