//
//  Tag_APE.m
//  iD3
//
//  Created by Qiang Yu on 8/8/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//


#import "Tag_APE.h"
#import "taglib/tag.h"
#import "taglib/fileref.h"
#import "taglib/apefile.h"
#import "taglib/apetag.h"
#import "NSString_TLString.h"

@implementation Tag(APE)
-(void)setAPEFrames:(NSDictionary *)frames {
    TagLib::APE::File * file = dynamic_cast<TagLib::APE::File *>(_fileRef->file());
    if (!file)  {
        return;
    }
    
    TagLib::APE::Tag * apeTag = nil;
    apeTag = file->APETag(true);
    
    for (NSString * key in frames) {
        TagLib::String value = [frames[key] toTLString];
        apeTag->addValue([key toTLString], value, true);
    }
}
@end
