//
//  FileTags.m
//  iD3
//
//  Created by Qiang Yu on 3/18/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import "FileTags.h"
#import "TagConstants.h"

@interface FileTags()
@property (nonatomic, strong) NSString * fileName;
@property (nonatomic, assign) const TagLib::FileRef * fileRef;
@end

@implementation FileTags

-(id) initWithFileRef:(NSString *) fileName {
    if (self = [super init]) {
        self.fileName = fileName;
        self.fileRef = new TagLib::FileRef([fileName UTF8String]);
        self.tagFacades = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

-(void) dealloc {
    delete self.fileRef;
}
@end
