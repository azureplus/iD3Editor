//
//  FileResolver.m
//  iD3
//
//  Created by Qiang Yu on 9/17/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "FileResolver.h"
#import "TagGroup.h"

#import "taglib/fileref.h"
#import "taglib/apefile.h"
#import "taglib/flacfile.h"
#import "taglib/mpegfile.h"
#import "taglib/vorbisfile.h"
#import "taglib/speexfile.h"
#import "taglib/opusfile.h"
#import "taglib/wavfile.h"

#import "taglib/tag.h"
#import "taglib/apetag.h"
#import "taglib/infotag.h"
#import "taglib/id3v1tag.h"
#import "taglib/id3v2tag.h"
#import "taglib/xiphcomment.h"

#import "TagWriterApe.h"
#import "TagWriterInfo.h"
#import "TagWriterID3V1.h"
#import "TagWriterID3V2.h"
#import "TagWriterXIPH.h"

static TagWriterApe * tagWriterApe;
static TagWriterInfo * tagWriterInfo;
static TagWriterID3V1 * tagWriterID3V1;
static TagWriterID3V2 * tagWriterID3V2;
static TagWriterXIPH * tagWriterXIPH;

@implementation FileResolver

+(void) initialize {
    if (self == [FileResolver class]) {
        tagWriterApe = [[TagWriterApe alloc] init];
        tagWriterInfo = [[TagWriterInfo alloc] init];
        tagWriterID3V1 = [[TagWriterID3V1 alloc] init];
        tagWriterID3V2 = [[TagWriterID3V2 alloc] init];
        tagWriterXIPH = [[TagWriterXIPH alloc] init];
    }
}

+(id<TagProtocol>) read:(NSString *)filename {
    NSString * extension = [[filename pathExtension] uppercaseString];
    TagLib::FileRef fileRef = TagLib::FileRef([filename UTF8String]);

    TagGroup * tagGroup = [[TagGroup alloc] init];
    
    if ([extension isEqualToString:@"APE"]) {
        TagLib::APE::File * file = dynamic_cast<TagLib::APE::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            if (file->hasAPETag()) {
                TagLib::APE::Tag * tag = file->APETag();
                [tagGroup addTagLib:tag];
            }
        
            if (file->hasID3v1Tag()) {
                TagLib::ID3v1::Tag * tag = file->ID3v1Tag();
                [tagGroup addTagLib:tag];
            }
        }
    } else if ([extension isEqualToString:@"OGG"]) {
        TagLib::Ogg::Vorbis::File * file = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            TagLib::Ogg::XiphComment * tag = file->tag();
            [tagGroup addTagLib:tag];
        }
    } else if ([extension isEqualToString:@"FLAC"]) {
        TagLib::FLAC::File * file = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            if (file->hasXiphComment()) {
                TagLib::Ogg::XiphComment * tag = file->xiphComment();
                [tagGroup addTagLib:tag];
            }
            
            if (file->hasID3v2Tag()) {
                TagLib::ID3v2::Tag * tag = file->ID3v2Tag();
                [tagGroup addTagLib:tag];
            }

            if (file->hasID3v1Tag()) {
                TagLib::ID3v1::Tag * tag = file->ID3v1Tag();
                [tagGroup addTagLib:tag];
            }
        }
    } else if ([extension isEqualToString:@"MP3"]) {
        TagLib::MPEG::File * file = dynamic_cast<TagLib::MPEG::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            if (file->hasAPETag()) {
                TagLib::APE::Tag * tag = file->APETag();
                [tagGroup addTagLib:tag];
            }
        
            if (file->hasID3v2Tag()) {
                TagLib::ID3v2::Tag * tag = file->ID3v2Tag();
                [tagGroup addTagLib:tag];
            }

            if (file->hasID3v1Tag()) {
                TagLib::ID3v1::Tag * tag = file->ID3v1Tag();
                [tagGroup addTagLib:tag];
            }
        }
    } else if ([extension isEqualToString:@"OGA"]) {
        TagLib::Ogg::Vorbis::File  * vorbis = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        TagLib::FLAC::File * flac = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        
        TagLib::Ogg::XiphComment * tag = nil;
        
        if (vorbis && vorbis->isValid()) {
            tag = vorbis->tag();
            [tagGroup addTagLib:tag];
        } else if (flac && flac->isValid()) {
            if (flac->hasXiphComment()) {
                TagLib::Ogg::XiphComment * tag = flac->xiphComment();
                [tagGroup addTagLib:tag];
            }

            if (flac->hasID3v2Tag()) {
                TagLib::ID3v2::Tag * tag = flac->ID3v2Tag();
                [tagGroup addTagLib:tag];
            }
            
            if (flac->hasID3v1Tag()) {
                TagLib::ID3v1::Tag * tag = flac->ID3v1Tag();
                [tagGroup addTagLib:tag];
            }
        }
    } else if ([extension isEqualToString:@"SPX"]) {
        TagLib::Ogg::Speex::File * file = dynamic_cast<TagLib::Ogg::Speex::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            TagLib::Ogg::XiphComment * tag = file->tag();
            [tagGroup addTagLib:tag];
        }
    } else if ([extension isEqualToString:@"WAV"]) {
        TagLib::RIFF::WAV::File * file = dynamic_cast<TagLib::RIFF::WAV::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            if (file->hasInfoTag()) {
                TagLib::RIFF::Info::Tag * tag = file->InfoTag();
                [tagGroup addTagLib:tag];
            }

            if (file->hasID3v2Tag()) {
                TagLib::ID3v2::Tag * tag = file->ID3v2Tag();
                [tagGroup addTagLib:tag];
            }
        }
    }
    
    return tagGroup;
}

