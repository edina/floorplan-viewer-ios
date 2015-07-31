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
// 3. Add a property to hold the beacon manager
@property (nonatomic) ESTBeaconManager *beaconManager;
@end

@implementation JCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.beaconManager = [ESTBeaconManager new];
    self.beaconManager.delegate = self;
   
    [self.beaconManager requestAlwaysAuthorization];
    
    
    /*[[UIApplication sharedApplication]
 registerUserNotificationSettings:[UIUserNotificationSettings
                                   settingsForTypes:UIUserNotificationTypeAlert
                                   categories:nil]];*/
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    // 2. Get storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 3. Create vc
    RootViewController *floorPlanVC = [storyboard instantiateViewControllerWithIdentifier:@"areas-list"];
    // 4. Set as root
    self.window.rootViewController = floorPlanVC;
    // 5. Call to show views
    [self.window makeKeyAndVisible];
    
    CLBeaconRegion *lightBlue = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]
        initWithUUIDString:@"b9407f30-f5f8-466e-aff9-25556b57fe6d"]
    major:51613 minor:27600 identifier:@"monitored region"];
    CLBeaconRegion *lightGreen = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]
        initWithUUIDString:@"b9407f30-f5f8-466e-aff9-25556b57fe6d"]
    major:31179 minor:43808 identifier:@"monitored region"];
    
    [self.beaconManager startMonitoringForRegion:lightBlue];
    
    [self.beaconManager startMonitoringForRegion:lightGreen];
    
    return YES;
}

- (void)beaconManager:(id)manager didEnterRegion:(CLBeaconRegion *)region {
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody =
        @"Your gate closes in 47 minutes. "
         "Current security wait time is 15 minutes, "
         "and it's a 5 minute walk from security to the gate. "
         "Looks like you've got plenty of time!";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
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
}

@end
