//
//  SignUpViewControllerATests.m
//  BlackZero8
//
//  Created by Piers Beckley on 24/03/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SignUpViewControllerA.h"
#import "OCMock.h"



@interface SignUpViewControllerATests : XCTestCase


@property (nonatomic, strong) id username;
@property (nonatomic, strong) id password;
@property (nonatomic, strong) id email;
@property (nonatomic, strong) id firstname;
@property (nonatomic, strong) id lastname;




@end

@implementation SignUpViewControllerATests
{
    
    SignUpViewControllerA * testControllerA;

}

@synthesize username, password, email, firstname, lastname;

- (void)setUp
{
    [super setUp];
    
    testControllerA = [[SignUpViewControllerA alloc ] init];
    
    username = [OCMockObject niceMockForClass: [UITextField class]];
    password = [OCMockObject niceMockForClass: [UITextField class]];
    email = [OCMockObject niceMockForClass: [UITextField class]];
    firstname = [OCMockObject niceMockForClass: [UITextField class]];
    lastname = [OCMockObject niceMockForClass: [UITextField class]];
    
    
}

- (void)tearDown
{
    testControllerA = nil;
    username = password = email = firstname = lastname = nil;
    [super tearDown];
}

- (void) testThatParseCreatesNewUserSuccessfully {
    
    
    [[[username stub] andReturn: @"hello" ] text];
    [[[password stub] andReturn: @"there" ] text];
    [[[email    stub] andReturn: @"you@old.com" ] text];
    [[[firstname stub] andReturn: @"dog" ] text];
    [[[lastname  stub] andReturn: @"you" ] text];
    
    id testUser = [OCMockObject niceMockForClass:[BZUser class]];
    
    testControllerA.username = username;
    testControllerA.password = password;
    testControllerA.email = email;
    testControllerA.firstname = firstname;
    testControllerA.lastname = lastname;
    
    testControllerA.currentUser = testUser;
    
    [[testUser expect] signUpInBackgroundWithBlock:[OCMArg any]];
    [testControllerA createNewUser];
    
    [username verify];
    [testUser verify];
    
}




@end
