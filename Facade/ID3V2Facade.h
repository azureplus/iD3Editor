//
//  ID3V2Facade.h
//  iD3
//
//  Created by Qiang Yu on 3/17/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "taglib/id3v2tag.h"
#import "TagFacade.h"

@interface ID3V2Facade : NSObject<TagFacade>
-(id) initWithTag:(const TagLib::ID3v2::Tag *) tag;
@end
