//
//  FileResolver.m
//  iD3
//
//  Created by Qiang Yu on 9/17/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
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
#import "taglib/rifffile.h"
#import "taglib/wavfile.h"
#import "taglib/aifffile.h"
#import "taglib/oggflacfile.h"
#import "taglib/mp4file.h"
#import "taglib/asffile.h"
#import "taglib/mpcfile.h"
#import "taglib/trueaudiofile.h"
#import "taglib/wavpackfile.h"

#import "taglib/tag.h"
#import "taglib/apetag.h"
#import "taglib/infotag.h"
#import "taglib/id3v1tag.h"
#import "taglib/id3v2tag.h"
#import "taglib/xiphcomment.h"
#import "taglib/mp4tag.h"
#import "taglib/asftag.h"

#import "TagIOApe.h"
#import "TagIOInfo.h"
#import "TagIOID3V1.h"
#import "TagIOID3V2.h"
#import "TagIOXIPH.h"
#import "TagIOMP4.h"
#import "TagIOASF.h"

#import "NSString_TLString.h"
#import "NSImage_NSData.h"

static TagIOApe * tagWriterApe;
static TagIOInfo * tagWriterInfo;
static TagIOID3V1 * tagWriterID3V1;
static TagIOID3V2 * tagWriterID3V2;
static TagIOXIPH * tagWriterXIPH;
static TagIOMP4 * tagWriterMP4;
static TagIOASF * tagWriterASF;

@implementation FileResolver

+(void) initialize {
    if (self == [FileResolver class]) {
        tagWriterApe = [[TagIOApe alloc] init];
        tagWriterInfo = [[TagIOInfo alloc] init];
        tagWriterID3V1 = [[TagIOID3V1 alloc] init];
        tagWriterID3V2 = [[TagIOID3V2 alloc] init];
        tagWriterXIPH = [[TagIOXIPH alloc] init];
        tagWriterMP4 = [[TagIOMP4 alloc] init];
        tagWriterASF = [[TagIOASF alloc] init];
    }
}

