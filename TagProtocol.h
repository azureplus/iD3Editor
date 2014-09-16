//
//  TagProtocol.h
//  iD3
//
//  Created by Qiang Yu on 9/14/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
# include "taglib/tag.h"
#endif

@protocol TagProtocol <NSObject>
-(NSString *) artist;
-(NSString *) album;
-(NSString *) genre;
-(NSString *) comment;
-(NSString *) composer;
-(NSNumber *) year;
-(NSNumber *) track;
-(void) setCharEncoding: (unsigned int) encoding;
-(BOOL) updated;
-(void) writeFramesToTag:(TagLib::Tag *) tag;
-(void) discardChanges;
@end
