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
#import <EstimoteSDK/EstimoteSDK.h>
#import <MediaPlayer/MediaPlayer.h>
#import "JCAppDelegate.h"
#import "FloorPlanBeaconRanging.h"


#define GroundFloorImageSize CGSizeMake(707., 500.)
#define MAX_ZOOM_LEVEL 8.

#ifdef ANNOTATE_TILES
#import "JCTiledView.h"
#endif

@interface RootViewController () <ESTBeaconManagerDelegate>
// 3. Add properties to hold the beacon manager and the beacon region


@property (strong) FloorPlanBeaconRanging * floorPlanRanging;
- (void)moveToArea:(Area *) area;


@end

@implementation RootViewController


#pragma mark - View lifecycle
- (void)moveToArea:(Area *) area {
    self.area = area;
    NSArray *coords = [area.location componentsSeparatedByString:@","];
    
    CGFloat x = [coords[0] doubleValue];
    CGFloat y =  [coords[1] doubleValue];
    
    
    
    
    x = x/MAX_ZOOM_LEVEL;
    y = y/MAX_ZOOM_LEVEL;
    
    //[self.scrollView moveToPointX:x andY:y atZoomLevel:3.0f];
    
    
    id<JCAnnotation> a = [[DemoAnnotation alloc] init];
    a.contentPosition = CGPointMake(x,y );
    [self.scrollView addAnnotation:a];
    //self.scrollView.zoomScale = 6;
    [self.scrollView setContentCenter:CGPointMake(x, y) animated:YES];
    [self.scrollView moveToPointX:x andY:y atZoomLevel:6];
}

/*
 - (void)loadView
 {
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
 view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
 self.view = view;
 }*/



- (void)viewDidLoad {
    
    [super viewDidLoad];

    

    //sort areas key on beacon.
    self.floorPlanRanging = [JCAppDelegate appDelegate].floorPlanRanging;

    
    
    self.detailView = [[DetailView alloc] initWithFrame:CGRectZero];
    self.detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGSize size_for_detail = [self.detailView sizeThatFits:self.view.bounds.size];
    [self.detailView setFrame:CGRectMake(0.f,0.f,size_for_detail.width,size_for_detail.height)];
    [self.view addSubview:self.detailView];
    
    CGRect scrollView_frame = CGRectOffset(CGRectInset(self.view.bounds,0.,size_for_detail.height/2.0f),0.,size_for_detail.height/2.0f);
    

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
    

    
    [self tiledScrollViewDidZoom:self.scrollView]; //force the detailView to update the frist time
    
    [self moveToArea:self.area];
   
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    JCAppDelegate *appDelegate = [JCAppDelegate appDelegate];
    
    appDelegate.beaconManager.delegate = self;

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
   
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
    Area *a = self.area;
    
    if (!view)
    {
        view = [[DemoAnnotationView alloc] initWithFrame:CGRectZero annotation:annotation reuseIdentifier:@"Identifier" withView: self.callout];
        self.callout.title.text = a.title;
        self.callout.title.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
        self.callout.details.text = a.desc;
        self.callout.imageIcon.image = a.image;
        view.button = self.callout.moreInfoButton;
        view.imageButton = self.callout.imageIcon;
        
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
   
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:self.area.video ofType:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];

    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [self presentMoviePlayerViewControllerAnimated:movieController];
    [movieController.moviePlayer play];
}


- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons
             inRegion:(CLBeaconRegion *)region {
    CLBeacon *nearestBeacon = beacons.firstObject;
    NSString *beaconKey = [NSString stringWithFormat:@"%@", nearestBeacon.minor];
    NSLog(@"nearest beacon  %@", beaconKey);
    if (nearestBeacon) {
        Area *area = [self.floorPlanRanging areaForBeacon:nearestBeacon];
        
        NSLog(@"%@", area.title); // TODO: remove after implementing the UI
        
        NSLog(@"%@", self.area.title);
        if (area!= nil && !area.hasVisited && self.area != area) {
            area.hasVisited = YES;
                            
                        UIAlertController *alertController = [UIAlertController
                              alertControllerWithTitle:@"Entered Region"
                              message:area.title
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
                        
                        
                        // Delay execution of my block for 10 seconds.
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self moveToArea:area];
});
                        NSLog(@"OK action");
                    }];

[alertController addAction:cancelAction];
[alertController addAction:okAction];
 [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }
}






@end