+(id<TagProtocol>) read:(NSString *)filename {
    TagLib::FileRef fileRef = TagLib::FileRef([filename UTF8String]);

    TagGroup * tagGroup = [[TagGroup alloc] init];
    
    if (TagLib::APE::File * file = dynamic_cast<TagLib::APE::File *>(fileRef.file())) {
        if (file->isValid()) {
            BOOL hasTag = NO;
            
            if (file->hasAPETag()) {
                hasTag = YES;
                TagLib::APE::Tag * tag = file->APETag();
                [tagGroup addTagLib:tag];
            }
        
            if (file->hasID3v1Tag()) {
                hasTag = YES;
                TagLib::ID3v1::Tag * tag = file->ID3v1Tag();
                [tagGroup addTagLib:tag];
            }
            
            if (!hasTag) {
                TagLib::APE::Tag tag;
                [tagGroup addTagLib:&tag];
            }
        } else {
            tagGroup.valid = NO;
        }
    } else if (TagLib::ASF::File * file = dynamic_cast<TagLib::ASF::File *>(fileRef.file())) {
        if (file->isValid()) {
            TagLib::ASF::Tag * tag = file->tag();
            [tagGroup addTagLib:tag];
        } else {
            tagGroup.valid = NO;
        }
    } else if (TagLib::FLAC::File * file = dynamic_cast<TagLib::FLAC::File *>(fileRef.file())){
        if (file->isValid()) {
            BOOL hasTag = NO;
            
            if (file->hasXiphComment()) {
                hasTag = YES;
                TagLib::Ogg::XiphComment * tag = file->xiphComment();
                TagBase * newTag = [tagGroup addTagLib:tag];                
                // flac picture
                [FileResolver _readFlacPictures:newTag from:file];
            }
            
            if (file->hasID3v2Tag()) {
                hasTag = YES;
                TagLib::ID3v2::Tag * tag = file->ID3v2Tag();
                [tagGroup addTagLib:tag];
            }

            if (file->hasID3v1Tag()) {
                hasTag = YES;
                TagLib::ID3v1::Tag * tag = file->ID3v1Tag();
                [tagGroup addTagLib:tag];
            }
            
            if (!hasTag) {
                TagLib::Ogg::XiphComment newTag;
                [tagGroup addTagLib:&newTag];
            }
        } else {
            tagGroup.valid = NO;
        }
    } else if (TagLib::MP4::File * file = dynamic_cast<TagLib::MP4::File *>(fileRef.file())) {
        if (file->isValid()) {
            [tagGroup addTagLib:file->tag()];
        } else {
            tagGroup.valid = NO;
        }
    } else if(TagLib::MPC::File * file = dynamic_cast<TagLib::MPC::File *>(fileRef.file())) {
        if (file->isValid()) {
            BOOL hasTag = NO;
            
            if (file->hasAPETag()) {
                hasTag = YES;
                TagLib::APE::Tag * tag = file->APETag();
                [tagGroup addTagLib:tag];
            }
            
            if (file->hasID3v1Tag()) {
                hasTag = YES;
                TagLib::ID3v1::Tag * tag = file->ID3v1Tag();
                [tagGroup addTagLib:tag];
            }
            
            if (!hasTag) {
                TagLib::APE::Tag tag;
                [tagGroup addTagLib:&tag];
            }
        } else {
            tagGroup.valid = NO;
        }
    }else if (TagLib::MPEG::File * file = dynamic_cast<TagLib::MPEG::File *>(fileRef.file())) {
        if (file->isValid()) {
            BOOL hasTag = NO;
            
            if (file->hasAPETag()) {
                hasTag = YES;
                TagLib::APE::Tag * tag = file->APETag();
                [tagGroup addTagLib:tag];
            }
         
            if (file->hasID3v2Tag()) {
                hasTag = YES;
                TagLib::ID3v2::Tag * tag = file->ID3v2Tag();
                [tagGroup addTagLib:tag];
            }            
         
            if (file->hasID3v1Tag()) {
                hasTag = YES;
                TagLib::ID3v1::Tag * tag = file->ID3v1Tag();
                [tagGroup addTagLib:tag];
            }
            
            if (!hasTag) {
                TagLib::ID3v2::Tag newTag;
                [tagGroup addTagLib:&newTag];
            }
        } else {
            tagGroup.valid = NO;
        }
    } else if (dynamic_cast<TagLib::Ogg::File*>(fileRef.file())) {
        TagLib::Ogg::FLAC::File * flac = dynamic_cast<TagLib::Ogg::FLAC::File *>(fileRef.file());
        TagLib::Ogg::Speex::File * speex = dynamic_cast<TagLib::Ogg::Speex::File *>(fileRef.file());
        TagLib::Ogg::Vorbis::File * vorbis = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        
        if (flac && flac->isValid()) {
            [tagGroup addTagLib:flac->tag()];
        } else if (speex && speex->isValid()) {
            [tagGroup addTagLib:speex->tag()];
        } else if (vorbis && vorbis->isValid()) { //vorbis
            [tagGroup addTagLib:vorbis->tag()];
        } else {
            tagGroup.valid = NO;
        }
    } else if (dynamic_cast<TagLib::RIFF::File *>(fileRef.file())) {
        TagLib::RIFF::AIFF::File* aiff = dynamic_cast<TagLib::RIFF::AIFF::File*>(fileRef.file());
        TagLib::RIFF::WAV::File * wav = dynamic_cast<TagLib::RIFF::WAV::File*>(fileRef.file());
        
        if (aiff && aiff->isValid()) {
            [tagGroup addTagLib:aiff->tag()];
        } else if (wav && wav->isValid()) {
            BOOL hasTag = NO;
            
            if (wav->hasInfoTag()) {
                hasTag = YES;
                [tagGroup addTagLib:wav->InfoTag()];
            }
            if (wav->hasID3v2Tag()) {
                hasTag = YES;
                [tagGroup addTagLib:wav->ID3v2Tag()];
            }
            
            if (!hasTag) {
                TagLib::ID3v2::Tag newTag;
                [tagGroup addTagLib:&newTag];
            }
        } else {
            tagGroup.valid = NO;
        }
    } else if (TagLib::TrueAudio::File * file = dynamic_cast<TagLib::TrueAudio::File *>(fileRef.file())) {
        if (file->isValid()) {
            BOOL hasTag = NO;
            
            if (file->hasID3v2Tag()) {
                hasTag = YES;
                [tagGroup addTagLib:file->ID3v2Tag()];
            }
            
            if (file->hasID3v1Tag()) {
                hasTag = YES;
                [tagGroup addTagLib:file->ID3v1Tag()];
            }
            
            if (!hasTag) {
                TagLib::ID3v2::Tag newTag;
                [tagGroup addTagLib:&newTag];
            }
        } else {
            tagGroup.valid = NO;
        }
    } else if (TagLib::WavPack::File * file = dynamic_cast<TagLib::WavPack::File *>(fileRef.file())) {
        if (file->isValid()) {
            BOOL hasTag = NO;
            
            if (file->hasAPETag()) {
                hasTag = YES;
                [tagGroup addTagLib:file->APETag()];
            }
            
            if (file->hasID3v1Tag()) {
                hasTag = YES;
                [tagGroup addTagLib:file->ID3v1Tag()];
            }

            if (!hasTag) {
                TagLib::APE::Tag tag;
                [tagGroup addTagLib:&tag];
            }            
        } else {
            tagGroup.valid = NO;
        }
    } else {
        tagGroup.valid = NO;
    }
    
    return tagGroup;
}

