//
//  LBSDataUtil.h
//  iGuanZhong
//
//  Created by zhouochengyu on 13-8-17.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BMapKit.h"

@interface LBSDataUtil : NSObject <CLLocationManagerDelegate,BMKSearchDelegate>
{
    CLLocation *currentLocation;
    CLLocationManager *locationManager;
    NSTimer *locationManagerTimer;
    NSTimer *locationRefreshTimer;
    LocationErrorCode errorCode;
    BMKSearch *bmkSearch;
    //查询位置信息
}

@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic,retain) NSTimer *locationManagerTimer;
@property (nonatomic,retain) NSTimer *locationRefreshTimer;
@property (nonatomic,assign) LocationErrorCode errorCode;
@property (nonatomic,retain) BMKSearch *bmkSearch;
//查询位置信息
@property (nonatomic,retain) NSString *address;

+ (LBSDataUtil *)shareUtil;
- (void) refreshLocation;

@end
