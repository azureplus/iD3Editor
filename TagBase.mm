//
//  TagLibBase.m
//  iD3
//
//  Created by Qiang Yu on 9/14/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.


#import "TagBase.h"
#import "NSString_TLString.h"
#import "NSImage_NSData.h"

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
    _##FRAME##TL = [NSString TLStringFromString:_##FRAME]; \
} else if (_charEncoding) { \
    NSString * v = [NSString newStringFromTLString:_##FRAME##TL withEncoding:_charEncoding]; \
    _##FRAME##TL = [NSString TLStringFromString:v]; \
}

@implementation TagBase
// copy basic tags from TagLib::Tag
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
        self.albumArtistTL = TagLib::String::null;
        self.discNumTL = 0;
        self.discTotalTL = 0;
        
        _picture = [NSMutableDictionary dictionaryWithCapacity:2];
        _pictureTL = [NSMutableDictionary dictionaryWithCapacity:2];        
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

-(NSNumber *)discTotal {
    if (_discTotal) {
        return _discTotal;
    } else {
        return [NSNumber numberWithUnsignedInteger:_discTotalTL];
    }
}

-(NSNumber *)discNum {
    if (_discNum) {
        return _discNum;
    } else {
        return [NSNumber numberWithUnsignedInteger:_discNumTL];
    }
}

-(NSImage *)coverArt {
    NSImage * pic = self.picture[@COVER_ART];
    if (!pic) {
        pic = self.pictureTL[@COVER_ART];
    }
    return pic;
}

DECL_GETTER(artist)
DECL_GETTER(album)
DECL_GETTER(albumArtist);
DECL_GETTER(title)
DECL_GETTER(genre)
DECL_GETTER(comment)
DECL_GETTER(copyright)
DECL_GETTER(composer)

-(BOOL)updated {
    return _charEncoding != DEFAULT_ENCODING ||
           _artist || _album || _title || _composer || _comment || _albumArtist ||
           _genre || _copyright || _track || _year || _discNum || _discTotal || ([_picture count] != 0);
}

-(void)discardChanges {
    _artist = _album = _albumArtist = _title = _composer = _comment = _genre = _copyright = nil;
    _track = _year = nil;
    _discNum = _discTotal = nil;
    _charEncoding = DEFAULT_ENCODING;
    
    [_picture removeAllObjects];
}

// called after changes have been written
-(void) savedChanges {
    SAVE_FRAME(artist);
    SAVE_FRAME(album);
    SAVE_FRAME(albumArtist);
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
    
    if (_discTotal) {
        _discTotalTL = [_discTotal unsignedIntegerValue];
    }
    
    if (_discNum) {
        _discNumTL = [_discNum unsignedIntegerValue];
    }
    
    [_pictureTL addEntriesFromDictionary:_picture];
    [self discardChanges];
}

-(void)setCoverArt:(NSImage *)coverArt {
    if (coverArt) {
        [_picture setObject:coverArt forKey:@COVER_ART];
    }
}

-(NSString *) description {
    NSString * description = [NSString stringWithFormat:@"\tTitle: %@ \
                              \n\tArtist: %@ \
                              \n\tAlbumArtist: %@ \
                              \n\tAlbum: %@ \
                              \n\tGenre: %@ \
                              \n\tYear: %@ \
                              \n\tTrack: %@ \
                              \n\tComposer: %@ \
                              \n\tComment: %@ \
                              \n\tCopyright: %@\
                              \n\tDiscNum: %@\
                              \n\tDiscTotal: %@", self.title, self.artist, self.albumArtist, self.album,
                              self.genre, self.year, self.track, self.composer, self.comment, self.copyright, self.discNum, self.discTotal];
    return description;
}
@end
