//
//  ViewController.m
//  Polygon
//
//  Created by Hefang Li on 4/15/15.
//  Copyright (c) 2015 hefang. All rights reserved.
//

#import "ViewController.h"
#import "PolygonView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PolygonView *avatarViewOutletFromLocalImage;
@property (weak, nonatomic) IBOutlet PolygonView *avatarViewOutletFromDownloadedImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Test the view created programmatically with local image
    PolygonView *avatarViewFromLocalImage = [[PolygonView alloc] initWithFrame:CGRectMake(8, 8, 100, 100) imageNamed:@"example_icon" numberOfSides:8 lineWidth:4 lineColor:[UIColor blueColor]];
    
    // Test the view created programmatically with downloaded image
    PolygonView *avatarViewFromDownloadedImage = [[PolygonView alloc] initWithFrame:CGRectMake(118, 8, 100, 100) imageURL:@"http://www.greatindiannews.com/wp-content/uploads/2015/02/angelina-jolie.jpg" numberOfSides:6 lineWidth:5 lineColor:[UIColor whiteColor]];
    
    // Test the view loaded from an Interface Builder nib file with local image
    [_avatarViewOutletFromLocalImage configureWithImageNamed:@"example_icon" numberOfSides:5 lineWidth:8 lineColor:[UIColor greenColor]];
    
    // Test the view loaded from an Interface Builder nib file with downloaded image
    [_avatarViewOutletFromDownloadedImage configureWithImageURL:@"http://www.greatindiannews.com/wp-content/uploads/2015/02/angelina-jolie.jpg" numberOfSides:7 lineWidth:10 lineColor:[UIColor orangeColor]];
    
    [self.view addSubview:avatarViewFromLocalImage];
    [self.view addSubview:avatarViewFromDownloadedImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
