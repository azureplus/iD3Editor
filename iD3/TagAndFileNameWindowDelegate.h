//
//  TagAndFileNameWindowDelegate.h
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagAndFileNameWindowDelegate : NSObject<NSWindowDelegate> {
    
}

@property (nonatomic, assign) IBOutlet NSTabView * tabview;

- (IBAction) close:(id)sender;
- (IBAction) apply: (id)sender;
- (IBAction) filenameOnlyClicked: (id)sender;
@end
