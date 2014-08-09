//
//  Tag_XIPHComment.h
//  iD3
//
//  Created by Qiang Yu on 8/8/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag.h"
#import "taglib/xiphcomment.h"

@interface Tag(XIPHComment)
-(void)setXIPHCOMMENTFrames:(NSDictionary *)frames withTag:(TagLib::Ogg::XiphComment *)tag;
@end
