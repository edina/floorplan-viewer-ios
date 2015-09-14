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

@interface FloorPlanBeaconRanging()

@property (nonatomic) NSMutableDictionary *placesByBeacons;


@end
@implementation FloorPlanBeaconRanging


-(id)init{


    
    self=[super init];
    if(self){
        NSString *plistLocation = [[NSBundle mainBundle] pathForResource:@"areas_config" ofType:@"plist"];
        NSArray *areas = [[NSDictionary alloc] initWithContentsOfFile:plistLocation][@"areas"];
        
        for (NSDictionary *r in areas) {
            
            
            Area *area = [Area createAreaWithTitle:r[@"title"] description:r[@"description"] image:r[@"image"] location:r[@"location"] minorBeaconId:r[@"minorBeaconId"]];
            
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
