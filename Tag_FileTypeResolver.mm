//
//  Tag_FileTypeResolver.m
//  iD3
//
//  Created by Qiang Yu on 8/9/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag_FileTypeResolver.h"
#import "Tag_APE.h"
#import "Tag_ID3V1.h"
#import "Tag_ID3V2.h"
#import "Tag_XIPHComment.h"
#import "Tag_Info.h"
#import "taglib/fileref.h"
#import "taglib/apefile.h"
#import "taglib/flacfile.h"
#import "taglib/mpegfile.h"
#import "taglib/vorbisfile.h"
#import "taglib/speexfile.h"
#import "taglib/opusfile.h"
#import "taglib/wavfile.h"

#define GET_TAG_FRAMES(TAG, TYPE, ENCODING, DICT) \
    if (ENCODING == 0xFFFFFFFF) { \
        DICT = [self get##TYPE##FramesWithTag:TAG]; \
    } else {    \
        DICT = [self get##TYPE##FramesWithTag:TAG andCharEncoding:ENCODING]; \
    }


@implementation Tag(FileTypeResolver)
-(NSDictionary *)resolveGetFrames {
    return [self resolveGetFramesWithEncoding:0xFFFFFFFF];
}

-(void) _mergeDictionary:(NSMutableDictionary *)rv with:(NSDictionary *)dict {
    for (NSString * key in dict) {
        if ([dict[key] length]) {
            rv[key] = dict[key];
        }
    }
}

-(NSDictionary *)resolveGetFramesWithEncoding:(unsigned int)encoding {
    NSString * extension = [[self.filename pathExtension] uppercaseString];
    TagLib::FileRef fileRef = TagLib::FileRef([self.filename UTF8String]);
    
    NSMutableDictionary * rv = nil;
    
    if ([extension isEqualToString:@"APE"]) {
        TagLib::APE::File * file = dynamic_cast<TagLib::APE::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return @{};
        }
        
        NSDictionary * id3v1 = @{};
        if (file->hasID3v1Tag()) {
            TagLib::ID3v1::Tag * tag = file->ID3v1Tag();
            GET_TAG_FRAMES(tag, ID3V1, encoding, id3v1);
        }
        
        NSDictionary * ape = @{};
        if (file->hasAPETag()) {
            TagLib::APE::Tag * tag = file->APETag();
            GET_TAG_FRAMES(tag, APE, encoding, ape);
        }

        rv = [NSMutableDictionary dictionaryWithDictionary:ape];
        [self _mergeDictionary:rv with:id3v1];
        
        DEBUGLOG(@"-----------------------------");
        DEBUGLOG(@"APE tags: \n%@", ape);
        DEBUGLOG(@"ID3V1 tags: \n%@", id3v1);
    } else if ([extension isEqualToString:@"OGG"]) {
        TagLib::Ogg::Vorbis::File * file = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return @{};
        }
        
        TagLib::Ogg::XiphComment * tag = file->tag();
        NSDictionary * xiphComment = @{};
        GET_TAG_FRAMES(tag, XIPHCOMMENT, encoding, xiphComment);
        rv = [NSMutableDictionary dictionaryWithDictionary:xiphComment];
        
        DEBUGLOG(@"-----------------------------");
        DEBUGLOG(@"XIPHComment tags: \n%@", xiphComment);
    } else if ([extension isEqualToString:@"FLAC"]) {
        TagLib::FLAC::File * file = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return @{};
        }
        
        
        NSDictionary * id3v1 = @{};
        if (file->hasID3v1Tag()) {
            TagLib::ID3v1::Tag * tag = file->ID3v1Tag();
            GET_TAG_FRAMES(tag, ID3V1, encoding, id3v1);
        }
        
        NSDictionary * id3v2 = @{};
        if (file->hasID3v2Tag()) {
            TagLib::ID3v2::Tag * tag = file->ID3v2Tag();
            GET_TAG_FRAMES(tag, ID3V2, encoding, id3v2);
        }
        
        NSDictionary * xiphComment = @{};
        if (file->hasXiphComment()) {
            TagLib::Ogg::XiphComment * tag = file->xiphComment();
            GET_TAG_FRAMES(tag, XIPHCOMMENT, encoding, xiphComment);
        }
        
        rv = [NSMutableDictionary dictionaryWithDictionary:xiphComment];
        [self _mergeDictionary:rv with:id3v2];
        [self _mergeDictionary:rv with:id3v1];

        DEBUGLOG(@"-----------------------------");
        DEBUGLOG(@"XIPHComment tags: \n%@", xiphComment);
        DEBUGLOG(@"ID3V2 tags: \n%@", id3v2);
        DEBUGLOG(@"ID3V1 tags: \n%@", id3v1);
    } else if ([extension isEqualToString:@"MP3"]) {
        TagLib::MPEG::File * file = dynamic_cast<TagLib::MPEG::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return @{};
        }
        
        NSDictionary * id3v1 = @{};
        if (file->hasID3v1Tag()) {
            TagLib::ID3v1::Tag * tag = file->ID3v1Tag();
            GET_TAG_FRAMES(tag, ID3V1, encoding, id3v1);
        }
        
        NSDictionary * id3v2 = @{};
        if (file->hasID3v2Tag()) {
            TagLib::ID3v2::Tag * tag = file->ID3v2Tag();
            GET_TAG_FRAMES(tag, ID3V2, encoding, id3v2);
        }
        
        NSDictionary * ape = @{};
        if (file->hasAPETag()) {
            TagLib::APE::Tag * tag = file->APETag();
            GET_TAG_FRAMES(tag, APE, encoding, ape);
        }
        
        rv = [NSMutableDictionary dictionaryWithDictionary:ape];
        [self _mergeDictionary:rv with:id3v2];
        [self _mergeDictionary:rv with:id3v1];

        DEBUGLOG(@"-----------------------------");
        DEBUGLOG(@"APE tags: \n%@", ape);
        DEBUGLOG(@"ID3V2 tags: \n%@", id3v2);
        DEBUGLOG(@"ID3V1 tags: \n%@", id3v1);
    } else if ([extension isEqualToString:@"OGA"]) {
        TagLib::Ogg::Vorbis::File  * vorbis = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        TagLib::FLAC::File * flac = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        
        TagLib::Ogg::XiphComment * tag = nil;
        
        if (vorbis && vorbis->isValid()) {
            tag = vorbis->tag();
            NSDictionary * xiphComment = @{};
            GET_TAG_FRAMES(tag, XIPHCOMMENT, encoding, xiphComment);
            rv = [NSMutableDictionary dictionaryWithDictionary:xiphComment];
            DEBUGLOG(@"-----------------------------");
            DEBUGLOG(@"XIPHComment tags: \n%@", xiphComment);
        } else if (flac && flac->isValid()) {
            NSDictionary * id3v1 = @{};
            if (flac->hasID3v1Tag()) {
                TagLib::ID3v1::Tag * tag = flac->ID3v1Tag();
                GET_TAG_FRAMES(tag, ID3V1, encoding, id3v1);
            }
            
            NSDictionary * id3v2 = @{};
            if (flac->hasID3v2Tag()) {
                TagLib::ID3v2::Tag * tag = flac->ID3v2Tag();
                GET_TAG_FRAMES(tag, ID3V2, encoding, id3v2);
            }
            
            NSDictionary * xiphComment = @{};
            if (flac->hasXiphComment()) {
                TagLib::Ogg::XiphComment * tag = flac->xiphComment();
                GET_TAG_FRAMES(tag, XIPHCOMMENT, encoding, xiphComment);
            }
            
            rv = [NSMutableDictionary dictionaryWithDictionary:xiphComment];
            [self _mergeDictionary:rv with:id3v2];
            [self _mergeDictionary:rv with:id3v1];
            DEBUGLOG(@"-----------------------------");
            DEBUGLOG(@"XIPHComment tags: \n%@", xiphComment);
            DEBUGLOG(@"ID3V2 tags: \n%@", id3v2);
            DEBUGLOG(@"ID3V1 tags: \n%@", id3v1);
        }
    } else if ([extension isEqualToString:@"SPX"]) {
        TagLib::Ogg::Speex::File * file = dynamic_cast<TagLib::Ogg::Speex::File *>(fileRef.file());
        
        if (!file || !file->isValid()) {
            return @{};
        }
        
        TagLib::Ogg::XiphComment * tag = file->tag();
        NSDictionary * xiphComment = @{};
        GET_TAG_FRAMES(tag, XIPHCOMMENT, encoding, xiphComment);
        rv = [NSMutableDictionary dictionaryWithDictionary:xiphComment];
        DEBUGLOG(@"-----------------------------");
        DEBUGLOG(@"XIPHComment tags: \n%@", xiphComment);
    } else if ([extension isEqualToString:@"WAV"]) {
        TagLib::RIFF::WAV::File * file = dynamic_cast<TagLib::RIFF::WAV::File *>(fileRef.file());
           
        if (!file || !file->isValid()) {
            return @{};
        }
   
        NSDictionary * id3v2 = @{};
        if (file->hasID3v2Tag()) {
            TagLib::ID3v2::Tag * tag = file->ID3v2Tag();
            GET_TAG_FRAMES(tag, ID3V2, encoding, id3v2);
        }
        
        NSDictionary * info = @{};
        if (file->hasInfoTag()) {
            TagLib::RIFF::Info::Tag * tag = file->InfoTag();
            GET_TAG_FRAMES(tag, INFO, encoding, info);
        }
        
        rv = [NSMutableDictionary dictionaryWithDictionary:id3v2];
        [self _mergeDictionary:rv with:info];
        DEBUGLOG(@"-----------------------------");
        DEBUGLOG(@"InfoComment tags: \n%@", info);
        DEBUGLOG(@"ID3V2 tags: \n%@", id3v2);
    }
    
    return rv;
}

