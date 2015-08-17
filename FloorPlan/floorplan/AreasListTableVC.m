//
//  AreasListTableVC.m
//  FloorPlanIOS
//
//  Created by murray king on 27/07/2015.
//  Copyright (c) 2015 JC Multimedia Design. All rights reserved.
//

#import "AreasListTableVC.h"
#import "Area.h"
#import "AreaTableViewCell.h"
#import "RootViewController.h"
#import <EstimoteSDK/EstimoteSDK.h>
#import "FloorPlanBeaconRanging.h"
#import "JCAppDelegate.h"

@interface AreasListTableVC() <ESTBeaconManagerDelegate>
@property (strong) FloorPlanBeaconRanging * floorPlanRanging;
@end

@implementation AreasListTableVC

- (NSMutableArray*) areas
{
    if (!_areas){
        _areas = [[NSMutableArray alloc] init];
    }
    return _areas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//sort areas key on beacon.
    self.floorPlanRanging = [[FloorPlanBeaconRanging alloc] init];
    
    JCAppDelegate *appDelegate = [JCAppDelegate appDelegate];

    appDelegate.beaconManager.delegate = self;

    
    NSString *plistLocation = [[NSBundle mainBundle] pathForResource:@"areas_config" ofType:@"plist"];
    NSArray *areas = [[NSDictionary alloc] initWithContentsOfFile:plistLocation][@"areas"];
    
    for (NSDictionary *r in areas) {
        
        
        Area *area = [Area createAreaWithTitle:r[@"title"] description:r[@"description"] image:r[@"image"] location:r[@"location"] minorBeaconId:r[@"beaconMinorId"]];

        
        [self.areas addObject:area];
        
    }
    
    

    
    self.navigationItem.title = @"Areas";
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AreaCell";
    
    AreaTableViewCell *cell = (AreaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[AreaTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    
    Area *area = [self.areas objectAtIndex:indexPath.row];
    cell.areaTitle.text = area.title;
    cell.areaImage.image = area.image;
    cell.areaDetail.text = area.desc;
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[UITableViewCell class]]){
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
   
        
        if(indexPath) {
            Area *area = [self.areas objectAtIndex:indexPath.row];
            if([segue.identifier isEqualToString:@"floorplan"]){
 
                
                RootViewController *controller = [segue destinationViewController];
                controller.area = area;

                
            }
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.areas count];
}


- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons
             inRegion:(CLBeaconRegion *)region {
    CLBeacon *nearestBeacon = beacons.firstObject;
    if (nearestBeacon) {
        Area *area = [self.floorPlanRanging areaForBeacon:nearestBeacon];
        // TODO: update the UI here
        NSLog(@"%@", area.title); // TODO: remove after implementing the UI
        
        
    }
}

@end
