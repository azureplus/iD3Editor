//
//  TagLibBase.h
//  iD3
//
//  Created by Qiang Yu on 9/14/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagProtocol.h"
#import "taglib/tag.h"

#define COVER_ART "COVER_ART"

@interface TagBase : NSObject<TagProtocol>
-(id) initWithTag: (TagLib::Tag *) tag;

// original tag frame values
@property (nonatomic, assign) TagLib::String artistTL;
@property (nonatomic, assign) TagLib::String albumTL;
@property (nonatomic, assign) TagLib::String commentTL;
@property (nonatomic, assign) TagLib::String genreTL;
@property (nonatomic, assign) TagLib::String titleTL;
@property (nonatomic, assign) TagLib::String composerTL;
@property (nonatomic, assign) TagLib::String copyrightTL;
//
@property (nonatomic, assign) NSUInteger yearTL;
@property (nonatomic, assign) NSUInteger trackTL;


// new tag frame values
@property (nonatomic, strong) NSString * artist;
@property (nonatomic, strong) NSString * album;
@property (nonatomic, strong) NSString * comment;
@property (nonatomic, strong) NSString * genre;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * composer;
@property (nonatomic, strong) NSString * copyright;
@property (nonatomic, strong) NSNumber * year;
@property (nonatomic, strong) NSNumber * track;

// non-standard frames
@property (nonatomic, readonly) NSMutableDictionary * pictureTL;
@property (nonatomic, readonly) NSMutableDictionary * picture;

// assigned encoding
@property (nonatomic, assign) unsigned int charEncoding;

@end
