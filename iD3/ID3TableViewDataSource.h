//
//  ID3TableViewDataSource.h
//  iD3
//
//  Created by Qiang Yu on 7/28/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagSource.h"

@interface ID3TableViewDataSource : NSObject <NSTableViewDataSource> {
    id<TagSource> _tagSource;
}
@property (nonatomic, weak) IBOutlet NSTableView * tableView;
@end
