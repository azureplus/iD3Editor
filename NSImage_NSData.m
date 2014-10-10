//
//  NSImage_NSData.m
//  iD3
//
//  Created by Qiang Yu on 9/27/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "NSImage_NSData.h"

static NSImage * nullImage;

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
@end
