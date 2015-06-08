//
//  FloorPlan_Tests.m
//  FloorPlan Tests
//
//  Created by murrayhking on 08/06/2015.
//  Copyright (c) 2015 JC Multimedia Design. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>


@interface FloorPlan_Tests : XCTestCase

@end

@implementation FloorPlan_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [super tearDown];
}

- (void)testConvertLatitudeAndLongitude {
    // This is an example of a functional test case.
    Utils *utils = [[Utils alloc] init];
    //edinburgh univerisity library
    //55.942710, -3.18915
    
    
    LatLon latLon ;
    latLon = [utils convertLatitude:55.942710 andLongitude:-3.18915];
    
    NSLog(@"lat %f lon %f", latLon.lat, latLon.lon );
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
