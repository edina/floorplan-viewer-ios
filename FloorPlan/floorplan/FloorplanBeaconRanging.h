//
//  FloorplanBeaconRanging.h
//  FloorPlanIOS
//
//  Created by murray king on 17/08/2015.
//  Copyright (c) 2015 JC Multimedia Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area.h"
#import <EstimoteSDK/EstimoteSDK.h>
@interface FloorPlanBeaconRanging : NSObject

@property(nonatomic, strong) NSMutableDictionary * placesByBeacons;
- (Area *)areaForBeacon:(CLBeacon *)beacon ;

@end
