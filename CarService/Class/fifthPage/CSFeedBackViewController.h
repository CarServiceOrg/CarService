//
//  CSFeedBackViewController.h
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

typedef enum
{
    ControllerType_FeedBack,
    ControllerType_IWannaRate
}ControllerType;

@interface CSFeedBackViewController : CommonViewController <UIGestureRecognizerDelegate>

- (id)initWithOrderInfo:(NSDictionary *)orderInfo;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)confirmButtonPressed:(id)sender;


@end
