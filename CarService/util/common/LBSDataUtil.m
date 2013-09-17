//
//  LBSDataUtil.m
//  iGuanZhong
//
//  Created by zhouochengyu on 13-8-17.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//
#import "LBSDataUtil.h"

static LBSDataUtil *shareLbsUtil = nil;

@interface LBSDataUtil()

- (void)geoCodeLocation:(CLLocation *)location;
- (void)locationManagerFinished;

@end


@implementation LBSDataUtil
@synthesize currentLocation;
@synthesize locationManager;
@synthesize locationManagerTimer;
@synthesize locationRefreshTimer;
@synthesize errorCode;
@synthesize address;
@synthesize bmkSearch;

+ (LBSDataUtil *)shareUtil
{
    if (nil == shareLbsUtil)
    {
        shareLbsUtil = [[LBSDataUtil alloc] init];
    }
    return shareLbsUtil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [self startCollectionLocation];
        errorCode = LocationErrorCode_NoError;
        self.address = @"地理位置未知";
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [currentLocation release];
    [locationManager release];
    [locationManagerTimer invalidate];
    [locationManagerTimer release];
    [locationRefreshTimer invalidate];
    [locationRefreshTimer release];
    [address release];
    [bmkSearch release];
    [super dealloc];
}

- (void)appForeground
{
    [self startCollectionLocation];
}

- (void) startCollectionLocation{
    
    if (self.locationManagerTimer != nil) {
        //正在采集数据
        return;
    }
    if (![CLLocationManager locationServicesEnabled]) {
        //定位总开关关闭
        self.currentLocation = nil;
        errorCode = LocationErrorCode_UserDenied;
        [self locationManagerFinished];
        return;
    }
    
    if (self.locationManager == nil) {
        CLLocationManager *aLocationManager = [[CLLocationManager alloc] init];
        aLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager = aLocationManager;
        [aLocationManager release];
        
    }
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
}

- (void)geoCodeLocation:(CLLocation *)location
{
    self.bmkSearch = [[[BMKSearch alloc]init]autorelease];
    self.bmkSearch.delegate = self;
    //发起反地理编码
    [self.bmkSearch reverseGeocode:location.coordinate];
}



- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
    // 在此处添加您对反地理编码结果的处理
    CustomLog(@"address:%@,error:%d",result,error);
    CustomLog(@"address%@",result.strAddr);
    if (error == 0)
    {
        self.address = result.strAddr;
    }
}

- (void)locationManagerFinished{
    //先关闭定位，防止函数重入
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    
    //关闭5s定时器
    [self.locationManagerTimer invalidate];
    self.locationManagerTimer = nil;
    
    [self geoCodeLocation:currentLocation];

    NSInteger refreshInterval = 3 * 60 * 60;
    [self.locationRefreshTimer invalidate];
    self.locationRefreshTimer = nil;
    if (errorCode == LocationErrorCode_UserDenied)
    {
        //应该关闭定时器
        CustomLog(@"Do nothing");
    }
    else
    {
        self.locationRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshInterval
                                                                     target:self
                                                                   selector:@selector(refreshLocation)
                                                                   userInfo:nil
                                                                    repeats:NO];
    }
}

- (void) refreshLocation
{
    [self startCollectionLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (oldLocation == nil) {
        [self.locationManagerTimer invalidate];
        self.locationManagerTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                                     target:self
                                                                   selector:@selector(locationManagerFinished)
                                                                   userInfo:nil
                                                                    repeats:NO];
        
    }
    CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    self.currentLocation = tempLocation;
    [tempLocation release];
    
    [self geoCodeLocation:self.currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        //用户关闭location，清空位置
        self.currentLocation = nil;
        errorCode = LocationErrorCode_UserDenied;
    }
    else {
        
        self.currentLocation = nil;
        errorCode = LocationErrorCode_OtherReason;
    }

    [self locationManagerFinished];
}

@end
