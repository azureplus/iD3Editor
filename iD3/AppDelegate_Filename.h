//
//  AppDelegate_Filename.h
//  iD3
//
//  Created by Qiang Yu on 9/19/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface AppDelegate(Filename)
///
-(void) setPathDepth:(unsigned int) depth;
-(unsigned int) pathDepth;

/// filename to tag
-(void) filenameToTag:(NSString *)pattern;

/// tag to filename (rename files)
-(void) tagToFilename: (NSString *)pattern;

-(void) renameFilesByReplacing:(NSString *)replaceFrom with:(NSString *)replaceTo andCapitalization:(NSUInteger)capitalization;
@end
