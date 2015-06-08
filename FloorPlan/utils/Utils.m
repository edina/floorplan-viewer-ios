//
//  Utils.m
//  FloorPlan
//
//  Created by murrayhking on 08/06/2015.
//

#import "Utils.h"

@implementation Utils

//todo
//process image world file to get values
//Line 1: A: pixel size in the x-direction in map units/pixel
//Line 2: D: rotation about y-axis
//Line 3: B: rotation about x-axis
//Line 4: E: pixel size in the y-direction in map units, almost always negative[3]
//Line 5: C: x-coordinate of the center of the upper left pixel
//Line 6: F: y-coordinate of the center of the upper left pixel
// formula from http://en.wikipedia.org/wiki/World_file
const CGFloat A = 0.02476749115,
D = 0.007008493559,
B = 0.006617771404,
E = -0.02338670833,
C = -355077.5328,
F = 7547044.7;

 //Converts given lat/lon in WGS84 Datum to XY in Spherical Mercator EPSG:900913

-(LatLon) convertLatitude:(CGFloat)lat andLongitude:(CGFloat)lon{
    CGFloat mx = lon * originShift / 180.0;
    CGFloat my = log(tan((90 + lat) * M_PI / 360.0 )) / (M_PI/ 180.0);
    my = my * originShift / 180.0;
    LatLon latlon;
    latlon.lat = my;
    latlon.lon = mx;
    return latlon;
}


-(LatLon) convertToImagePixelslatInMeter:(CGFloat) y1 andLonInMeters:(CGFloat)  x1 {
    
    
    //x = (Ex' - By' +BF -EC)/(AE -DB)
    double x = (E*x1 - B*y1 + B*F - E*C )/(A*E - D*B);
    //y = (-Dx' + Ay' + DC - AF)/(AE - DB)
    double y = (-D*x1 + A*y1 + D*C - A*F)/(A*E - D*B);

    LatLon latLon;
    latLon.lat = y;
    latLon.lon = x;
    return latLon;
}



@end
