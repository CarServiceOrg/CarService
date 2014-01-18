//
//  CSCarTracViewController.h
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "BMapKit.h"

@interface CSCarTracViewController : CommonViewController<BMKMapViewDelegate>

- (id)initWithDaiWeiInfo:(NSDictionary *)infoDic;

@end
