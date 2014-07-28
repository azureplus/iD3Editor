//
//  iD3Tests.m
//  iD3Tests
//
//  Created by Qiang Yu on 7/25/14.
//  Copyright (c) 2014 xbox.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString_TLString.h"
#import "Tag.h"

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

- (void)testTag
{
    Tag * tag = [[Tag alloc] initWithFile:@"/tmp/sample.mp3"];
    NSLog(@"--->%@", tag);
}

@end
