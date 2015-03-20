//
//  ID3V2FacadeTest.m
//  iD3
//
//  Created by Qiang Yu on 3/19/15.
//  Copyright (c) 2015 xbox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "FileTags.h"

@interface ID3V2FacadeTest : XCTestCase

@end

@implementation ID3V2FacadeTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    NSString * testFile = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"ID3V2.mp3"];
    FileTags * fileTags = [[FileTags alloc] initWithFile:testFile];
    
}

@end
