//
//  MissionTests.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-02.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AFNetworking/AFNetworking/AFNetworking.h>
#import "Mission.h"

@interface MissionTests : XCTestCase

@end

@implementation MissionTests


-(NSData *)loadFixture:(NSString *)name
{
    NSBundle *unitTestBundle = [NSBundle bundleForClass:[self class]];
    NSString *pathForFile    = [unitTestBundle pathForResource:name ofType:nil];
    NSData   *data           = [[NSData alloc] initWithContentsOfFile:pathForFile];
    return data;
}

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

- (void)testLoadMission
{
    NSData *missionData = [self loadFixture:@"mission.json"];
    Mission *testMission = [[Mission alloc] init];
    [testMission processDataForMission:missionData];
    
    XCTAssertNotEqual([testMission.events count], 0, @"mission event count is not zero");
    XCTAssertNotEqual(testMission.duration, 0, @"mission duration is not zero");
    XCTAssertNotNil(testMission.name, @"mission name is not nil");
}

@end
