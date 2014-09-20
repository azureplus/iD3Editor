//
//  AppDelegate_Filename.m
//  iD3
//
//  Created by Qiang Yu on 9/19/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import "AppDelegate_Filename.h"
#import "NSString_Filename.h"
#import "FilenameValueTransform2.h"

@implementation AppDelegate(Filename)
-(void) setPathDepth:(unsigned int) depth{
    for (TagEntity * tagEntity in self.tagArrayController.arrangedObjects) {
        [tagEntity willChangeValueForKey:@"filename"];
    }
    
    [FilenameValueTransform2 setPathDepth:depth];
    
    for (TagEntity * tagEntity in self.tagArrayController.arrangedObjects) {
        [tagEntity didChangeValueForKey:@"filename"];
    }
}

-(unsigned int) pathDepth {
    return [FilenameValueTransform2 pathDepth];
}


// convert filename to tag
-(void) filenameToTag:(NSString *)pattern {
    NSArray * selectedTags = self.tagArrayController.selectedObjects;
    for (TagEntity * tag in selectedTags) {
        NSString * filename = [FilenameValueTransform2 filenameToParse:tag.filename];
        NSDictionary * frames = [filename parse:pattern];
        for (NSString * key in frames) {
            NSString * value = frames[key];
            if ([key isEqualToString:@"artist"]) {
                tag.artist = value;
            } else if ([key isEqualToString:@"album"]) {
                tag.album = value;
            } else if ([key isEqualToString:@"title"]) {
                tag.title = value;
            } else if ([key isEqualToString:@"track"]) {
                tag.track = value;
            } else if ([key isEqualToString:@"composer"]) {
                tag.composer = value;
            } else if ([key isEqualToString:@"genre"]) {
                tag.genre = value;
            } else if ([key isEqualToString:@"year"]) {
                tag.year = value;
            }
        }
    }
}

// Tag to filename rename file
-(void) tagToFilename: (NSString *)pattern {
    //    if ([pattern length] == 0) {
    //        return;
    //    }
    //
    //    [self saveChanges:nil];
    //
    //    NSMutableArray * tagsToRename = [NSMutableArray arrayWithCapacity:32];
    //    NSMutableArray * tagsNewlyAdded = [NSMutableArray arrayWithCapacity:32];
    //
    //    for (TagEntity * tagEntity in _tagArrayController.selectedObjects) {
    //        [tagsToRename addObject:tagEntity];
    //    }
    //
    //    for (TagEntity * tagEntity in tagsToRename) {
    //        NSString * oldFilename = tagEntity.tag.filename;
    //
    //        NSMutableArray * components = [NSMutableArray arrayWithArray:[oldFilename pathComponents]];
    //        NSUInteger trackSize = [self _getTrackSize: tagEntity];
    //        NSString * newFilename = [NSString fromTag:tagEntity withPattern:pattern andTrackSize:trackSize];
    //        components[components.count - 1] = [newFilename stringByAppendingPathExtension:[oldFilename pathExtension]];
    //        newFilename = [NSString pathWithComponents:components];
    //
    //        NSFileManager * fm = [[NSFileManager alloc] init];
    //        BOOL result = [fm moveItemAtPath:oldFilename toPath:newFilename error:nil];
    //
    //        if (result) {
    //            [self removeTagEntity:tagEntity];
    //            TagEntity * newTag = [self _addFile:[NSURL fileURLWithPath:newFilename isDirectory:NO]];
    //            [tagsNewlyAdded addObject:newTag];
    //        } else {
    //            [tagsNewlyAdded addObject:tagEntity];
    //        }
    //    }
    //    
    //    [_tagArrayController setSelectedObjects:tagsNewlyAdded];
}

@end
