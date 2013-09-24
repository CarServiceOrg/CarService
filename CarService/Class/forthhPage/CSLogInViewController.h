//
//  LogInViewController.h
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "CommonViewController.h"

@protocol  CSLogInViewController_Delegate <NSObject>
-(void)loginFinishCallBack:(NSString*)flagStr;
@end


@interface CSLogInViewController : CommonViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    
}

@property (nonatomic,assign) UIViewController *parentController;
@property(nonatomic, assign)id<CSLogInViewController_Delegate> delegate;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
- (IBAction)remeberPasswordButtonPressed:(id)sender;

//初始化函数
- (id)initWithParentCtrler:(UIViewController*)viewCtrler witjFlagStr:(NSString*)aStr with_NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
