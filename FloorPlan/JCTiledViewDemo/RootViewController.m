//
//  RootViewController.m
//  JCTiledViewDemo
//
//  Created by Jesse Collis
//  Copyright (c) 2012 JC Multimedia Design. All rights reserved.
//

#import "RootViewController.h"
#import "JCTiledPDFScrollView.h"
#import "DemoAnnotationView.h"
#import "DemoAnnotation.h"
#import "math.h"
#import "DetailView.h"


#define GroundFloorImageSize CGSizeMake(707., 500.)

#ifdef ANNOTATE_TILES
#import "JCTiledView.h"
#endif

@implementation RootViewController


#pragma mark - View lifecycle
/*
- (void)loadView
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  self.view = view;
}*/


- (void)viewDidLoad {

  [super viewDidLoad];
  self.detailView = [[DetailView alloc] initWithFrame:CGRectZero];
  self.detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  CGSize size_for_detail = [self.detailView sizeThatFits:self.view.bounds.size];
  [self.detailView setFrame:CGRectMake(0.f,0.f,size_for_detail.width,size_for_detail.height)];
  [self.view addSubview:self.detailView];

  CGRect scrollView_frame = CGRectOffset(CGRectInset(self.view.bounds,0.,size_for_detail.height/2.0f),0.,size_for_detail.height/2.0f);

  //PDF
  //self.scrollView = [[JCTiledPDFScrollView alloc] initWithFrame:scrollView_frame URL:[[NSBundle mainBundle] URLForResource:@"Map" withExtension:@"pdf"]];

  //Bitmap
  self.scrollView = [[JCTiledScrollView alloc] initWithFrame:scrollView_frame contentSize:GroundFloorImageSize];

  self.scrollView.dataSource = self;
  self.scrollView.tiledScrollViewDelegate = self;
  self.scrollView.zoomScale = 3.0f;

#ifdef ANNOTATE_TILES
  self.scrollView.tiledView.shouldAnnotateRect = NO;
#endif
  
  // totals 4 sets of tiles across all devices, retina devices will miss out on the first 1x set
  self.scrollView.levelsOfZoom = 3;
  self.scrollView.levelsOfDetail = 3;

  [self.view addSubview:self.scrollView];
  
  UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [addButton setTitle:@"+ Annotations" forState:UIControlStateNormal];
  addButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 115, 25., 110, 38);
  addButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  [addButton addTarget:self action:@selector(addRandomAnnotations) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:addButton];

  [self tiledScrollViewDidZoom:self.scrollView]; //force the detailView to update the frist time
  
  
  CGFloat x = 5073.129808;
  CGFloat y = 3745.075892;
  [self.scrollView moveToPointX:x andY:y atZoomLevel:3.0f];
  [self addRandomAnnotations];
}

- (void)viewDidUnload
{
  _scrollView = nil;
  _detailView = nil;

  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self.scrollView refreshAnnotations];
  
  [self becomeFirstResponder];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

#pragma mark - Responder

- (BOOL)canBecomeFirstResponder
{
  return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
  {
    [self.scrollView removeAllAnnotations];
  }
}

#pragma mark - Annotations

- (void)addRandomAnnotations
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    srand(42);
  });

  CGSize size = GroundFloorImageSize;
  for (int i = 0; i < 5; i++)
  {
    id<JCAnnotation> a = [[DemoAnnotation alloc] init];
    a.contentPosition = CGPointMake((float)(rand() % (int)size.width), (float)(rand() % (int)size.height));
    [self.scrollView addAnnotation:a];
  }
}

#pragma mark - JCTiledScrollViewDelegate

- (void)tiledScrollViewDidZoom:(JCTiledScrollView *)scrollView
{
  self.detailView.textLabel.text = [NSString stringWithFormat:@"zoomScale: %0.2f", scrollView.zoomScale];
}

- (void)tiledScrollView:(JCTiledScrollView *)scrollView didReceiveSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
  CGPoint tapPoint = [gestureRecognizer locationInView:(UIView *)scrollView.tiledView];

  //tap point on the tiledView does not inlcude the zoomScale applied by the scrollView
  self.detailView.textLabel.text = [NSString stringWithFormat:@"zoomScale: %0.2f, x: %0.0f y: %0.0f", scrollView.zoomScale, tapPoint.x, tapPoint.y];
}

- (JCAnnotationView *)tiledScrollView:(JCTiledScrollView *)scrollView viewForAnnotation:(id<JCAnnotation>)annotation
{
  NSString static *reuseIdentifier = @"JCAnnotationReuseIdentifier";
  DemoAnnotationView *view = (DemoAnnotationView *)[scrollView dequeueReusableAnnotationViewWithReuseIdentifier:reuseIdentifier];

  if (!view)
  {
    view = [[DemoAnnotationView alloc] initWithFrame:CGRectZero annotation:annotation reuseIdentifier:@"Identifier"];
    view.imageView.image = [UIImage imageNamed:@"marker-red.png"];
    [view sizeToFit];
  }

  return view;
}

#pragma mark - JCTileSource

#define GroundFLoorImageName @"gf"

- (UIImage *)tiledScrollView:(JCTiledScrollView *)scrollView imageForRow:(NSInteger)row column:(NSInteger)column scale:(NSInteger)scale
{
 return [UIImage imageNamed:[NSString stringWithFormat:@"tiles/%@_%ldx_%ld_%ld.png", GroundFLoorImageName, (long)scale, (long)column, (long)row]];
}

- (void)tiledScrollView:(JCTiledScrollView *)scrollView didSelectAnnotationView:(JCAnnotationView *)view{
    NSLog(@" view %@", view );

}




@end