-(void)resolveSetFrames: (NSDictionary *) frames {
    NSString * extension = [[self.filename pathExtension] uppercaseString];
    TagLib::FileRef fileRef = TagLib::FileRef([self.filename UTF8String]);
    
    if ([extension isEqualToString:@"APE"]) {
        TagLib::APE::File * file = dynamic_cast<TagLib::APE::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return;
        }
        
        [self setAPEFrames:frames withTag:file->APETag(true)];
        
        if (file->hasID3v1Tag()) {
            [self setID3V1Frames:frames withTag:file->ID3v1Tag()];
        }
        
    } else if ([extension isEqualToString:@"OGG"]) {
        TagLib::Ogg::Vorbis::File * file = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return;
        }
        
        [self setXIPHCOMMENTFrames:frames withTag:file->tag()];
    } else if ([extension isEqualToString:@"FLAC"]) {
        TagLib::FLAC::File * file = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return;
        }
        
        BOOL written = NO;
        if (file->hasXiphComment()) {
            written = YES;
            [self setXIPHCOMMENTFrames:frames withTag:file->xiphComment()];
        }
        
        if (file->hasID3v2Tag()) {
            written = YES;
            [self setID3V2Frames:frames withTag:file->ID3v2Tag()];
        }
        
        if (!written) {
            [self setXIPHCOMMENTFrames:frames withTag:file->xiphComment(true)];
        }
        
        if (file->hasID3v1Tag()) {
            [self setID3V1Frames:frames withTag:file->ID3v1Tag()];
        }
    } else if ([extension isEqualToString:@"MP3"]) {
        TagLib::MPEG::File * file = dynamic_cast<TagLib::MPEG::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return;
        }
        
        BOOL written = NO;
        if (file->hasAPETag()) {
            written = YES;
            [self setAPEFrames:frames withTag:file->APETag()];
        }
        
        if (file->hasID3v2Tag()) {
            written = YES;
            [self setID3V2Frames:frames withTag:file->ID3v2Tag()];
        }
        
        if (!written) {
            [self setAPEFrames:frames withTag:file->APETag(true)];
        }
        
        if (file->hasID3v1Tag()) {
            [self setID3V1Frames:frames withTag:file->ID3v1Tag()];
        }
    } else if ([extension isEqualToString:@"OGA"]) {
        TagLib::Ogg::Vorbis::File  * vorbis = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        TagLib::FLAC::File * flac = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        
        if (vorbis && vorbis->isValid()) {
            [self setXIPHCOMMENTFrames:frames withTag:vorbis->tag()];
        } else if (flac && flac->isValid()) {
            BOOL written = NO;
            if (flac->hasXiphComment()) {
                written = YES;
                [self setXIPHCOMMENTFrames:frames withTag:flac->xiphComment()];
            }
            
            if (flac->hasID3v2Tag()) {
                written = YES;
                [self setID3V2Frames:frames withTag:flac->ID3v2Tag()];
            }
            
            if (!written) {
                [self setXIPHCOMMENTFrames:frames withTag:flac->xiphComment(true)];
            }
            
            if (flac->hasID3v1Tag()) {
                [self setID3V1Frames:frames withTag:flac->ID3v1Tag()];
            }
        }
    } else if ([extension isEqualToString:@"SPX"]) {
        TagLib::Ogg::Speex::File * file = dynamic_cast<TagLib::Ogg::Speex::File *>(fileRef.file());
        
        if (!file || !file->isValid()) {
            return;
        }
        [self setXIPHCOMMENTFrames:frames withTag:file->tag()];
    } else if ([extension isEqualToString:@"WAV"]) {
        TagLib::RIFF::WAV::File * file = dynamic_cast<TagLib::RIFF::WAV::File *>(fileRef.file());
        
        if (!file || !file->isValid()) {
            return;
        }
        
        BOOL written = NO;
        if (file->hasInfoTag()) {
            written = YES;
            [self setINFOFrames:frames withTag:file->InfoTag()];
        }
        
        if (file->hasID3v2Tag()) {
            written = YES;
            [self setID3V2Frames:frames withTag:file->ID3v2Tag()];
        }
    }
    
    fileRef.save();
}
@end
