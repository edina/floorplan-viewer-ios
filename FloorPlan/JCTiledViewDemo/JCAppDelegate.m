//
//  JCAppDelegate.m
//  JCTiledViewDemo
//
//  Created by Jesse Collis
//  Copyright (c) 2012 JC Multimedia Design. All rights reserved.
//

#import "JCAppDelegate.h"
#import <EstimoteSDK/EstimoteSDK.h>
#import "FloorplanBeaconRanging.h"

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
    UIViewController *floorPlanVC = [storyboard instantiateViewControllerWithIdentifier:@"areas-list"];
    // 4. Set as root
    
    self.floorPlanRanging = [[FloorPlanBeaconRanging alloc] init];
    
    self.window.rootViewController = floorPlanVC;
    // 5. Call to show views
    [self.window makeKeyAndVisible];
    self.areas = [[NSMutableArray alloc] init];
    
    NSString *plistLocation = [[NSBundle mainBundle] pathForResource:@"areas_config" ofType:@"plist"];
    NSArray *areas = [[NSDictionary alloc] initWithContentsOfFile:plistLocation][@"areas"];
    
    for (NSDictionary *r in areas) {
        
        
        Area *area = [Area createAreaWithTitle:r[@"title"] description:r[@"description"] image:r[@"image"] location:r[@"location"] minorBeaconId:r[@"beaconMinorId"] video:r[@"video"]];
        
        
        [self.areas addObject:area];
        
    }
    
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
