//
//  PictureView.m
//  iD3
//
//  Created by Qiang Yu on 10/7/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "PictureView.h"

@implementation PictureView
-(NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender {
    DEBUGLOG(@"dragging entered");
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
        //this means that the sender is offering the type of operation we want
        //return that we want the NSDragOperationGeneric operation that they
        //are offering
        return NSDragOperationGeneric;
    } else {
        //since they aren't offering the type of operation we want, we have
        //to tell them we aren't interested
        return NSDragOperationNone;
    }
}

-(void) draggingExited:(id<NSDraggingInfo>)sender {
    DEBUGLOG(@"dragging exited");
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *paste = [sender draggingPasteboard];
    
    NSArray *types = [NSArray arrayWithObjects:NSTIFFPboardType,
                      NSFilenamesPboardType, nil];

    NSString *desiredType = [paste availableTypeFromArray:types];
    NSData *carriedData = [paste dataForType:desiredType];
    
    if (nil == carriedData) {
        NSRunAlertPanel(@"Paste Error", @"Sorry, but the past operation failed",
                        nil, nil, nil);
        return NO;
    } else {
        if ([desiredType isEqualToString:NSTIFFPboardType]) {
            NSImage *newImage = [[NSImage alloc] initWithData:carriedData];
            [self setImage:newImage];
        } else if ([desiredType isEqualToString:NSFilenamesPboardType]) {
            NSArray *fileArray = [paste propertyListForType:@"NSFilenamesPboardType"];
            NSString *path = [fileArray objectAtIndex:0];
            NSImage *newImage = [[NSImage alloc] initWithContentsOfFile:path];
            if (nil == newImage) {
                return NO;
            } else {
                [self setImage:newImage];
            }
        }
    }
    [self setNeedsDisplay:YES];    //redraw us with the new image
    return YES;
}

@end
