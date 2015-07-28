//
//  Area.h
//  FloorPlanIOS
//
//  Created by murray king on 27/07/2015.
//  Copyright (c) 2015 JC Multimedia Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Area : NSObject

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *location;

+ (Area *)createAreaWithTitle:(NSString *)title description:(NSString *)description image:(NSString *)image location:(NSString *)location;

@end
