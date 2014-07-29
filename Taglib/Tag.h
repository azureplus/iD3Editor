//
//  Taglib.h
//  iD3
//
//  Created by Qiang Yu on 7/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject {
    NSMutableDictionary * _properties;
    NSString * _filename;
}

@property(nonatomic, readonly) NSString * filename;

-(id) initWithFile: (NSString *) fileName;
-(NSString *) getFrame:(NSString *) frameId;
@end
