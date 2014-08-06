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
    if (!value) {
        value = @"";
    }
    
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
-(NSString *) getFrame:(NSString *) frameId withEncoding:(unsigned int)encoding {
    TagLib::Tag * tag = _fileRef->file()->tag();
    NSString * rv = nil;
    if ([frameId isEqualTo:@"artist"]) {
        rv = [self _convertTLString: tag->artist() toEncoding:encoding];
    } else if ([frameId isEqualToString:@"album"]) {
        rv = [self _convertTLString: tag->album() toEncoding:encoding];
    } else if ([frameId isEqualToString:@"title"]) {
        rv = [self _convertTLString: tag->title() toEncoding:encoding];
    }else if ([frameId isEqualToString:@"comment"]) {
        rv = [self _convertTLString: tag->comment() toEncoding:encoding];
    } else if ([frameId isEqualToString:@"genre"]) {
        rv = [self _convertTLString: tag->genre() toEncoding:encoding];
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
