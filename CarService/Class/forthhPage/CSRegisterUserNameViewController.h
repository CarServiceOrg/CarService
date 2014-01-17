//
//  RegisterUserNameViewController.h
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "CommonViewController.h"

@interface CSRegisterUserNameViewController : CommonViewController <UIScrollViewDelegate,UITextFieldDelegate>

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

@end
