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
#import "NSString_TLString.h"

@implementation Tag

-(id) initWithFile: (NSString *) filename {
    if (self = [super init]) {
        _filename = filename;
        _properties = [NSMutableDictionary dictionaryWithCapacity: 7];
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
    TagLib::Tag * tag = _fileRef->file()->tag();
    NSString * rv = @"";
    if ([frameId isEqualTo:@"artist"]) {
        rv = [NSString newStringFromTLString: tag->artist()];
    } else if ([frameId isEqualTo:@"album"]) {
        rv = [NSString newStringFromTLString: tag->album()];
    } else if ([frameId isEqualTo:@"title"]) {
        rv = [NSString newStringFromTLString: tag->title()];
    } else if ([frameId isEqualTo:@"comment"]) {
        rv = [NSString newStringFromTLString: tag->comment()];
    } else if ([frameId isEqualTo:@"genre"]) {
        rv = [NSString newStringFromTLString: tag->genre()];
    } else if ([frameId isEqualTo:@"year"]) {
        rv = [NSString stringWithFormat:@"%d", tag->year()];
    } else if ([frameId isEqualTo:@"track"]) {
        rv = [NSString stringWithFormat:@"%d", tag->track()];
    }
    
    return rv;
}

-(void)setFrame:(NSString *) frameId withValue:(NSString *) value {
    TagLib::Tag * tag = _fileRef->file()->tag();
    TagLib::String v = [value toTLString];
    
    if ([frameId isEqualTo:@"artist"]) {
        tag->setArtist(v);
    } else if ([frameId isEqualTo:@"album"]) {
        tag->setAlbum(v);
    } else if ([frameId isEqualTo:@"title"]) {
        tag->setTitle(v);
    } else if ([frameId isEqualTo:@"comment"]) {
        tag->setComment(v);
    } else if ([frameId isEqualTo:@"genre"]) {
        tag->setGenre(v);
    } else if ([frameId isEqualTo:@"year"]) {
        tag->setYear([value intValue]);
    } else if ([frameId isEqualTo:@"track"]) {
        tag->setTrack([value intValue]);
    }
}

-(NSString *)_frameEncodingConversionHelp: (const TagLib::String &) value{
    if (value.isAscii() || value.isLatin1()) {
        TagLib::ByteVector bv = value.data(TagLib::String::Type::Latin1);
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        return [[NSString alloc] initWithData:[NSData dataWithBytes:bv.data() length:bv.size()] encoding:gbkEncoding];
    } else {
        return nil;
    }
}

-(NSString *)frameEncodingConversion:(NSString *)frameId {
    TagLib::Tag * tag = _fileRef->file()->tag();
    NSString  * rv = nil;
    if ([frameId isEqualTo:@"artist"]) {
        rv = [self _frameEncodingConversionHelp: tag->artist()];
    } else if ([frameId isEqualToString:@"album"]) {
        rv = [self _frameEncodingConversionHelp: tag->album()];
    } else if ([frameId isEqualToString:@"title"]) {
        rv = [self _frameEncodingConversionHelp: tag->title()];
    }else if ([frameId isEqualToString:@"comment"]) {
        rv = [self _frameEncodingConversionHelp: tag->comment()];
    } else if ([frameId isEqualToString:@"genre"]) {
        rv = [self _frameEncodingConversionHelp: tag->genre()];
    }
    
    return rv;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"\n\tartist: %@\n\talbum: %@\n\ttitle: %@\n\tcomment: %@\n\tgenre: %@\n\tyear: %@\n\ttrack: %@",
            [_properties valueForKey:@"artist"],
            [_properties valueForKey:@"album"],
            [_properties valueForKey:@"title"],
            [_properties valueForKey:@"comment"],
            [_properties valueForKey:@"genre"],
            [_properties valueForKey:@"year"],
            [_properties valueForKey:@"track"]];
}
@end
