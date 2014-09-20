//
//  TagLibBase.m
//  iD3
//
//  Created by Qiang Yu on 9/14/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.


#import "TagBase.h"
#import "NSString_TLString.h"

#define DECL_GETTER(FRAME)\
-(NSString *) FRAME { \
    if (_##FRAME) { \
        return _##FRAME; \
    } else  { \
        return [NSString newStringFromTLString:_##FRAME##TL withEncoding:_charEncoding]; \
    } \
}

#define SAVE_FRAME(FRAME)\
if (_##FRAME) { \
    _##FRAME##TL = [_##FRAME toTLString]; \
} else if (_charEncoding) { \
    _##FRAME##TL = [[NSString newStringFromTLString:_##FRAME##TL withEncoding:_charEncoding] toTLString]; \
}

@implementation TagBase
-(id) initWithTag: (TagLib::Tag *) tag {
    if (self = [super init]) {
        _charEncoding = DEFAULT_ENCODING;
        
        self.artistTL = tag->artist();
        self.albumTL = tag->album();
        self.titleTL = tag->title();
        self.genreTL = tag->genre();
        self.commentTL = tag->comment();
    
        self.yearTL = tag->year();
        self.trackTL = tag->track();
        
        self.copyrightTL = TagLib::String::null;
        self.composerTL = TagLib::String::null;
    }

    return self;
}

-(NSNumber *) year {
    if (_year) {
        return _year;
    } else {
        return [NSNumber numberWithUnsignedInteger:_yearTL];
    }
}

-(NSNumber *) track {
    if (_track) {
        return _track;
    } else {
        return [NSNumber numberWithUnsignedInteger:_trackTL];
    }
}

DECL_GETTER(artist)
DECL_GETTER(album)
DECL_GETTER(title)
DECL_GETTER(genre)
DECL_GETTER(comment)
DECL_GETTER(copyright)
DECL_GETTER(composer)

-(BOOL)updated {
    return _charEncoding != DEFAULT_ENCODING ||
           _artist || _album || _title || _composer || _comment ||
           _genre || _copyright || _track || _year;
}

-(void)discardChanges {
    _artist = _album = _title = _composer = _comment = _genre = _copyright = nil;
    _track = _year = nil;
    _charEncoding = DEFAULT_ENCODING;
}

-(void) savedChanges {
    SAVE_FRAME(artist);
    SAVE_FRAME(album);
    SAVE_FRAME(title);
    SAVE_FRAME(composer);
    SAVE_FRAME(comment);
    SAVE_FRAME(genre);
    SAVE_FRAME(copyright);
    
    if (_year) {
        _yearTL = [_year unsignedIntegerValue];
    }
    
    if (_track) {
        _trackTL = [_track unsignedIntegerValue];
    }
    
    [self discardChanges];
}

-(NSString *) description {
    NSString * description = [NSString stringWithFormat:@"\tTitle: %@ \
                              \n\tArtist: %@ \
                              \n\tAlbum: %@ \
                              \n\tGenre: %@ \
                              \n\tYear: %@ \
                              \n\tTrack: %@ \
                              \n\tComposer: %@ \
                              \n\tComment: %@ \
                              \n\tCopyright: %@", self.title, self.artist, self.album,
                              self.genre, self.year, self.track, self.composer, self.comment, self.copyright];
    return description;
}
@end