+(void)writeTag:(id<TagProtocol>)tag to:(NSString *)filename {
    NSString * extension = [[filename pathExtension] uppercaseString];
    TagLib::FileRef fileRef = TagLib::FileRef([filename UTF8String]);
    
    if ([extension isEqualToString:@"APE"]) {
        TagLib::APE::File * file = dynamic_cast<TagLib::APE::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            [tagWriterApe write:tag toTaglib:file->APETag(true)];
        
            if (file->hasID3v1Tag()) {
                [tagWriterID3V1 write:tag toTaglib:file->ID3v1Tag()];
            }
        }
    } else if ([extension isEqualToString:@"OGG"]) {
        TagLib::Ogg::Vorbis::File * file = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            [tagWriterXIPH write:tag toTaglib:file->tag()];
        }
    } else if ([extension isEqualToString:@"FLAC"]) {
        TagLib::FLAC::File * file = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            BOOL written = NO;
            
            if (file->hasXiphComment()) {
                written = YES;
                [tagWriterXIPH write:tag toTaglib:file->xiphComment()];
            }
        
            if (file->hasID3v2Tag()) {
                written = YES;
                [tagWriterID3V2 write:tag toTaglib:file->ID3v2Tag()];
            }
        
            if (!written) {
                [tagWriterXIPH write:tag toTaglib:file->xiphComment(true)];
            }
        
            if (file->hasID3v1Tag()) {
                [tagWriterID3V1 write:tag toTaglib:file->ID3v1Tag()];
            }
        }
    } else if ([extension isEqualToString:@"MP3"]) {
        TagLib::MPEG::File * file = dynamic_cast<TagLib::MPEG::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            if (file->hasAPETag()) {
                [tagWriterApe write:tag toTaglib:file->APETag()];
            }
        
            [tagWriterID3V2 write:tag toTaglib:file->ID3v2Tag(true)];
            
            if (file->hasID3v1Tag()) {
                [tagWriterID3V1 write:tag toTaglib:file->ID3v1Tag()];
            }
    }
    } else if ([extension isEqualToString:@"OGA"]) {
        TagLib::Ogg::Vorbis::File  * vorbis = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        TagLib::FLAC::File * flac = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        
        if (vorbis && vorbis->isValid()) {
            [tagWriterXIPH write:tag toTaglib:vorbis->tag()];
        } else if (flac && flac->isValid()) {
            BOOL written = NO;
            if (flac->hasXiphComment()) {
                written = YES;
                [tagWriterXIPH write:tag toTaglib:flac->xiphComment()];
            }
            
            if (flac->hasID3v2Tag()) {
                written = YES;
                [tagWriterID3V2 write:tag toTaglib:flac->ID3v2Tag()];
            }
            
            if (!written) {
                [tagWriterXIPH write:tag toTaglib:flac->xiphComment(true)];
            }
            
            if (flac->hasID3v1Tag()) {
                [tagWriterID3V1 write:tag toTaglib:flac->ID3v1Tag()];
            }
        }
    } else if ([extension isEqualToString:@"SPX"]) {
        TagLib::Ogg::Speex::File * file = dynamic_cast<TagLib::Ogg::Speex::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            return;
        }
        
        [tagWriterXIPH write:tag toTaglib:file->tag()];
    } else if ([extension isEqualToString:@"WAV"]) {
        TagLib::RIFF::WAV::File * file = dynamic_cast<TagLib::RIFF::WAV::File *>(fileRef.file());
        
        if (file && file->isValid()) {
            return;
        }
        
        [tagWriterID3V2 write:tag toTaglib:file->ID3v2Tag()];
        [tagWriterInfo write:tag toTaglib:file->InfoTag()];
    }
    
    fileRef.save();
}
@end
