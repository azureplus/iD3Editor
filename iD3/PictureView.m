//
//  PictureView.m
//  iD3
//
//  Created by Qiang Yu on 10/7/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "PictureView.h"
#import "AppDelegate.h"
#import "NSImage_NSData.h"

@implementation PictureView
-(void) mouseEntered:(NSEvent *)theEvent {
    AppDelegate * delegate = [[NSApplication sharedApplication] delegate];
    if ([[[delegate tagArrayController] selectedObjects] count]) {
        [self.deleteButton setHidden:self.image == [NSImage nullPlaceholderImage]];
    }
}

-(void) mouseExited:(NSEvent *)theEvent {
    [self.deleteButton setHidden:YES];
}

-(void)updateTrackingAreas {
    if(_trackingArea != nil) {
        [self removeTrackingArea:_trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    _trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

-(NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender {
    AppDelegate * delegate = [[NSApplication sharedApplication] delegate];
    if (![[[delegate tagArrayController] selectedObjects] count]) {
        return NSDragOperationNone;
    }
    
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
        return NSDragOperationGeneric;
    } else {
        return NSDragOperationNone;
    }
}

-(void) draggingExited:(id<NSDraggingInfo>)sender {
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *paste = [sender draggingPasteboard];
    
    NSArray *types = [NSArray arrayWithObjects:NSTIFFPboardType, NSFilenamesPboardType, nil];

    NSString *desiredType = [paste availableTypeFromArray:types];
    NSData *carriedData = [paste dataForType:desiredType];
    
    if (nil == carriedData) {
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
    [self setNeedsDisplay:YES];
    return YES;
}

@end
