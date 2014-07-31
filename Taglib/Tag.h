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
#endif

@interface Tag : NSObject {
    NSMutableDictionary * _properties;
#ifdef __cplusplus
    TagLib::FileRef * _fileRef;
#endif
}

@property(nonatomic, readonly) NSString * filename;

-(id) initWithFile: (NSString *) fileName;
-(NSString *) getFrame:(NSString *) frameId;
-(void)setFrame:(NSString *) frameId withValue:(NSString *) value;
-(NSString *)frameEncodingConversion:(NSString *)frameId;
-(void) writeTag;
@end
