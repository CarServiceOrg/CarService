//
//  CSFirstViewController.m
//  CarService
//
//  Created by Chao on 13-9-12.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSFirstViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CSFirstViewController ()

@end

@implementation CSFirstViewController

#pragma mark - view lifecycle
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
    [titleLabel setText:@"首页"];
    [self.navigationController.navigationBar addSubview:titleLabel];
    [titleLabel release];
    
    //信息按钮
    UIButton* msgBtn=[[UIButton alloc] initWithFrame:CGRectMake(320-30-10, (40-46/2.0)/2.0, 60/2.0, 46/2.0)];
    [msgBtn setImage:[UIImage imageNamed:@"shouye_msg.png"] forState:UIControlStateNormal];
    [msgBtn setImage:[UIImage imageNamed:@"shouye_msg_press.png"] forState:UIControlStateHighlighted];
    [msgBtn addTarget:self action:@selector(msgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:msgBtn];
    [msgBtn release];
    
    //消息数
    UILabel* numLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    [numLabel setCenter:CGPointMake(CGRectGetMaxX(msgBtn.frame)-5, CGRectGetMinY(msgBtn.frame)+5)];
    [numLabel setBackgroundColor:[UIColor clearColor]];
    [numLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [numLabel setTextAlignment:NSTextAlignmentCenter];
    [numLabel setFont:[UIFont systemFontOfSize:8]];
    [numLabel setTextColor:[UIColor whiteColor]];
    [numLabel setText:@"3"];
    numLabel.layer.cornerRadius=CGRectGetWidth(numLabel.frame)/2.0;
    numLabel.layer.borderWidth=1.0;
    numLabel.layer.borderColor=[UIColor clearColor].CGColor;
    [self.navigationController.navigationBar addSubview:numLabel];
    [numLabel release];
}

-(void)setUpLabel:(UIView*)superView with_tag:(int)tag with_frame:(CGRect)frame with_text:(NSString*)text with_Alignment:(NSTextAlignment)alignment
{
    UILabel* aLabel=[[UILabel alloc] initWithFrame:frame];
    if (tag>=0) {
        [aLabel setTag:tag];
    }
    [aLabel setBackgroundColor:[UIColor clearColor]];
    [aLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [aLabel setTextAlignment:alignment];
    [aLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [aLabel setTextColor:[UIColor whiteColor]];
    [aLabel setText:text];
    [superView addSubview:aLabel];
    [aLabel release];
}

-(void)init_scrollView
{
    float x, y, width, height;
    x=10; y=0; width=320-10*2; height=40+278/2+15.0+20+243/2.0;
    UIScrollView* scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [scrollView setTag:101];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    //添加内容视图
    x=0; y=40; height=278/2.0+15;
    UIView* weatherView=[[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    weatherView.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:weatherView];
    [weatherView release];
    {
        float x, y, width, height;
        //背景
        x=0; y=0; width=320-10*2; height=278/2.0+15;
        UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [bgImageView setImage:[UIImage imageNamed:@"shouye_tianqi_bg.png"]];
        [weatherView addSubview:bgImageView];
        [bgImageView release];
        
        //定位图标
        x=10; y=15; width=17/2.0; height=23/2.0;
        UIImageView* locationImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [locationImgView setImage:[UIImage imageNamed:@"shouye_location.png"]];
        [weatherView addSubview:locationImgView];
        [locationImgView release];
        //定位城市
        x=x+width+3; y=10; width=80; height=22;
        [self setUpLabel:weatherView with_tag:1001 with_frame:CGRectMake(x, y, width, height) with_text:@"北京市" with_Alignment:NSTextAlignmentLeft];
        //天气
        x=10; y=y+height+10; width=100;
        [self setUpLabel:weatherView with_tag:1002 with_frame:CGRectMake(x, y, width, height) with_text:@"多云" with_Alignment:NSTextAlignmentLeft];
        //风力
        y=y+height+10;
        [self setUpLabel:weatherView with_tag:1003 with_frame:CGRectMake(x, y, width, height) with_text:@"微风" with_Alignment:NSTextAlignmentLeft];
        
        //日期
        x=CGRectGetWidth(weatherView.frame)-100; y=10;
        NSString *string_time=@"";
        NSString *week_day=@"";
        {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd"];
             string_time = [formatter stringFromDate:date];
            
            [formatter setDateFormat:@"EEEE"];
             week_day = [formatter stringFromDate:date];
            
            [formatter release];
        }
        [self setUpLabel:weatherView with_tag:1004 with_frame:CGRectMake(x, y, width, height) with_text:string_time with_Alignment:NSTextAlignmentLeft];
        //星期几
        y=y+height+10;
        [self setUpLabel:weatherView with_tag:1005 with_frame:CGRectMake(x, y, width, height) with_text:week_day with_Alignment:NSTextAlignmentLeft];
        //明日限行
        y=y+height+10; width=13*5;
        [self setUpLabel:weatherView with_tag:-1 with_frame:CGRectMake(x, y, width, height) with_text:@"明日限行:" with_Alignment:NSTextAlignmentLeft];
        //限行尾数1
        x=x+width-3; y=y+2; width=15; height=16;
        {
            UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [bgImgView setImage:[UIImage imageNamed:@"shouye_shuzi_bg.png"]];
            [weatherView addSubview:bgImgView];
            [bgImgView release];
        }
        [self setUpLabel:weatherView with_tag:1006 with_frame:CGRectMake(x, y, width, height) with_text:@"X" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1006];
            if (aLabel) {
                [aLabel setTextColor:[UIColor blackColor]];
            }
        }
        //限行尾数2
        x=x+width+2;
        {
            UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [bgImgView setImage:[UIImage imageNamed:@"shouye_shuzi_bg.png"]];
            [weatherView addSubview:bgImgView];
            [bgImgView release];
        }
        [self setUpLabel:weatherView with_tag:1007 with_frame:CGRectMake(x, y, width, height) with_text:@"X" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1007];
            if (aLabel) {
                [aLabel setTextColor:[UIColor blackColor]];
            }
        }
        
        //天气图片
        x=0; y=0; width=90; height=90;
        UIImageView* weatherImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [weatherImgView setTag:1008];
        [weatherImgView setCenter:CGPointMake(CGRectGetMidX(weatherView.frame), CGRectGetMinY(weatherView.frame)-35)];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1002];
            NSString* imgStr=[NSString stringWithFormat:@"%@.png",aLabel.text];
            [weatherImgView setImage:[UIImage imageNamed:imgStr]];
        }
        [weatherView addSubview:weatherImgView];
        [weatherImgView release];
        //温度
        x=(CGRectGetWidth(weatherView.frame)-200/2.0)/2.0-10; y=66; width=200/2.0; height=30;
        {
            UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [bgImgView setImage:[UIImage imageNamed:@"shouye_wendu_bg.png"]];
            [weatherView addSubview:bgImgView];
            [bgImgView release];
        }
        [self setUpLabel:weatherView with_tag:1009 with_frame:CGRectMake(x, y, width, height) with_text:@"28℃-30℃" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1009];
            if (aLabel) {
                [aLabel setFont:[UIFont systemFontOfSize:18]];
                [aLabel setTextColor:[UIColor blackColor]];
            }
        }
        
        //提示信息
        x=15; y=105; width=CGRectGetWidth(weatherView.frame)-x*2; height=30;
        [self setUpLabel:weatherView with_tag:1010 with_frame:CGRectMake(x, y, width, height) with_text:@"提示：未来24小时天气变换，不宜洗车" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1010];
            if (aLabel) {
                [aLabel setFont:[UIFont systemFontOfSize:14]];
                [aLabel setTextColor:[UIColor colorWithRed:254/255.0 green:205/255.0 blue:67/255.0 alpha:1.0]];
            }
        }
    }
    
    //添加车辆
    y=y+height+20; height=243/2.0;
    UIView* addCarView=[[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    addCarView.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:addCarView];
    [addCarView release];
    {
        float x, y, width, height;
        //背景
        x=0; y=0; width=320-10*2; height=243/2.0;
        UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [bgImageView setImage:[UIImage imageNamed:@"shouye_tianjiacheliang_bg.png"]];
        [addCarView addSubview:bgImageView];
        [bgImageView release];
        
        //添加车辆按钮
        x=0; y=0; width=339/2.0; height=50/2.0;
        UIButton* addCarBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [addCarBtn setCenter:CGPointMake(CGRectGetMidX(addCarView.bounds), CGRectGetMidY(addCarView.bounds))];
        [addCarBtn setShowsTouchWhenHighlighted:YES];
        [addCarBtn setImage:[UIImage imageNamed:@"shouye_tianjiacheliang_btn.png"] forState:UIControlStateNormal];
        [addCarBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [addCarView addSubview:addCarBtn];
        [addCarBtn release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
	// Do any additional setup after loading the view, typically from a nib.
    [self init_NaviView];
    [self init_scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
}

#pragma mark - 点击事件
-(void)msgBtnClick:(id)sender
{
    
}

-(void)addBtnClick:(id)sender
{
    
}


@end
