//
//  RootViewController.h
//  JCTiledViewDemo
//
//  Created by Jesse Collis
//  Copyright (c) 2012 JC Multimedia Design. All rights reserved.
//

#import "JCTiledScrollView.h"
#import "Area.h"
#import "CustomAnnotationView.h"


@class DetailView, JCTiledScrollView;

@interface RootViewController : UIViewController <JCTileSource, JCTiledScrollViewDelegate>

@property (weak, nonatomic) IBOutlet CustomAnnotationView *callout;
@property (strong, nonatomic) JCTiledScrollView *scrollView;
@property (strong, nonatomic) DetailView *detailView;
@property (strong, nonatomic) Area *area;



@end