+(void) _readFlacPictures:(TagBase *)tag from:(TagLib::FLAC::File *)file {
    TagLib::List<TagLib::FLAC::Picture *> pictureList = file->pictureList();
    for (TagLib::List<TagLib::FLAC::Picture *>::Iterator it = pictureList.begin(); it != pictureList.end(); it++) {
        if((*it)->FrontCover == (*it)->type()) {
            const TagLib::ByteVector & bv = (*it)->data();
            NSData * picData = [NSData dataWithBytes:bv.data() length:bv.size()];
            NSImage * image = [[NSImage alloc] initWithData:picData];
            if (image) {
                [tag.pictureTL setObject:image forKey:@COVER_ART];
                break;
            }
        }
    }
}

+(void)writeTag:(id<TagProtocol>)tag to:(NSString *)filename {
    TagLib::FileRef fileRef = TagLib::FileRef([filename UTF8String]);
    
    if (TagLib::APE::File * file = dynamic_cast<TagLib::APE::File *>(fileRef.file())) {
        if (file->isValid()) {
            [tagWriterApe write:tag toTaglib:file->APETag(true)];
        
            if (file->hasID3v1Tag()) {
                [tagWriterID3V1 write:tag toTaglib:file->ID3v1Tag()];
            }
        }
    } else if (TagLib::ASF::File * file = dynamic_cast<TagLib::ASF::File *>(fileRef.file())) {
        if (file->isValid()) {
            TagLib::ASF::Tag * asfTag = file->tag();
            [tagWriterASF write:tag toTaglib:asfTag];
        }
    } else if (TagLib::FLAC::File * file = dynamic_cast<TagLib::FLAC::File *>(fileRef.file())) {
        if (file->isValid()) {
            BOOL written = NO;
            
            if (file->hasXiphComment()) {
                written = YES;
                [tagWriterXIPH write:tag toTaglib:file->xiphComment()];
                [FileResolver _writeFlacImage:[tag coverArt] to:file withType:TagLib::FLAC::Picture::Type::FrontCover];
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
    } else if (TagLib::MP4::File * file = dynamic_cast<TagLib::MP4::File *>(fileRef.file())) {
        if (file->isValid()) {
            [tagWriterMP4 write:tag toTaglib:file->tag()];
        }
    } else if (TagLib::MPC::File * file = dynamic_cast<TagLib::MPC::File *>(fileRef.file())) {
        if (file->isValid()) {
            [tagWriterApe write:tag toTaglib:file->APETag(true)];
            
            if (file->hasID3v1Tag()) {
                [tagWriterID3V1 write:tag toTaglib:file->ID3v1Tag()];
            }
        }
    } else if (TagLib::MPEG::File * file = dynamic_cast<TagLib::MPEG::File *>(fileRef.file())) {
        if (file->isValid()) {
            if (file->hasAPETag()) {
                [tagWriterApe write:tag toTaglib:file->APETag()];
            }
        
            [tagWriterID3V2 write:tag toTaglib:file->ID3v2Tag(true)];
            
            if (file->hasID3v1Tag()) {
                [tagWriterID3V1 write:tag toTaglib:file->ID3v1Tag()];
            }
        }
    } else if (dynamic_cast<TagLib::Ogg::File*>(fileRef.file())) {
        TagLib::Ogg::FLAC::File * flac = dynamic_cast<TagLib::Ogg::FLAC::File *>(fileRef.file());
        TagLib::Ogg::Speex::File * speex = dynamic_cast<TagLib::Ogg::Speex::File *>(fileRef.file());
        TagLib::Ogg::Vorbis::File * vorbis = dynamic_cast<TagLib::Ogg::Vorbis::File *>(fileRef.file());
        
        if (flac && flac->isValid()) {
            [tagWriterXIPH write:tag toTaglib:flac->tag()];
        } else if (speex && speex->isValid()) {
            [tagWriterXIPH write:tag toTaglib:speex->tag()];
        } else if (vorbis && vorbis->isValid()) {
            [tagWriterXIPH write:tag toTaglib:vorbis->tag()];
        }
    } else if (dynamic_cast<TagLib::RIFF::File *>(fileRef.file())) {
        TagLib::RIFF::AIFF::File* aiff = dynamic_cast<TagLib::RIFF::AIFF::File*>(fileRef.file());
        TagLib::RIFF::WAV::File * wav = dynamic_cast<TagLib::RIFF::WAV::File*>(fileRef.file());
        
        if (aiff && aiff->isValid()) {
            [tagWriterID3V2 write:tag toTaglib:aiff->tag()];
        } else if (wav && wav->isValid()) {
            [tagWriterID3V2 write:tag toTaglib:wav->ID3v2Tag()];
            [tagWriterInfo write:tag toTaglib:wav->InfoTag()];
        }
    } else if (TagLib::TrueAudio::File * file = dynamic_cast<TagLib::TrueAudio::File *>(fileRef.file())) {
        if (file->isValid()) {
            [tagWriterID3V2 write:tag toTaglib:file->ID3v2Tag(true)];
            
            if (file->hasID3v1Tag()) {
                [tagWriterID3V1 write:tag toTaglib:file->ID3v1Tag()];
            }
        }
    } else if (TagLib::WavPack::File * file = dynamic_cast<TagLib::WavPack::File *>(fileRef.file())) {
        if (file->isValid()) {
            [tagWriterApe write:tag toTaglib:file->APETag(true)];
            
            if (file->hasID3v1Tag()) {
                [tagWriterID3V1 write:tag toTaglib:file->ID3v1Tag()];
            }
        }
    }
    
    fileRef.save();
}

+(void) _writeFlacImage:(NSImage *)image to:(TagLib::FLAC::File *)file withType:(TagLib::FLAC::Picture::Type) type {
    if (!image) {
        return;
    }

    TagLib::FLAC::Picture * picture = NULL;
    TagLib::List<TagLib::FLAC::Picture *> pictureList = file->pictureList();
    for (TagLib::List<TagLib::FLAC::Picture *>::Iterator it = pictureList.begin(); it != pictureList.end(); it++) {
        if(type == (*it)->type()) {
            picture = *it;
            break;
        }
    }
    
    if (image == [NSImage nullImage]) {
        if (picture) {
            file->removePicture(picture);
        }
        return;
    }
        
    BOOL found = true;
    
    if (!picture) {
        picture = new TagLib::FLAC::Picture();
        found = false;
    }
    
    NSData * picData = [image toData];
    TagLib::ByteVector bv((const char *)[picData bytes], (uint)[picData length]);
        
    picture->setType(TagLib::FLAC::Picture::Type::FrontCover);
    picture->setMimeType("image/jpeg");
    picture->setData(bv);
    
    if (!found) {
        file->addPicture(picture);
    }
}
@end
