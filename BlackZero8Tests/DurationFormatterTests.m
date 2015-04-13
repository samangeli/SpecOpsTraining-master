//
//  DurationFormatterTests.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-07.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Formatter.h"


@interface DurationFormatterTests : XCTestCase

@end

@implementation DurationFormatterTests

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
    Formatter *formatter = [[Formatter alloc] init];
    NSString *output = [formatter formattedDurationString:0.0];
    XCTAssertEqualObjects(output, @"00:00:00", @"Output is good");
    
    NSTimeInterval time = 24 * 3600 + 30;
    output = [formatter formattedDurationString:time];
    XCTAssertEqualObjects(output, @"23:59:59", @"Output is good");
}
@end
