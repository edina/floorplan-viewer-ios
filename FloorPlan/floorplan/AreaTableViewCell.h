//
//  AreaTableViewCell.h
//  FloorPlanIOS
//
//  Created by murray king on 28/07/2015.
//  Copyright (c) 2015 JC Multimedia Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *areaTitle;
@property (weak, nonatomic) IBOutlet UILabel *areaDetail;
@property (weak, nonatomic) IBOutlet UIImageView *areaImage;

@end
