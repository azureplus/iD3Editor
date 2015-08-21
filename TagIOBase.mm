//
//  TagIOBase.m
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "TagIOBase.h"
#import "NSString_TLString.h"
#import "TagBase.h"

@implementation TagIOBase
-(id<TagProtocol>) readTaglib:(TagLib::Tag *) taglib {
    return [[TagBase alloc] initWithTag:taglib];;
}

-(void) write:(id<TagProtocol>) tag toTaglib:(TagLib::Tag *) taglib {
    if (taglib == nil) {
        return;
    }
    
    taglib->setArtist([NSString TLStringFromString:tag.artist]);
    taglib->setAlbum([NSString TLStringFromString:tag.album]);
    taglib->setTitle([NSString TLStringFromString:tag.title]);
    taglib->setGenre([NSString TLStringFromString:tag.genre]);
    taglib->setComment([NSString TLStringFromString:tag.comment]);
    
    taglib->setYear([tag.year unsignedIntValue]);
    taglib->setTrack([tag.track unsignedIntValue]);
}

-(void)parseDiscInfo:(NSString *) discInfo toDiscNum:(NSUInteger *)discNum andDiscTotal:(NSUInteger *)discTotal {
    *discNum = 0;
    *discTotal = 0;
    NSArray * components = [discInfo componentsSeparatedByString:@"/"];
    if ([components count] == 1) {
        *discNum = [[self parseInt:components[0]] unsignedIntegerValue];
    } else if ([components count] >= 2) {
        *discNum = [[self parseInt:components[0]] unsignedIntegerValue];
        *discTotal = [[self parseInt:components[1]] unsignedIntegerValue];
    }
}

-(NSNumber *) parseInt:(NSString *) str {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    return [f numberFromString:str];
}
@end
