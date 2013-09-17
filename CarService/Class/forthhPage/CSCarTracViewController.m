//
//  CSCarTracViewController.m
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSCarTracViewController.h"
#import "LBSDataUtil.h"
#define span 40000

@interface CSCarTracViewController ()

@property (nonatomic,retain) IBOutlet UILabel *locationLabel;
@property (nonatomic,retain) IBOutlet BMKMapView *mapView;

@end

@implementation CSCarTracViewController
@synthesize locationLabel;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [locationLabel release];
    [mapView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"车辆追踪";
    
    if (nil != [LBSDataUtil shareUtil].address)
    {
        self.locationLabel.text = [LBSDataUtil shareUtil].address;
    }
    else
    {
        self.locationLabel.text = @"北京市";
        [[LBSDataUtil shareUtil] refreshLocation];
    }
    
    self.mapView = [[[BMKMapView alloc] initWithFrame:CGRectMake(0, 32, 320, self.view.frame.size.height - 32)]autorelease];
    [self.view addSubview:self.mapView];
    if (nil != [LBSDataUtil shareUtil].currentLocation)
    {
        [self.mapView setShowsUserLocation:NO];
        [self.mapView setCenterCoordinate:[LBSDataUtil shareUtil].currentLocation.coordinate animated:YES];
        [self.mapView setRegion:BMKCoordinateRegionMake([LBSDataUtil shareUtil].currentLocation.coordinate, BMKCoordinateSpanMake(span, span))];
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = [LBSDataUtil shareUtil].currentLocation.coordinate;
        [mapView addAnnotation:annotation];
        [annotation release];
    }
    else
    {
        [self.mapView setShowsUserLocation:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        //newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.image = [UIImage imageNamed:@"cartrac_location.png"];
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
@end
