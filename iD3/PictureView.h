//
//  PictureView.h
//  iD3
//
//  Created by Qiang Yu on 10/7/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PictureView : NSImageView {
@private
    NSTrackingArea * _trackingArea;
}

@property (assign, nonatomic) IBOutlet NSButton * deleteButton;
@end
