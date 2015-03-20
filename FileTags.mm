//
//  FileTags.m
//  iD3
//
//  Created by Qiang Yu on 3/18/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import "FileTags.h"
#import "TagConstants.h"
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

#import "ID3V2Facade.h"

@interface FileTags()
@property (nonatomic, strong) NSString * fileName;
@property (nonatomic, assign) const TagLib::FileRef * fileRef;
@end

@implementation FileTags

-(id) initWithFile:(NSString *) fileName {
    if (self = [super init]) {
        self.fileName = fileName;
        self.fileRef = new TagLib::FileRef([fileName UTF8String]);
        self.tagFacades = [NSMutableArray arrayWithCapacity:3];
        [self parse];
    }
    return self;
}

-(void) dealloc {
    delete self.fileRef;
}

-(void) parse {
    if (dynamic_cast<TagLib::APE::File *>(self.fileRef->file())) {
        [self parseAPE];
    } else if (dynamic_cast<TagLib::ASF::File *>(self.fileRef->file())) {
        [self parseASF];
    } else if (dynamic_cast<TagLib::FLAC::File *>(self.fileRef->file())){
        [self parseFLAC];
    } else if (dynamic_cast<TagLib::MP4::File *>(self.fileRef->file())) {
        [self parseMP4];
    } else if(dynamic_cast<TagLib::MPC::File *>(self.fileRef->file())) {
        [self parseMPC];
    }else if (dynamic_cast<TagLib::MPEG::File *>(self.fileRef->file())) {
        [self parseMPEG];
    } else if (dynamic_cast<TagLib::Ogg::File*>(self.fileRef->file())) {
        [self parseOGG];
    } else if (dynamic_cast<TagLib::RIFF::File *>(self.fileRef->file())) {
        [self parseRIFF];
    } else if (dynamic_cast<TagLib::TrueAudio::File *>(self.fileRef->file())) {
        [self parseTrueAudio];
    } else if (dynamic_cast<TagLib::WavPack::File *>(self.fileRef->file())) {
        [self parseWavPak];
    }
}


-(void) parseAPE {
    
}

-(void) parseASF {
    
}

-(void) parseFLAC {
    
}

-(void) parseMP4 {
    
}

-(void) parseMPC {
    
}

-(void) parseMPEG {
    TagLib::MPEG::File * file = dynamic_cast<TagLib::MPEG::File *>(self.fileRef->file());
    
    if (file->isValid()) {
        if (file->hasAPETag()) {
        }
        
        if (file->hasID3v2Tag()) {
            ID3V2Facade * tag = [[ID3V2Facade alloc] initWithTag:file->ID3v2Tag()];
            [self.tagFacades addObject:tag];
        }
        
        if (file->hasID3v1Tag()) {
        }
        
        if (!self.tagFacades.count) {  // no tag yet
        }
    }
}

-(void) parseOGG {
    
}

-(void) parseRIFF {
    
}

-(void) parseTrueAudio {
    
}

-(void) parseWavPak {
    
}
@end
