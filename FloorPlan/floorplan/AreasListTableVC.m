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

    
    NSString *plistLocation = [[NSBundle mainBundle] pathForResource:@"areas_config" ofType:@"plist"];
    NSArray *areas = [[NSDictionary alloc] initWithContentsOfFile:plistLocation][@"areas"];
    
    for (NSDictionary *r in areas) {
        
        
        Area *area = [Area createAreaWithTitle:r[@"title"] description:r[@"description"] image:r[@"image"] location:r[@"description"]];

        
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.areas count];
}

@end
