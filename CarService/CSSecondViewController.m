//
//  CSSecondViewController.m
//  CarService
//
//  Created by Chao on 13-9-12.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSSecondViewController.h"

@interface CSSecondViewController ()<UITextFieldDelegate>
{
    
}

@end

@implementation CSSecondViewController

-(void)init_NaviView
{
    //设置导航栏背景
    UIImageView* naviImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [naviImgView setImage:[UIImage imageWithCGImage:[[UIImage imageNamed:@"navi_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10].CGImage scale:2.0 orientation:UIImageOrientationUp]];
    [self.navigationController.navigationBar addSubview:naviImgView];
    [naviImgView release];
    
    //标题
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"违章查询"];
    [self.navigationController.navigationBar addSubview:titleLabel];
    [titleLabel release];
}

-(void)setUp_UITextField:(UIView*)superView with_frame:(CGRect)frame with_tag:(int)tag with_placeHolder:(NSString*)placeHolderStr
{
    UITextField* aTextField=[[UITextField alloc] initWithFrame:frame];
    if (tag>0) {
        aTextField.tag=tag;
    }
    [aTextField setTextAlignment:NSTextAlignmentLeft];
    [aTextField setBackground:[[UIImage imageNamed:@"black_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [aTextField setBackgroundColor:[UIColor clearColor]];
    [aTextField setTextColor:[UIColor whiteColor]];
    [aTextField setFont:[UIFont systemFontOfSize:14.0]];
    [aTextField setPlaceholder:placeHolderStr];
    {
        aTextField.delegate = self;//设置delegate为自己,不然按下Done键键盘消失不了
        aTextField.returnKeyType = UIReturnKeyDone; //设置键盘返回形式
        aTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //输入内容后会显示个X
        aTextField.keyboardType = UIKeyboardTypeDefault; //键盘显示类型
        aTextField.autocorrectionType = UITextAutocorrectionTypeNo; //是否自动提醒功能
        aTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; //设置输入方式
        aTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;  //自适应宽度
    }
    [superView addSubview:aTextField];
    [aTextField release];
}

-(void)init_selfView
{
    float x, y, width, height;
    x=0; y=0; width=320;
    if (Is_iPhone5) {
        height=1136/2.0;
    }else{
        height=960/2.0;
    }
    //背景
    UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    if (Is_iPhone5) {
        [bgImageView setImage:[UIImage imageNamed:@"bg_iphone5.png"]];
    }else{
        [bgImageView setImage:[UIImage imageNamed:@"bg_iphone4.png"]];
    }
    [self.view addSubview:bgImageView];
    [bgImageView release];

    //车牌号
    x=10; y=20; width=320-10*2; height=40;
    [self setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:@"车牌号："];
    
    //发动机号
    y=y+height+15;
    [self setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:102 with_placeHolder:@"发动机号："];

    //查询
    width=133/2.0+20; height=48/2.0+10; x=(320-width)/2.0; y=y+height+30;
    UIButton* queryBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [queryBtn setTitle:@"查 询" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"chaoxun_btn.png"] forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:[UIImage imageNamed:@"chanxun_btn_press.png"] forState:UIControlStateHighlighted];
    [queryBtn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryBtn];
    [queryBtn release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
	// Do any additional setup after loading the view, typically from a nib.
    [self init_NaviView];
    [self init_selfView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
-(void)queryBtnClick:(id)sender
{
    
}

#pragma mark - UITextFieldDelegate
//按Done键键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField* aTextField=(UITextField*)[self.view viewWithTag:101];
    UITextField* bTextField=(UITextField*)[self.view viewWithTag:102];
    if ([aTextField isFirstResponder] || [bTextField isFirstResponder]) {
        [aTextField resignFirstResponder];
        [bTextField resignFirstResponder];
    }
}

@end
