//
//  JCAppDelegate.h
//  JCTiledViewDemo
//
//  Created by Jesse Collis
//  Copyright (c) 2012 JC Multimedia Design. All rights reserved.
//
#import <EstimoteSDK/EstimoteSDK.h>
#import "FloorplanBeaconRanging.h"

@interface JCAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
// 3. Add a property to hold the beacon manager
@property (nonatomic) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) FloorPlanBeaconRanging *floorPlanRanging;
@property(nonatomic, strong) NSMutableArray *areas;
@property(nonatomic, strong) Area *currentArea;

+ (JCAppDelegate *)appDelegate;

@end
