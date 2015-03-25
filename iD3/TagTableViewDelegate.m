//
//  TagTableViewDelegate.m
//  iD3
//
//  Created by Qiang Yu on 3/24/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import "TagTableViewDelegate.h"
#import "NSImage_NSData.h"

@implementation TagTableViewDelegate
- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"COVER_ART"]) {
        NSImageCell * cell = [[NSImageCell alloc] init];
        return cell;
    } else {
        return [tableColumn dataCellForRow:row];
    }
}
@end
