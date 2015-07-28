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


#define GroundFloorImageSize CGSizeMake(707., 500.)
#define MAX_ZOOM_LEVEL 8.

#ifdef ANNOTATE_TILES
#import "JCTiledView.h"
#endif

@interface RootViewController () <ESTBeaconManagerDelegate>
// 3. Add properties to hold the beacon manager and the beacon region
@property (nonatomic) ESTBeaconManager *beaconManager;
@property (nonatomic) CLBeaconRegion *beaconRegion;

@property (nonatomic) NSDictionary *placesByBeacons;

@end

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
    
    
      self.placesByBeacons = @{
        @"6574:54631": @{
            @"Heavenly Sandwiches": @50, // read as: it's 50 meters from
                                         // "Heavenly Sandwiches" to the beacon with
                                         // major 6574 and minor 54631
            @"Green & Green Salads": @150,
            @"Mini Panini": @325
        },
        @"31179:43808": @{
            @"Heavenly Sandwiches": @250,
            @"Green & Green Salads": @100,
            @"Mini Panini": @20
        },
        @"51613:27600": @{
            @"Heavenly Sandwiches": @350,
            @"Green & Green Salads": @500,
            @"Mini Panini": @170
        }
    };
    
    // 4. Instantiate the beacon manager & set its delegate
    self.beaconManager = [ESTBeaconManager new];
    self.beaconManager.delegate = self;
    // 5. Instantiate the beacon region
      CLBeaconRegion *lightGreen = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]
        initWithUUIDString:@"b9407f30-f5f8-466e-aff9-25556b57fe6d"]
     identifier:@"monitored region"];
    
    self.beaconRegion = lightGreen;
    // 6. We need to request this authorization for every beacon manager
    [self.beaconManager requestAlwaysAuthorization];
    
    
    
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
    
    NSArray *coords = [self.area.location componentsSeparatedByString:@","];
    
    CGFloat x = [coords[0] doubleValue];
    CGFloat y =  [coords[1] doubleValue];
    
    
    
   
    x = x/MAX_ZOOM_LEVEL;
    y = y/MAX_ZOOM_LEVEL;
    
    //[self.scrollView moveToPointX:x andY:y atZoomLevel:3.0f];
    
    
    id<JCAnnotation> a = [[DemoAnnotation alloc] init];
    a.contentPosition = CGPointMake(x,y );
    [self.scrollView addAnnotation:a];
    self.scrollView.zoomScale = 6;
      [self.scrollView setContentCenter:CGPointMake(x, y) animated:YES];
    
    //[self addRandomAnnotations];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
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


- (NSArray *)placesNearBeacon:(CLBeacon *)beacon {
    NSString *beaconKey = [NSString stringWithFormat:@"%@:%@",
                           beacon.major, beacon.minor];
    NSDictionary *places = [self.placesByBeacons objectForKey:beaconKey];
    NSArray *sortedPlaces = [places keysSortedByValueUsingComparator:
                             ^NSComparisonResult(id obj1, id obj2) {
                                 return [obj1 compare:obj2];
                             }];
    return sortedPlaces;
}

- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons
             inRegion:(CLBeaconRegion *)region {
    CLBeacon *nearestBeacon = beacons.firstObject;
    if (nearestBeacon) {
        NSArray *places = [self placesNearBeacon:nearestBeacon];
        // TODO: update the UI here
        NSLog(@"%@", nearestBeacon); // TODO: remove after implementing the UI
    }
}



@end
