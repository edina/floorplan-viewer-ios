//
//  RootViewController.h
//  JCTiledViewDemo
//
//  Created by Jesse Collis
//  Copyright (c) 2012 JC Multimedia Design. All rights reserved.
//

#import "JCTiledScrollView.h"
#import "Area.h"

@class DetailView, JCTiledScrollView;

@interface RootViewController : UIViewController <JCTileSource, JCTiledScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *moreInfoButton;

@property (weak, nonatomic) IBOutlet UIView *callout;
@property (strong, nonatomic) JCTiledScrollView *scrollView;
@property (strong, nonatomic) DetailView *detailView;
@property (strong, nonatomic) Area *area;
- (IBAction)moreInfo:(id)sender;

@end
