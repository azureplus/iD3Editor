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

#define COMPOSER "COMPOSER"
#define COPYRIGHT "COPYRIGHT"

@protocol TagProtocol <NSObject>
-(NSString *) artist;
-(NSString *) album;
-(NSString *) genre;
-(NSString *) title;
-(NSString *) comment;
-(NSString *) composer;
-(NSString *) copyright;
-(NSNumber *) year;
-(NSNumber *) track;

-(void)setArtist:(NSString *)value;
-(void)setAlbum:(NSString *)value;
-(void)setGenre:(NSString *)value;
-(void)setTitle:(NSString *)value;
-(void)setComment:(NSString *)value;
-(void)setComposer:(NSString *)value;
-(void)setCopyright:(NSString *)value;
-(void)setYear:(NSNumber *)value;
-(void)setTrack:(NSNumber *)value;

-(void) setCharEncoding: (unsigned int) encoding;
-(BOOL) updated;
-(void) discardChanges;
@end
