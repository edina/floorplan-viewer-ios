//
//  FloorplanBeaconRanging.m
//  FloorPlanIOS
//
//  Created by murray king on 17/08/2015.
//  Copyright (c) 2015 JC Multimedia Design. All rights reserved.
//

#import "FloorPlanBeaconRanging.h"
#import "Area.h"
#import <EstimoteSDK/EstimoteSDK.h>
#import "JCAppDelegate.h"
@interface FloorPlanBeaconRanging()




@end
@implementation FloorPlanBeaconRanging


-(id)init{


    self=[super init];
    if(self){
    
        JCAppDelegate *appDelegate = [JCAppDelegate appDelegate];
        for (Area * area in appDelegate.areas) {
            self.placesByBeacons[area.minorBeaconId] = area;
            
        }
    }
    return self;
}


- (NSMutableDictionary *)placesByBeacons
{
    if (!_placesByBeacons) {
        _placesByBeacons = [[NSMutableDictionary alloc] init];
    }
    return _placesByBeacons;
}

- (Area *)areaForBeacon:(CLBeacon *)beacon {
    NSString *beaconKey = [NSString stringWithFormat:@"%@", beacon.minor];
    Area *area = [self.placesByBeacons objectForKey:beaconKey];
    
    return area;
}




@end
