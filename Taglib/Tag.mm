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
        [self _readTag];
    }
    return self;
}

-(void)dealloc {
    delete _fileRef;
}

-(void) _readTag {
    _fileRef = new TagLib::FileRef([_filename UTF8String]);
    TagLib::Tag * tag = _fileRef->file()->tag();

    //
    TagLib::String value = tag->artist();
    [_properties setObject:[NSString newStringFromTLString: value] forKey:@"artist"];
    
    value = tag->album();
    [_properties setObject:[NSString newStringFromTLString: value] forKey:@"album"];
    
    value = tag->title();
    [_properties setObject:[NSString newStringFromTLString: value] forKey:@"title"];
    
    value = tag->comment();
    [_properties setObject:[NSString newStringFromTLString: value] forKey:@"comment"];
    
    value = tag->genre();
    [_properties setObject:[NSString newStringFromTLString: value] forKey:@"genre"];
    
    uint iValue = tag->year();
    [_properties setObject:[NSString stringWithFormat:@"%d", iValue] forKey:@"year"];
    
    iValue = tag->track();
    [_properties setObject:[NSString stringWithFormat:@"%d", iValue] forKey:@"track"];
}

-(void) writeTag {
    _fileRef->save();
}

-(NSString *) getFrame:(NSString *) frameId {
    return [_properties objectForKey:frameId];
}

//TODO: validate int value
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
