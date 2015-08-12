//
//  DetailViewController.m
//  FloorPlanIOS
//
//  Created by murrayhking on 12/08/2015.
//  Copyright (c) 2015 JC Multimedia Design. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)playMovie:(id)sender
{
    VideoView *videoView = [[VideoView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    //[moviePlayer.view setFrame:CGRectMake(0, 0, 320, 476)];
    [moviePlayer.view setFrame:videoView.bounds];
    [videoView addSubview:moviePlayer.view];
    
    [moviePlayer prepareToPlay];
    [moviePlayer play];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
