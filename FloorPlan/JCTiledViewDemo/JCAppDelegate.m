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
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
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
}

@end
