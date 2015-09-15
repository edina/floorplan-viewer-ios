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
@property (nonatomic, strong) FloorPlanBeaconRanging *floorPlanRanging;
@property (nonatomic, strong) Area *currentSelectedArea;
@end

@implementation AreasListTableVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //sort areas key on beacon.
    self.floorPlanRanging = [JCAppDelegate appDelegate].floorPlanRanging;
    
    
    self.navigationItem.title = @"Areas";
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    JCAppDelegate *appDelegate = [JCAppDelegate appDelegate];
    
    appDelegate.beaconManager.delegate = self;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AreaCell";
    
    AreaTableViewCell *cell = (AreaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[AreaTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
    }
    [cell.areaTitle setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18]];
    
    [cell.areaDetail setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12]];
    
    JCAppDelegate *appDelegate = [JCAppDelegate appDelegate];
    Area *area = [appDelegate.areas objectAtIndex:indexPath.row];
    cell.areaTitle.text = area.title;
    cell.areaImage.image = area.image;
    cell.areaDetail.text = area.desc;
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(![segue.identifier isEqualToString:@"floorplan"]){
        return;
    }
    Area *activatedArea = nil;
    if([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        
        if(indexPath) {
            JCAppDelegate *appDelegate = [JCAppDelegate appDelegate];
            activatedArea = [appDelegate.areas objectAtIndex:indexPath.row];
            
        }
        
    } else if ([sender isKindOfClass:[Area class]]){
        
        
        activatedArea = sender;
        
    }
    
    RootViewController *controller = [segue destinationViewController];
    controller.area = activatedArea;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JCAppDelegate *appDelegate = [JCAppDelegate appDelegate];
    return [appDelegate.areas count];
}


- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons
             inRegion:(CLBeaconRegion *)region {
    CLBeacon *nearestBeacon = beacons.firstObject;
    if (nearestBeacon) {
        Area *area = [self.floorPlanRanging areaForBeacon:nearestBeacon];
        // TODO: update the UI here
        NSLog(@"%@", area.title); // TODO: remove after implementing the UI
        //go to place on floorplan
        


        if (area) {

            self.currentSelectedArea = area;
            if(!self.currentSelectedArea.hasVisited){
                self.currentSelectedArea.hasVisited = YES;
                // show popup here
                
                        UIAlertController *alertController = [UIAlertController
                              alertControllerWithTitle:@"Detected Beacon"
                              message:@"Message"
                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction 
            actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                      style:UIAlertActionStyleCancel
                    handler:^(UIAlertAction *action)
                    {
                      NSLog(@"Cancel action");
                    }];

UIAlertAction *okAction = [UIAlertAction 
            actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                      style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction *action)
                    {
                        [self performSegueWithIdentifier:@"floorplan" sender:area];
                        NSLog(@"OK action");
                    }];

[alertController addAction:cancelAction];
[alertController addAction:okAction];
           [self presentViewController:alertController animated:YES completion:nil];
                
                
            }
        }
        
    }
}

@end
