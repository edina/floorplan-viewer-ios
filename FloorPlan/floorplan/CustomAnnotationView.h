//
//  CustomAnnotationView.h
//  FloorPlanIOS
//
//  Created by murray king on 11/08/2015.
//  Copyright (c) 2015 JC Multimedia Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAnnotationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *moreInfoButton;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *details;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@end
