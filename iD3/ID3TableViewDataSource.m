//
//  ID3TableViewDataSource.m
//  iD3
//
//  Created by Qiang Yu on 7/28/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "ID3TableViewDataSource.h"
#import "Tag.h"

@implementation ID3TableViewDataSource

-(void)awakeFromNib {
    _tagSource = (id<TagSource>)[[NSApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTag:) name:@"NEWTAGS" object:nil];
}

-(void)newTag:(id) object {
    [_tableView reloadData];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[_tagSource tags] count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)column row:(NSInteger)rowIndex {
    Tag * tag = [_tagSource tags][rowIndex];
    
    NSString * identifier = column.identifier;
    if ([identifier isEqualToString:@"filename"]) {
        return tag.filename;
    } else {
        return [tag getFrame:identifier];
    }
}
@end
