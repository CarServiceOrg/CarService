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
    //背景
    [ApplicationPublic selfDefineBg:self.view];
    //标题栏
    [ApplicationPublic selfDefineNavigationBar:self.view title:@"参考格式" withTarget:self with_action:@selector(backBtnClick:)];
    
    //滚动视图
    CGRect frame=CGRectMake(10, DiffY+44+4, [UIScreen mainScreen].bounds.size.width-10*2, CSTabelViewHeight);
    UIImageView* tabviewBg=[[UIImageView alloc] initWithFrame:frame];
    [tabviewBg setImage:[ApplicationPublic getOriginImage:@"new_xiaofeijilu_liebiaoxinxi_toumingbeijing.png" withInset:UIEdgeInsetsMake(40, 40, 40, 40)]];
    tabviewBg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:tabviewBg];
    [tabviewBg release];

    //滚动视图
    UIScrollView* scrollView=[[UIScrollView alloc] initWithFrame:frame];
    [scrollView setTag:101];
    [scrollView setDelegate:self];
    scrollView.minimumZoomScale=1.0;
    scrollView.maximumZoomScale=3.0;
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.showsVerticalScrollIndicator=YES;
    [self.view addSubview:scrollView];
    [scrollView release];
    {
        UIImage* image=[UIImage imageWithCGImage:[UIImage imageNamed:@"shigubaoan_cankaogeshi.png"].CGImage scale:2.0 orientation:UIImageOrientationUp];
        UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, image.size.height)];
        [imgView setTag:1001];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setImage:image];
        [scrollView addSubview:imgView];
        [imgView release];
        
        scrollView.contentSize=CGSizeMake(scrollView.bounds.size.width, image.size.height);
    }
    {
//        for(UIView* subview in scrollView.subviews){
//            [subview removeFromSuperview];
//        }
//        
//        x=0; y=0; width=140; height=140;
//        [self setUpPageView:CGRectMake(x, y, width, height) with_img:[UIImage imageNamed:@"shigubaoan_cankaogeshi_01.png"]
//                  with_text:@"远景要能看清车辆所处的位置、标志线等"];
//     
//        x=x+width+10;
//        [self setUpPageView:CGRectMake(x, y, width, height) with_img:[UIImage imageNamed:@"shigubaoan_cankaogeshi_02.png"]
//                  with_text:@"中景要能看清车辆车型特征等"];
//
//        x=0; y=y+height+15;
//        [self setUpPageView:CGRectMake(x, y, width, height) with_img:[UIImage imageNamed:@"shigubaoan_03.png"]
//                  with_text:@"近景要拍摄清楚碰撞的部位"];
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

#pragma mark - UIScrollViewDelegate
// return a view that will be scaled. if delegate returns nil, nothing happens
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView* imgView=(UIImageView*)[scrollView viewWithTag:1001];
    if (imgView) {
        return imgView;
    }
    return nil;
}


@end
