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
-(NSDictionary *)resolveGetFrames {
    return [self resolveGetFramesWithEncoding:0xFFFFFFFF];
}

-(NSDictionary *)resolveGetFramesWithEncoding:(unsigned int)encoding {
    NSString * extension = [[self.filename pathExtension] uppercaseString];
    TagLib::FileRef fileRef = TagLib::FileRef([self.filename UTF8String]);
    
    if ([extension isEqualToString:@"APE"]) {
        TagLib::APE::File * file = dynamic_cast<TagLib::APE::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return @{};
        }
        
        TagLib::APE::Tag * tag = file->APETag(true);
        
        if (encoding == 0xFFFFFFFF) {
            return [self getAPEFramesWithTag:tag];
        } else {
            return [self getAPEFramesWithTag:tag andCharEncoding:encoding];
        }
        
    } else if ([extension isEqualToString:@"OGG"]) {
        TagLib::Ogg::Vorbis::File * file = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return @{};
        }
        
        TagLib::Ogg::XiphComment * tag = file->tag();
        
        if (encoding == 0xFFFFFFFF) {
            return [self getXIPHCOMMENTFramesWithTag:tag];
        } else {
            return [self getXIPHCOMMENTFramesWithTag:tag andCharEncoding:encoding];
        }
    } else if ([extension isEqualToString:@"FLAC"]) {
        TagLib::FLAC::File * file = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return @{};
        }
        
        TagLib::Ogg::XiphComment * tag = file->xiphComment(true);
        
        if (encoding == 0xFFFFFFFF) {
            return [self getXIPHCOMMENTFramesWithTag:tag];
        } else {
            return [self getXIPHCOMMENTFramesWithTag:tag andCharEncoding:encoding];
        }
    } else if ([extension isEqualToString:@"MP3"]) {
        TagLib::MPEG::File * file = dynamic_cast<TagLib::MPEG::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return @{};
        }
        
        TagLib::ID3v2::Tag * tag = file->ID3v2Tag(true);
        
        if (encoding == 0xFFFFFFFF) {
            return [self getID3V2FramesWithTag:tag];
        } else {
            return [self getID3V2FramesWithTag:tag andCharEncoding:encoding];
        }
    } else if ([extension isEqualToString:@"OGA"]) {
        TagLib::Ogg::Vorbis::File  * vorbis = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        TagLib::FLAC::File * flac = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        
        TagLib::Ogg::XiphComment * tag = nil;
        
        if (vorbis && vorbis->isValid()) {
            tag = vorbis->tag();
        } else if (flac && flac->isValid()) {
            tag = flac->xiphComment(true);
        }
        
        if (encoding == 0xFFFFFFFF) {
            return [self getXIPHCOMMENTFramesWithTag:tag];
        } else {
            return [self getXIPHCOMMENTFramesWithTag:tag andCharEncoding:encoding];
        }
    } else if ([extension isEqualToString:@"SPX"]) {
        TagLib::Ogg::Speex::File * file = dynamic_cast<TagLib::Ogg::Speex::File *>(fileRef.file());
        
        if (!file || !file->isValid()) {
            return @{};
        }
        
        TagLib::Ogg::XiphComment * tag = file->tag();
        
        if (encoding == 0xFFFFFFFF) {
            return [self getXIPHCOMMENTFramesWithTag:tag];
        } else {
            return [self getXIPHCOMMENTFramesWithTag:tag andCharEncoding:encoding];
        }
    } else if ([extension isEqualToString:@"WAV"]) {
        TagLib::RIFF::WAV::File * file = dynamic_cast<TagLib::RIFF::WAV::File *>(fileRef.file());
           
        if (!file || !file->isValid()) {
            return @{};
        }
        
        TagLib::ID3v2::Tag * tag = file->ID3v2Tag();
        
        if (encoding == 0xFFFFFFFF) {
            return [self getID3V2FramesWithTag:tag];
        } else {
            return [self getID3V2FramesWithTag:tag andCharEncoding:encoding];
        }
    }
    
    return @{};
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
        
        [self setXIPHCOMMENTFrames:frames withTag:file->xiphComment(true)];
        
    } else if ([extension isEqualToString:@"MP3"]) {
        TagLib::MPEG::File * file = dynamic_cast<TagLib::MPEG::File *>(fileRef.file());
        if (!file || !file->isValid()) {
            return;
        }
        
        [self setID3V2Frames:frames withTag:file->ID3v2Tag(true)];
    } else if ([extension isEqualToString:@"OGA"]) {
        TagLib::Ogg::Vorbis::File  * vorbis = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        TagLib::FLAC::File * flac = dynamic_cast<TagLib::FLAC::File *>(fileRef.file());
        
        if (vorbis && vorbis->isValid()) {
            [self setXIPHCOMMENTFrames:frames withTag:vorbis->tag()];
        } else if (flac && flac->isValid()) {
            [self setXIPHCOMMENTFrames:frames withTag:flac->xiphComment()];
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
        
        [self setID3V2Frames:frames withTag:file->ID3v2Tag()];
    }
    
    fileRef.save();
}
@end
