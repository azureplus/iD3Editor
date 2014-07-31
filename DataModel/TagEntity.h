//
//  TagEntity.h
//  iD3
//
//  Created by Qiang Yu on 7/29/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Tag.h"

@interface TagEntity : NSManagedObject

@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * attribute;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * track;
@property (nonatomic, retain) NSString * year;

@property (nonatomic, weak) Tag * tag;

-(void) resetValue;

@end
