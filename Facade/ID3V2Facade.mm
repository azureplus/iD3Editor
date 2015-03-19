//
//  ID3V2Facade.m
//  iD3
//
//  Created by Qiang Yu on 3/17/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import "ID3V2Facade.h"
#import "taglib/id3v2tag.h"
#import "taglib/attachedpictureframe.h"
#import "NSString_TLString.h"
#import "NSImage_NSData.h"
#import "TagNameMapping.h"

@interface ID3V2Facade()
@property(nonatomic, assign) const TagLib::ID3v2::Tag * tag;
@property(nonatomic, assign) unsigned int charEncoding;
@end

@implementation ID3V2Facade

-(id) initWithTag:(const TagLib::ID3v2::Tag *) tag{
    if (self = [super init]) {
        self.tag = tag;
        self.charEncoding = DEFAULT_ENCODING;
    }
    
    return self;
}

// get value(s) of given tag
-(NSMutableArray *) getFrame:(NSString *) frameName {
    frameName = [[TagNameMapping sharedInstance] frameNameOfAttribute:frameName withTagType:[self tagType]];
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:4];
    NSUInteger tagType = [[TagNameMapping sharedInstance] frameTypeOfAttribute:frameName withTagType:[self tagType]];
    
    const TagLib::ID3v2::FrameList & frameList = self.tag->frameList([frameName cStringUsingEncoding:NSUTF8StringEncoding]);
    
    TagLib::ID3v2::FrameList::ConstIterator it = frameList.begin();
    while (it != frameList.begin()) {
        if (tagType == FRAME_TYPE_STRING) {
            NSString * value = [NSString newStringFromTLString:(*it)->toString() withEncoding:self.charEncoding];
            [result addObject:value];
        }
        it++;
    }
    
    return result;
}

// set values of given tag
-(void) setFrame:(NSString *) frameName withStringValues:(NSArray *) values {
    
}

-(void) setFrame:(NSString *) frameName withNumberValues:(NSArray *) values {
    
}

-(void) setFrame:(NSString *) frameName withImageValues:(NSArray *) values {
    
}

-(NSUInteger) tagType {
    return TAG_TYPE_ID3V2;
}
@end
