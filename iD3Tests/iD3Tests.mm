//
//  iD3Tests.m
//  iD3Tests
//
//  Created by Qiang Yu on 7/25/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString_TLString.h"
#import "NSString_Filename.h"
#import "TagEntity.h"

@interface iD3Tests : XCTestCase

@end

@implementation iD3Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)parseDiscInfo:(NSString *) discInfo toDiscNum:(NSUInteger *)discNum andDiscTotal:(NSUInteger *)discTotal {
    *discNum = 0;
    *discTotal = 0;
    NSArray * components = [discInfo componentsSeparatedByString:@"/"];
    if ([components count] == 1) {
        *discNum = [[self parseInt:components[0]] unsignedIntegerValue];
    } else if ([components count] >= 2) {
        *discNum = [[self parseInt:components[0]] unsignedIntegerValue];
        *discTotal = [[self parseInt:components[1]] unsignedIntegerValue];
    }
}

-(NSNumber *) parseInt:(NSString *) str {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    return [f numberFromString:str];
}


- (void)testFileNameMatch {
//    NSString * filename = @"-sS-";
//    NSString * pattern = @"-s:T-";
//    NSDictionary * dict = [filename parse:pattern];
//    NSLog(@"artist--->%@", [dict objectForKey:@"artist"]);
//    NSLog(@"album--->%@", [dict objectForKey:@"album"]);
//    NSLog(@"title--->%@", [dict objectForKey:@"title"]);
//    NSLog(@"comment--->%@", [dict objectForKey:@"comment"]);
//    NSLog(@"genre--->%@", [dict objectForKey:@"genre"]);
//    NSLog(@"track--->%@", [dict objectForKey:@"track"]);
//    NSLog(@"year--->%@", [dict objectForKey:@"year"]);
    
    NSUInteger number, total;
    [self parseDiscInfo:@"/12" toDiscNum:&number andDiscTotal:&total];
    NSLog(@"--->%lu", (unsigned long)number);
    NSLog(@"--->%lu", (unsigned long)total);
}
@end
