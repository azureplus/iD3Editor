//
//  TagAndFileNameWindowDelegate.h
//  iD3
//
//  Created by Qiang Yu on 8/2/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagAndFileNameWindowDelegate : NSObject<NSWindowDelegate> {
    
}

@property (nonatomic, assign) IBOutlet NSTabView * tabview;
@property (nonatomic, assign) IBOutlet NSTextField * n2tPattern;

- (IBAction) cancel:(id)sender;
- (IBAction) preview: (id)sender;
@end
