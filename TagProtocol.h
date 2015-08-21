//
//  TagProtocol.h
//  iD3
//
//  Created by Qiang Yu on 9/14/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
# include "taglib/tag.h"
#endif

#define COMPOSER_FRAME "COMPOSER"
#define COPYRIGHT_FRAME "COPYRIGHT"

@protocol TagProtocol <NSObject>
-(NSString *) artist;
-(NSString *) album;
-(NSString *) albumArtist;
-(NSString *) genre;
-(NSString *) title;
-(NSString *) comment;
-(NSString *) composer;
-(NSString *) copyright;
-(NSNumber *) year;
-(NSNumber *) track;
-(NSImage *) coverArt;
-(NSNumber *) discNum;
-(NSNumber *) discTotal;

-(void)setArtist:(NSString *)value;
-(void)setAlbum:(NSString *)value;
-(void)setAlbumArtist:(NSString *)value;
-(void)setGenre:(NSString *)value;
-(void)setTitle:(NSString *)value;
-(void)setComment:(NSString *)value;
-(void)setComposer:(NSString *)value;
-(void)setCopyright:(NSString *)value;
-(void)setYear:(NSNumber *)value;
-(void)setTrack:(NSNumber *)value;
-(void)setCoverArt:(NSImage*)coverArt;
-(void)setDiscNum:(NSString *)discNum;
-(void)setDiscTotal:(NSString *)discTotal;

-(void) setCharEncoding: (unsigned int) encoding;
-(BOOL) updated;
-(void) discardChanges;
-(void) savedChanges;
@end
