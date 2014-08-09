//
//  Tag_XIPHComment.m
//  iD3
//
//  Created by Qiang Yu on 8/8/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag_XIPHComment.h"
#import "taglib/tag.h"
#import "taglib/fileref.h"
#import "taglib/flacfile.h"
#import "taglib/xiphcomment.h"
#import "NSString_TLString.h"

@implementation Tag(XIPHComment)
-(void)setXIPHCOMMENTFrames:(NSDictionary *)frames {
    TagLib::FLAC::File * file = dynamic_cast<TagLib::FLAC::File *>(_fileRef->file());
    if (!file)  {
        return;
    }

    TagLib::Ogg::XiphComment * xiph = file->xiphComment(true);
    
    for (NSString * key in frames) {
        TagLib::String value = [frames[key] toTLString];
        xiph->addField([key toTLString], value, true);
    }
}
@end
