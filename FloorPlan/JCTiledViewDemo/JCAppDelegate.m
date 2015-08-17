//
//  JCAppDelegate.m
//  JCTiledViewDemo
//
//  Created by Jesse Collis
//  Copyright (c) 2012 JC Multimedia Design. All rights reserved.
//

#import "JCAppDelegate.h"
#import "RootViewController.h"
#import <EstimoteSDK/EstimoteSDK.h>

@interface JCAppDelegate () <ESTBeaconManagerDelegate>
@property (nonatomic) CLBeaconRegion *beaconRegion;
@end

@implementation JCAppDelegate


+ (JCAppDelegate *)appDelegate
{
    return (JCAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.beaconManager = [ESTBeaconManager new];
    self.beaconManager.delegate = self;
   
    [self.beaconManager requestAlwaysAuthorization];
    CLBeaconRegion *allEstimoteBeacons = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]
        initWithUUIDString:@"b9407f30-f5f8-466e-aff9-25556b57fe6d"]
     identifier:@"all estimotes beacons region"];
     self.beaconRegion = allEstimoteBeacons;
    
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    // 2. Get storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 3. Create vc
    RootViewController *floorPlanVC = [storyboard instantiateViewControllerWithIdentifier:@"areas-list"];
    // 4. Set as root
    self.window.rootViewController = floorPlanVC;
    // 5. Call to show views
    [self.window makeKeyAndVisible];
    
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
 [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
}

@end
