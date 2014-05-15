//
//  CSHeartServiceViewController.h
//  CarService
//
//  Created by baidu on 14-5-15.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface CSHeartServiceViewController : CommonViewController<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property  (nonatomic,retain) IBOutlet UIView *backView;
@property  (nonatomic,retain) IBOutlet UIScrollView *backScrollView;
@property  (nonatomic,retain) IBOutlet UITextField *textFiled1;
@property  (nonatomic,retain) IBOutlet UITextField *textFiled2;
@property  (nonatomic,retain) IBOutlet UITextField *textFiled3;
@property  (nonatomic,retain) IBOutlet UITextField *textFiled4;
@property  (nonatomic,retain) IBOutlet UITextField *textFiled5;

@end
