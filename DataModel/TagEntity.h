//
//  TagEntity.h
//  iD3
//
//  Created by Qiang Yu on 7/29/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TagProtocol.h"

@interface TagEntity : NSManagedObject

@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * albumArtist;
@property (nonatomic, retain) NSString * composer;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * track;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * copyright;
@property (nonatomic, retain) NSString * discNum;
@property (nonatomic, retain) NSString * discTotal;
@property (nonatomic, retain) id coverArt;

@property (nonatomic, strong) id<TagProtocol> tag;

-(void) setCharEncoding: (unsigned int) charEncoding;
-(BOOL) updated;
-(void) resetValue;
@end
