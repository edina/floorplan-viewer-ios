//
//  Area.m
//  FloorPlanIOS
//
//  Created by murray king on 27/07/2015.
//  Copyright (c) 2015 JC Multimedia Design. All rights reserved.
//

#import "Area.h"

@implementation Area

+ (Area *)createAreaWithTitle:(NSString *)title description:(NSString *)description image:(NSString *)image location:(NSString *)location minorBeaconId:(NSString *)beaconId{
    

    Area *area = [[Area alloc] init];
    area.title = title;
    area.desc = description;
    area.image = [UIImage imageNamed:image];
    area.location = location;
    area.minorBeaconId = beaconId;
    
    return area;
    
}

@end
