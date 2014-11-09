//
//  AppDelegate_Filename.m
//  iD3
//
//  Created by Qiang Yu on 9/19/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
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

-(NSUInteger)_getTrackSize:(TagEntity *)tag {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesSubentities:YES];
    [request setEntity:[NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext]];
    
    NSString * album = [tag.album stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"album = '%@'", album]];
    [request setPredicate:predicate];
    
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:nil];
    if(count == NSNotFound) {
        return 0;
    } else {
        int size = 1;
        while (count >= 10) {
            count = count/10;
            size++;
        }
        return size;
    }
}

-(void)_filerenameHelp:(NSString *)pattern {
    self.progressWindow.title = @"Renaming Files";
    [self.progressIndicator startAnimation:nil];
    [self.filenameField setStringValue:@"renaming files..."];

    self.closeProgressWindow = NO;
    NSModalSession session = [NSApp beginModalSessionForWindow:self.progressWindow];

    for (TagEntity * tagEntity in self.tagArrayController.selectedObjects) {
        if ([NSApp runModalSession:session] != NSModalResponseContinue || self.closeProgressWindow) {
            break;
        }

        NSString * oldFilename = tagEntity.filename;
        
        NSMutableArray * components = [NSMutableArray arrayWithArray:[oldFilename pathComponents]];
        NSUInteger trackSize = [self _getTrackSize: tagEntity];
        NSString * newFilename = [NSString fromTag:tagEntity withPattern:pattern andTrackSize:trackSize];
        newFilename = [newFilename stringByReplacingOccurrencesOfString:@"/" withString:@":"];        
        components[components.count - 1] = [newFilename stringByAppendingPathExtension:[oldFilename pathExtension]];
        newFilename = [NSString pathWithComponents:components];

        [self.filenameField setStringValue:[NSString stringWithFormat:@"Renaming %@ to %@", oldFilename, newFilename]];
        [NSThread sleepForTimeInterval:0.3];
        
        NSFileManager * fm = [[NSFileManager alloc] init];
        BOOL result = [fm moveItemAtPath:oldFilename toPath:newFilename error:nil];
        
        if (result) {
            tagEntity.filename = newFilename;
        }
    }
    
    [NSApp stopModal];
    [self.progressIndicator stopAnimation:nil];
    [self.progressWindow orderOut:nil];
    self.closeProgressWindow = NO;
    [NSApp endModalSession:session];
}

// Tag to filename rename file
-(void) tagToFilename: (NSString *)pattern {
    if ([pattern length] == 0) {
        return;
    }

    [self _filerenameHelp:pattern];
}

-(void) renameFilesByReplacing:(NSString *)replaceFrom with:(NSString *)replaceTo andCapitalization:(NSUInteger)capitalization {
    self.progressWindow.title = @"Renaming Files";
    [self.progressIndicator startAnimation:nil];
    [self.filenameField setStringValue:@"renaming files..."];
    
    self.closeProgressWindow = NO;
    NSModalSession session = [NSApp beginModalSessionForWindow:self.progressWindow];
    
    for (TagEntity * tagEntity in self.tagArrayController.selectedObjects) {
        if ([NSApp runModalSession:session] != NSModalResponseContinue || self.closeProgressWindow) {
            break;
        }
        
        NSString * oldFilename = tagEntity.filename;
        NSString * extension = [oldFilename pathExtension];
        NSString * newFilename = [oldFilename stringByDeletingPathExtension];
        
        newFilename = [NSString formatString:newFilename byReplacing:replaceFrom with:replaceTo andCapitalization:capitalization];
        newFilename = [newFilename stringByAppendingPathExtension:extension];
        
        [self.filenameField setStringValue:[NSString stringWithFormat:@"Renaming %@ to %@", oldFilename, newFilename]];
        [NSThread sleepForTimeInterval:0.3];
        
        NSFileManager * fm = [[NSFileManager alloc] init];
        BOOL result = [fm moveItemAtPath:oldFilename toPath:newFilename error:nil];
        
        if (result) {
            tagEntity.filename = newFilename;
        }
    }
    
    [NSApp stopModal];
    [self.progressIndicator stopAnimation:nil];
    [self.progressWindow orderOut:nil];
    self.closeProgressWindow = NO;    
    [NSApp endModalSession:session];

}
@end
