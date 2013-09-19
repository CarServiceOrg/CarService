//
//  CSExampleReferViewController.m
//  CarService
//
//  Created by baidu on 13-9-19.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSExampleReferViewController.h"

@interface CSExampleReferViewController () <UIScrollViewDelegate>{
    
}

@end

@implementation CSExampleReferViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)init_selfView
{
    float x, y, width, height;
    
    [ApplicationPublic setUp_BackBtn:self.navigationItem withTarget:self with_action:@selector(backBtnClick:)];
    
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
    
    x=15; y=15; width=320-x*2; height=self.view.bounds.size.height-40-55-y*2;
     //滚动视图
    UIScrollView* scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [scrollView setTag:101];
    [scrollView setDelegate:self];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.pagingEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    [scrollView release];
    {
        for(UIView* subview in scrollView.subviews){
            [subview removeFromSuperview];
        }
        
        x=0; y=0; width=140; height=140;
        [self setUpPageView:CGRectMake(x, y, width, height) with_img:[UIImage imageNamed:@"shigubaoan_cankaogeshi_01.png"]
                  with_text:@"远景要能看清车辆所处的位置、标志线等"];
     
        x=x+width+10;
        [self setUpPageView:CGRectMake(x, y, width, height) with_img:[UIImage imageNamed:@"shigubaoan_cankaogeshi_02.png"]
                  with_text:@"中景要能看清车辆车型特征等"];

        x=0; y=y+height+15;
        [self setUpPageView:CGRectMake(x, y, width, height) with_img:[UIImage imageNamed:@"shigubaoan_03.png"]
                  with_text:@"近景要拍摄清楚碰撞的部位"];

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    self.title=@"参考格式";
    [self init_selfView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 本地函数
-(void)setUpPageView:(CGRect)frame with_img:(UIImage*)image with_text:(NSString*)text{
    UIScrollView* scrollView=(UIScrollView*)[self.view viewWithTag:101];
    if (scrollView) {
        
        UIView* pageView=[[UIView alloc] initWithFrame:frame];
        [pageView setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:pageView];
        [pageView release];
        
        UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width-2*2, 100)];
        [imgView setBackgroundColor:[UIColor clearColor]];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setImage:image];
        [pageView addSubview:imgView];
        [imgView release];
        
        UILabel* aLabel=[[UILabel alloc] initWithFrame:CGRectMake(2, 100, frame.size.width-2*2, 40)];
        [aLabel setBackgroundColor:[UIColor clearColor]];
        [aLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [aLabel setTextAlignment:NSTextAlignmentLeft];
        [aLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [aLabel setTextColor:[UIColor blackColor]];
        [aLabel setText:text];
        aLabel.numberOfLines=0;
        aLabel.lineBreakMode=UILineBreakModeWordWrap;
        [pageView addSubview:aLabel];
        [aLabel release];
    }
}

#pragma mark - 点击事件
-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
