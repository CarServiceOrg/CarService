//
//  LogInViewController.h
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "CommonViewController.h"
@class CSForthViewController;

@interface CSLogInViewController : CommonViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate>

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
- (IBAction)remeberPasswordButtonPressed:(id)sender;

@property (nonatomic,assign) CSForthViewController *parentController;

@end
