//
//  Utils.h
//  FloorPlan
//
//  Created by murrayhking on 08/06/2015.
//

#import <Foundation/Foundation.h>
#import "math.h"

#define originShift (2 * M_PI * 6378137 / 2.0)

typedef struct {
    CGFloat lat;
    CGFloat lon;
} LatLon;

@interface Utils : NSObject

- (LatLon) convertLatitude: (CGFloat)  latDecimalDegrees andLongitude: (CGFloat) lonDecimalDegrees;
-(LatLon) convertToImagePixelslatInMeter:(CGFloat) y1 andLonInMeters:(CGFloat)  x1;

@end
