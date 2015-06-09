//
//  FloorPlan_Tests.m
//  FloorPlan Tests
//
//  Created by murray king on 09/06/2015.
//  Copyright (c) 2015 JC Multimedia Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Utils.h"


bool AreSame(double a, double b);


#define EPSILON 1e-1

@interface FloorPlan_Tests : XCTestCase

@end

@implementation FloorPlan_Tests

bool AreSame(double a, double b)
{
    return fabs(a - b) < EPSILON;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLatLonToMeters {
    // This is an example of a functional test case.
    
    Utils *utils = [[Utils alloc] init];
    
    //edinburgh univerisity library
    CGFloat lat = 55.942710;
    CGFloat lon = -3.18915;
    
    
    LatLon latLon;
    latLon = [utils convertLatitude:lat andLongitude:lon];
    
    
    // assertEquals("lat in meters ", 7547019.280554745, latLon.getLat(), DELTA);
    // assertEquals("lon in meters ", -355014.5540633685, latLon.getLon(), DELTA);
    NSLog(@" Latitude %f ", latLon.lat);
    NSLog(@" Longitude %f ", latLon.lon);
    XCTAssertEqualWithAccuracy(7547019.280554745, latLon.lat, EPSILON,  @"Incorrect Latutide in m" );
    XCTAssertEqualWithAccuracy(-355014.5540633685, latLon.lon, EPSILON,  @"Incorrect Logitude in m" );
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
