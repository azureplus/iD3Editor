//
//  Taglib.m
//  iD3
//
//  Created by Qiang Yu on 7/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag.h"
#import "taglib/tag.h"
#import "taglib/fileref.h"
#import "taglib/tpropertymap.h"
#import "NSString_TLString.h"

@implementation Tag

-(id) initWithFile: (NSString *) filename {
    if (self = [super init]) {
        _filename = filename;
        _fileRef = new TagLib::FileRef([_filename UTF8String]);
    }
    return self;
}

-(void)dealloc {
    delete _fileRef;
}

-(void) writeTag {
    _fileRef->save();
}

-(NSString *) getFrame:(NSString *) frameId {
    TagLib::String rv = [self _getFrame:frameId];
    return [NSString newStringFromTLString:rv];
}

-(TagLib::String) _getFrame:(NSString *)frameId {
    TagLib::PropertyMap  propertyMap = _fileRef->file()->properties();
    TagLib::PropertyMap::Iterator itor = propertyMap.find([frameId toTLString]);
    
    if (itor != propertyMap.end()) {
        TagLib::StringList stringList = itor->second;
        if (!stringList.isEmpty()) {
            return stringList.front();
        }
    }
    
    return "";
}

-(void)setFrame:(NSString *) frameId withValue:(NSString *) value {
    if (!value) {
        value = @"";
    }
    
    TagLib::String v = [value toTLString];
    TagLib::String fid = [frameId toTLString];

    TagLib::PropertyMap  propertyMap = _fileRef->file()->properties();
    TagLib::PropertyMap::Iterator itor = propertyMap.find(fid);
    
    if (itor != propertyMap.end()) {
        TagLib::StringList stringList = itor->second;
        stringList[0] = v;
    } else {
        propertyMap[fid] = TagLib::StringList();
        (propertyMap[fid])[0] = v;
    }
}

-(NSString *)_convertTLString: (const TagLib::String &) value toEncoding: (unsigned int) encoding{
    if (value.isAscii() || value.isLatin1()) {
        TagLib::ByteVector bv = value.data(TagLib::String::Type::Latin1);
        NSStringEncoding target = CFStringConvertEncodingToNSStringEncoding(encoding);
        NSString * result = [[NSString alloc] initWithData:[NSData dataWithBytes:bv.data() length:bv.size()] encoding:target];
        return result;
    } else {
        return nil;
    }
}

//
// returns nil if encoding conversion is not needed (e.g. the original encoding is already UTF)
//
-(NSString *) getFrame:(NSString *) frameId withCharEncoding:(unsigned int)encoding {
    TagLib::String rv = [self _getFrame:frameId];
    return [self _convertTLString:rv toEncoding:encoding];
}
@end
