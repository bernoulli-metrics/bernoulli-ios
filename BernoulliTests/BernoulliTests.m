//
//  BernoulliTests.m
//  BernoulliTests
//
//  Created by Joe Gasiorek on 3/8/14.
//  Copyright (c) 2014 Joe Gasiorek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs.h>
#import <OHHTTPStubsResponse+JSON.h>
#import "Bernoulli.h"

@interface BernoulliTests : XCTestCase

// FROM: http://dadabeatnik.wordpress.com/2013/09/12/xcode-and-asynchronous-unit-testing/
// Macro - Set the flag for block completion
#define StartBlock() __block BOOL waitingForBlock = YES

// Macro - Set the flag to stop the loop
#define EndBlock() waitingForBlock = NO

// Macro - Wait and loop until flag is set
#define WaitUntilBlockCompletes() WaitWhile(waitingForBlock)

// Macro - Wait for condition to be NO/false in blocks and asynchronous calls
// Each test should have its own instance of a BOOL condition because of non-thread safe operations
#define WaitWhile(condition) \
do { \
while(condition) { \
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
} \
} while(0)

@end

@implementation BernoulliTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testThrowsForNilClientID
{
    NSArray *arr = [NSArray arrayWithObject:@"first"];
    XCTAssertThrows([Bernoulli getExperimentsForIds:arr clientId:nil userId:@"s59" userData:nil success:nil error:nil], @"Should throw exception");
}

- (void)testHandlesGetExperimentsSuccess
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub all those requests with "Hello World!" string
        NSData* stubData = [@"{\"status\": \"ok\", \"value\": [{\"status\": 1, \"user_id\": \"s59\", \"segmentName\": null, \"variant\": \"blue\", \"segment\": null, \"id\": \"first\", \"name\": \"First Experiment\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *expectedResponseDict = @{@"Success" : @"Yes"};
        
        NSMutableDictionary* mutableHeaders = [NSMutableDictionary dictionary];
        mutableHeaders[@"Content-Type"] = @"application/json";
        NSDictionary *httpHeaders = [NSDictionary dictionaryWithDictionary:mutableHeaders]; // make immutable again
        
        return [OHHTTPStubsResponse responseWithData:stubData statusCode:200 headers:httpHeaders];
    }];
    
    
    NSArray *arr = [NSArray arrayWithObject:@"first"];

    StartBlock();
    XCTAssertTrue([Bernoulli getExperimentsForIds:arr clientId:@"1" userId:@"s59" userData:nil success:^(NSArray *experiments) {
        XCTAssertTrue(1 == [experiments count], @"Expected 1 experiment");
        id experiment = [experiments objectAtIndex:0];
        XCTAssertTrue([[experiment objectForKey:@"variant"] isEqualToString:@"blue"]);
        EndBlock();
    } error:^(NSString *message) {
        XCTFail(@"Unexpected network error");
        EndBlock();
    }]);
    
    WaitUntilBlockCompletes();
   
}

@end
