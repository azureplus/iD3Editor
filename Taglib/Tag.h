//
//  Taglib.h
//  iD3
//
//  Created by Qiang Yu on 7/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
# include "taglib/fileref.h"
# include "taglib/tag.h"
#endif

@interface Tag : NSObject {
}

@property(nonatomic, readonly) NSString * filename;

-(id) initWithFile: (NSString *) fileName;
-(void)saveFrames:(NSDictionary *)frames;
#ifdef __cplusplus
-(NSString *) convertTLString: (const TagLib::String &) value toEncoding: (unsigned int) encoding;
-(NSMutableDictionary *)getStandardFramesWithTag:(TagLib::Tag *)tag;
-(NSMutableDictionary *)getStandardFramesWithTag:(TagLib::Tag *)tag andCharEncoding:(unsigned int)encoding;
#endif
@end
