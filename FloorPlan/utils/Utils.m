//
//  Utils.m
//  FloorPlan
//
//  Created by murrayhking on 08/06/2015.
//

#import "Utils.h"

@implementation Utils

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



@end
