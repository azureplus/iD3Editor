//
//  NSImage_NSData.m
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "NSImage_NSData.h"

static NSImage * nullImage;
static NSImage * placeholderImage;
static NSImage * multiplePlaceholderImage;

static NSImage * coverartYesImage;
static NSImage * coverartNoImage;

@implementation NSImage(NSData)
// NSImage to PNG data
-(NSData *)toData {
    NSData *imageData = [self TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSNumber *compressionFactor = [NSNumber numberWithFloat:0.9];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:compressionFactor forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
    return imageData;
}

+(NSImage *) nullImage {
    if (!nullImage) {
        nullImage = [[NSImage alloc] initWithSize:NSMakeSize(1, 1)];
        [nullImage setBackgroundColor:[NSColor clearColor]];
    }
    
    return nullImage;
}

+(NSImage *) nullPlaceholderImage {
    if (!placeholderImage) {
        placeholderImage = [NSImage imageNamed:@"placeholder.png"];
    }
    
    return placeholderImage;
}

+(NSImage *) multiplePlaceholderImage {
    if (!multiplePlaceholderImage) {
        multiplePlaceholderImage = [NSImage imageNamed:@"mic.png"];
    }
    
    return multiplePlaceholderImage;
}

+(NSImage *) coverartYesImage {
    if (!coverartYesImage) {
        coverartYesImage = [NSImage imageNamed:@"coverart_cell_yes.png"];
    }
    
    return coverartYesImage;
}

+(NSImage *) coverartNoImage {
    if (!coverartNoImage) {
        coverartNoImage = [NSImage imageNamed:@"coverart_cell_no.png"];
    }
    
    return coverartNoImage;
}

// hack : used by tag table view to sort by the presence of cover art
-(NSComparisonResult)compare:(NSImage *) image {
    if (self == [NSImage nullImage]) {
        if (!image || image == [NSImage nullImage]) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    } else {
        if (!image || image == [NSImage nullImage]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }
    
}


@end
