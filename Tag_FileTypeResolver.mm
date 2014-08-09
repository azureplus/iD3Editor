//
//  Tag_FileTypeResolver.m
//  iD3
//
//  Created by Qiang Yu on 8/9/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "Tag_FileTypeResolver.h"
#import "Tag_APE.h"
#import "Tag_ID3V2.h"
#import "Tag_XIPHComment.h"
#import "taglib/fileref.h"
#import "taglib/apefile.h"
#import "taglib/flacfile.h"
#import "taglib/mpegfile.h"
#import "taglib/vorbisfile.h"
#import "taglib/speexfile.h"
#import "taglib/opusfile.h"
#import "taglib/wavfile.h"

@implementation Tag(FileTypeResolver)
-(void)resolveSetFrames: (NSDictionary *) frames {
    NSString * extension = [[self.filename pathExtension] uppercaseString];
    
    if ([extension isEqualToString:@"APE"]) {
        TagLib::APE::File * file = dynamic_cast<TagLib::APE::File *>(_fileRef->file());
        if (!file || !file->isValid()) {
            return;
        }
        
        [self setAPEFrames:frames withTag:file->APETag()];
    } else if ([extension isEqualToString:@"OGG"]) {
        TagLib::Ogg::Vorbis::File * file = dynamic_cast<TagLib::Ogg::Vorbis::File *>(_fileRef->file());
        if (!file || !file->isValid()) {
            return;
        }
        
        [self setXIPHCOMMENTFrames:frames withTag:file->tag()];
    } else if ([extension isEqualToString:@"FLAC"]) {
        TagLib::FLAC::File * file = dynamic_cast<TagLib::FLAC::File *>(_fileRef->file());
        if (!file || !file->isValid()) {
            return;
        }
        
        [self setXIPHCOMMENTFrames:frames withTag:file->xiphComment()];
        
    } else if ([extension isEqualToString:@"MP3"]) {
        TagLib::MPEG::File * file = dynamic_cast<TagLib::MPEG::File *>(_fileRef->file());
        if (!file || !file->isValid()) {
            return;
        }
        
        [self setID3V2Frames:frames withTag:file->ID3v2Tag()];
    } else if ([extension isEqualToString:@"OGA"]) {
        TagLib::Ogg::Vorbis::File  * vorbis = dynamic_cast<TagLib::Ogg::Vorbis::File *>(_fileRef->file());
        TagLib::FLAC::File * flac = dynamic_cast<TagLib::FLAC::File *>(_fileRef->file());
        
        if (vorbis && vorbis->isValid()) {
            [self setXIPHCOMMENTFrames:frames withTag:vorbis->tag()];
        } else if (flac && flac->isValid()) {
            [self setXIPHCOMMENTFrames:frames withTag:flac->xiphComment()];
        }
    } else if ([extension isEqualToString:@"SPX"]) {
        TagLib::Ogg::Speex::File * file = dynamic_cast<TagLib::Ogg::Speex::File *>(_fileRef->file());
        
        if (!file || !file->isValid()) {
            return;
        }
        
        [self setXIPHCOMMENTFrames:frames withTag:file->tag()];
    } /*else if ([extension isEqualToString:@"OPUS"]) {
        TagLib::Ogg::Opus::File * file = dynamic_cast<TagLib::Ogg::Opus::File *>(_fileRef->file());
        
        if (!file || !file->isValid()) {
            return;
        }
        
        [self setXIPHCOMMENTFrames:frames withTag:file->tag()];
    } */else if ([extension isEqualToString:@"WAV"]) {
        TagLib::RIFF::WAV::File * file = dynamic_cast<TagLib::RIFF::WAV::File *>(_fileRef->file());
        
        if (!file || !file->isValid()) {
            return;
        }
        
        [self setID3V2Frames:frames withTag:file->ID3v2Tag()];
    }
}
@end
