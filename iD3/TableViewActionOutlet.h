//
//  TableViewActionOutlet.h
//  iD3
//
//  Created by Qiang Yu on 8/11/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewActionOutlet : NSObject

@property (nonatomic, weak) IBOutlet NSArrayController * tagArrayController;

-(IBAction) selectedAll:(id)sender;
-(IBAction) selectedNone:(id)sender;
-(IBAction) invertSelection:(id)sender;
-(IBAction) removeSelectedTags:(id)sender;
@end
