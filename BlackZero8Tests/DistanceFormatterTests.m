//
//  DistanceFormatterTests.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-07.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DistanceFormatter.h"
#import "SettingsObject.h"

@interface DistanceFormatterTests : XCTestCase

@end

@implementation DistanceFormatterTests

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

- (void)testOutput
{
    SettingsObject *settings = [SettingsObject sharedInstance];
    settings.useMetric = true;
    
    // Test that displayed distacnce does not exceed 99.99 units.
    CGFloat distance = 10000000;
    
    DistanceFormatter *formatter = [[DistanceFormatter alloc] init];
    NSString *output = [formatter formattedDistanceString:distance];
    XCTAssertEqualObjects(output, @"99.99", @"Output is in valid");
    
    output = [formatter displayUnits];
    XCTAssertEqualObjects(output, @"km", @"Output is in Metric");
    
    settings.useMetric = false;
    output = [formatter displayUnits];
    XCTAssertEqualObjects(output, @"mi", @"Output is in Imperial");
}

@end
