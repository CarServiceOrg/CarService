//
//  CSReportCaseViewController.m
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSReportCaseViewController.h"

@interface CSReportCaseViewController ()

@end

@implementation CSReportCaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)init_selfView
{
    float x, y, width, height;
    
    //隐藏返回键
    self.navigationItem.hidesBackButton=YES;
    //返回按钮
    x=10; y=8; width=82/2.0+4; height=26;
    UIButton* backBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [backBtn setTitleColor:[UIColor colorWithRed:13/255.0 green:43/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    [backBtn release];
    
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
    [self.view sendSubviewToBack:bgImageView];
    [bgImageView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    self.title=@"事故报告";
    [self init_selfView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
