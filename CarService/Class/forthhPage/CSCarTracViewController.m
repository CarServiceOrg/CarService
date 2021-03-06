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
@property (nonatomic,retain) IBOutlet UIView *contentBackView;
@property (nonatomic,retain) NSDictionary *daiWeiInfo;

@end

@implementation CSCarTracViewController
@synthesize locationLabel;
@synthesize mapView;
@synthesize contentBackView;
@synthesize daiWeiInfo;

- (id)initWithDaiWeiInfo:(NSDictionary *)infoDic
{
    self = [super initWithNibName:@"CSCarTracViewController" bundle:nil];
    if (self)
    {
        self.daiWeiInfo = infoDic;
    }
    return self;
}

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
    [daiWeiInfo release];
    [locationLabel release];
    [mapView release];
    [contentBackView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"车辆追踪";
    
    if (nil != self.daiWeiInfo)
    {
        self.locationLabel.text = [[self.daiWeiInfo objectForKey:@"list"] objectForKey:@"address"];
    }
    else if (nil != [LBSDataUtil shareUtil].address)
    {
        self.locationLabel.text = [LBSDataUtil shareUtil].address;
    }
    else
    {
        self.locationLabel.text = @"";
        [[LBSDataUtil shareUtil] refreshLocation];
    }
    
    self.mapView = [[[BMKMapView alloc] initWithFrame:CGRectMake(8, 48, 285, 352)]autorelease];
    [self.contentBackView addSubview:self.mapView];
    if (nil != self.daiWeiInfo)
    {
        [self.mapView setShowsUserLocation:NO];
        CLLocationCoordinate2D cordinate ;
        cordinate.latitude = [[[self.daiWeiInfo objectForKey:@"list"] objectForKey:@"lat"] doubleValue];
        cordinate.longitude = [[[self.daiWeiInfo objectForKey:@"list"] objectForKey:@"lon"] doubleValue];

        [self.mapView setCenterCoordinate:cordinate animated:YES];
        [self.mapView setRegion:BMKCoordinateRegionMake(cordinate, BMKCoordinateSpanMake(span, span))];
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = cordinate;
        [mapView addAnnotation:annotation];
        [annotation release];
    }
    else if (nil != [LBSDataUtil shareUtil].currentLocation)
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
