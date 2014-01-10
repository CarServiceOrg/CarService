//
//  CSFirstViewController.m
//  CarService
//
//  Created by Chao on 13-9-12.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSFirstViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BlockActionSheet.h"
#import "CSCarManageViewController.h"
#import "CSAddCarViewController.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "TSMessage.h"
#import "BlockAlertView.h"
#import "CSAppDelegate.h"
#import "CSLogInViewController.h"
#import "CSMessageViewController.h"
#import "LBSDataUtil.h"
#import "CSReportCaseAskViewCtrler.h"
#import "CSForthViewController.h"
#import "CSFifthViewController.h"
#import "CSDelegateServiceViewController.h"
#import "CSSecondViewController.h"
#import "CSAppDelegate.h"

static UIColor* BtnTitleColorBlue=[UIColor colorWithRed:56/255.0 green:127/255.0 blue:254/255.0 alpha:1.0];
static UIColor* BtnTitleColorWhite=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
static UIColor* MsgTextColor=[UIColor colorWithRed:0x1e/255.0 green:0xf1/255.0 blue:0x41/255.0 alpha:1.0];

@interface CSFirstViewController ()<CSLogInViewController_Delegate,UINavigationControllerDelegate>
{
    UIViewController* _curPresentViewCtrler; //当前导航正处于preset的视图
}

@property(nonatomic,retain)NSMutableArray* m_msgArray;
@property(nonatomic,retain)UIScrollView* m_tabScrollView;

@end

@implementation CSFirstViewController
@synthesize m_msgArray;

#pragma mark - view lifecycle
-(void)init_NaviView
{
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"首页";
    
    //按钮
    UIButton* mangerBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60/2.0+6, 46/2.0+3)];
    [mangerBtn setImage:[UIImage imageNamed:@"shouye_btn1.png"] forState:UIControlStateNormal];
    [mangerBtn setImage:[UIImage imageNamed:@"shouye_btn1_press.png"] forState:UIControlStateHighlighted];
    [mangerBtn addTarget:self action:@selector(mangerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:mangerBtn] autorelease];
    [mangerBtn release];
    
    //信息按钮
    UIButton* msgBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60/2.0+8, 46/2.0+5)];
    [msgBtn setImage:[UIImage imageNamed:@"shouye_msg_logout.png"] forState:UIControlStateNormal];
    //[msgBtn setImage:[UIImage imageNamed:@"shouye_msg_press.png"] forState:UIControlStateHighlighted];
    [msgBtn addTarget:self action:@selector(msgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    {
        //消息数
        UILabel* numLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        [numLabel setTag:1001];
        [numLabel setCenter:CGPointMake(CGRectGetMaxX(msgBtn.frame)-6.5, CGRectGetMinY(msgBtn.frame)+6)];
        [numLabel setBackgroundColor:[UIColor clearColor]];
        [numLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [numLabel setTextAlignment:NSTextAlignmentCenter];
        [numLabel setFont:[UIFont systemFontOfSize:8]];
        [numLabel setTextColor:[UIColor whiteColor]];
        [numLabel setText:@""];
        numLabel.layer.cornerRadius=CGRectGetWidth(numLabel.frame)/2.0;
        numLabel.layer.borderWidth=1.0;
        numLabel.layer.borderColor=[UIColor clearColor].CGColor;
        [msgBtn addSubview:numLabel];
        [numLabel release];
    }
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:msgBtn] autorelease];
    [msgBtn release];
    
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
    aLabel.numberOfLines=0;
    aLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [aLabel setText:text];
    [superView addSubview:aLabel];
    [aLabel release];
}

-(void)init_scrollView
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
        [bgImageView setImage:[UIImage imageNamed:@"shouye_iphone4.png"]];
    }else{
        [bgImageView setImage:[UIImage imageNamed:@"shouye_iphone5.png"]];
    }
    [self.view addSubview:bgImageView];
    [bgImageView release];

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
    [weatherView setTag:201];
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
        [self setUpLabel:weatherView with_tag:1001 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentLeft];
        //天气
        x=10; y=y+height+10; width=100;
        [self setUpLabel:weatherView with_tag:1002 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentLeft];
        //风力
        y=y+height+10;
        [self setUpLabel:weatherView with_tag:1003 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentLeft];
        
        //日期
        x=CGRectGetWidth(weatherView.frame)-100; y=10;
        NSString *string_time=@"";
        NSString *week_day=@"";
        {
//            NSDate *date = [NSDate date];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateStyle:NSDateFormatterMediumStyle];
//            [formatter setTimeStyle:NSDateFormatterShortStyle];
//            [formatter setDateFormat:@"YYYY-MM-dd"];
//             string_time = [formatter stringFromDate:date];
//            
//            [formatter setDateFormat:@"EEEE"];
//             week_day = [formatter stringFromDate:date];
//            
//            [formatter release];
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
        [weatherImgView setCenter:CGPointMake(CGRectGetMidX(weatherView.frame)-5, CGRectGetMinY(weatherView.frame)-35)];
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
        [self setUpLabel:weatherView with_tag:1009 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1009];
            if (aLabel) {
                [aLabel setFont:[UIFont systemFontOfSize:18]];
                [aLabel setTextColor:[UIColor blackColor]];
            }
        }
        
        //提示信息
        x=15; y=100; width=CGRectGetWidth(weatherView.frame)-x*2; height=30;
        [self setUpLabel:weatherView with_tag:1010 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1010];
            if (aLabel) {
                [aLabel setBackgroundColor:[UIColor clearColor]];
                [aLabel setFont:[UIFont systemFontOfSize:14]];
                [aLabel setTextColor:[UIColor colorWithRed:254/255.0 green:205/255.0 blue:67/255.0 alpha:1.0]];
            }
        }
        
        //当前地理位置
        x=15; y=130; width=CGRectGetWidth(weatherView.frame)-x*2; height=20;
        [self setUpLabel:weatherView with_tag:1011 with_frame:CGRectMake(x, y, width, height) with_text:@"正在获取地理位置..." with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1011];
            if (aLabel) {
                [aLabel setBackgroundColor:[UIColor clearColor]];
                [aLabel setFont:[UIFont systemFontOfSize:10]];
                [aLabel setTextColor:[UIColor lightGrayColor]];
            }
        }
    }
    
    //添加车辆
    y=y+height+20; height=243/2.0;
    UIView* addCarView=[[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [addCarView setTag:202];
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
        
        //如果无添加记录 则显示添加按钮
        {
            UIView* containView=[[UIView alloc] initWithFrame:bgImageView.bounds];
            [containView setTag:1001];
            [addCarView addSubview:containView];
            [containView release];
            
            //添加车辆按钮
            x=0; y=0; width=339/2.0; height=50/2.0;
            UIButton* addCarBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [addCarBtn setTag:10001];
            [addCarBtn setCenter:CGPointMake(CGRectGetMidX(addCarView.bounds), CGRectGetMidY(addCarView.bounds))];
            [addCarBtn setShowsTouchWhenHighlighted:YES];
            [addCarBtn setImage:[UIImage imageNamed:@"shouye_tianjiacheliang_btn.png"] forState:UIControlStateNormal];
            [addCarBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [containView addSubview:addCarBtn];
            [addCarBtn release];
        }
        //如果添加过记录 则显示最后一个添加记录
        {
            UIView* containView=[[UIView alloc] initWithFrame:bgImageView.bounds];
            [containView setTag:1002];
            [addCarView addSubview:containView];
            [containView release];
            
            //图片
            x=10; y=15; width=115; height=addCarView.bounds.size.height-y*2;
            UIImageView* aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [aImageView setImage:[UIImage imageNamed:@"tianjiacheliang_pic.png"]];
            [containView addSubview:aImageView];
            [aImageView release];
            
            //车牌
            x=x+width+10; width=addCarView.bounds.size.width-x-10; height=(addCarView.bounds.size.height-y*2)/2.0;
            [self setUpLabel:containView with_tag:10001 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentLeft];
            //车架号
            y=y+height; y=y+1;
            [self setUpLabel:containView with_tag:10002 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentLeft];
        }

        NSArray* alreadyAry=[[NSUserDefaults standardUserDefaults] objectForKey:CSAddCarViewController_carList];
        if (alreadyAry) {
            UIView* containView=[addCarView viewWithTag:1001];
            if (containView) {
                containView.alpha=0;
            }
        }else{
            UIView* containView=[addCarView viewWithTag:1002];
            if (containView) {
                containView.alpha=0;
            }
        }
    }
}

-(void)setUpLabel:(UIView*)superView with_tag:(int)tag with_frame:(CGRect)frame with_text:(NSString*)text with_Alignment:(NSTextAlignment)alignment fontSize:(float)fontSize
{
    UILabel* aLabel=[[UILabel alloc] initWithFrame:frame];
    if (tag>=0) {
        [aLabel setTag:tag];
    }
    [aLabel setBackgroundColor:[UIColor clearColor]];
    [aLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [aLabel setTextAlignment:alignment];
    [aLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [aLabel setTextColor:[UIColor whiteColor]];
    [aLabel setText:text];
    aLabel.numberOfLines=0;
    aLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [superView addSubview:aLabel];
    [aLabel release];
}

-(void)initSelfView_top
{
    float x, y, width, height;
    
    //bg
    [ApplicationPublic selfDefineBg:self.view];
    
    //logo
    x=10; y=20+10; width=229/2.0; height=52/2.0;
    UIImageView* logoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [logoImageView setImage:[UIImage imageNamed:@"new_logo.png"]];
    [self.view addSubview:logoImageView];
    [logoImageView release];
    
    //电话图标
    y=y+height; width=18; height=18;
    UIImageView* photoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [photoImageView setImage:[UIImage imageNamed:@"new_dianhua_tubiao.png"]];
    [self.view addSubview:photoImageView];
    [photoImageView release];
    
    //电话
    x=x+width; width=229/2.0-width; height=23;
    {
        UILabel* aLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [aLabel setBackgroundColor:[UIColor clearColor]];
        [aLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [aLabel setTextAlignment:NSTextAlignmentCenter];
        [aLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [aLabel setTextColor:[UIColor blackColor]];
        [aLabel setText:@"400-009-2885"];
        [self.view addSubview:aLabel];
        [aLabel release];
    }
    
    //天气 日期 限号
    x=self.view.bounds.size.width-10-140; y=20+10; width=140; height=100;
    UIScrollView* scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [scrollView setTag:101];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    //添加内容视图
    x=0; y=0;
    UIView* weatherView=[[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [weatherView setTag:201];
    weatherView.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:weatherView];
    [weatherView release];
    {
        float x, y, width, height;

        x=0; y=0; width=140; height=70;
        UIImageView* bgImgView_1=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [bgImgView_1 setBackgroundColor:[UIColor blackColor]];
        [bgImgView_1 setAlpha:0.3];
        [weatherView addSubview:bgImgView_1];
        [bgImgView_1 release];
        bgImgView_1.layer.cornerRadius=6.0;
        
        y=y+height+2; height=28;
        UIImageView* bgImgView_2=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [bgImgView_2 setBackgroundColor:[UIColor blackColor]];
        [bgImgView_2 setAlpha:0.3];
        [weatherView addSubview:bgImgView_2];
        [bgImgView_2 release];
        bgImgView_2.layer.cornerRadius=6.0;
        
        //温度
        x=5; y=0; width=60; height=45;
        [self setUpLabel:weatherView with_tag:1009 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1009];
            if (aLabel) {
                //第一个温度
                [self setUpLabel:aLabel with_tag:10001 with_frame:CGRectMake(0, 0, width, 25) with_text:@"" with_Alignment:NSTextAlignmentLeft fontSize:16.0];
                //斜线
                [self setUpLabel:aLabel with_tag:10003 with_frame:CGRectMake(0, 25, width, 2) with_text:@"" with_Alignment:NSTextAlignmentLeft fontSize:16.0];
                UILabel* bLabel=(UILabel*)[aLabel viewWithTag:10003];
                if (bLabel) {
                    bLabel.backgroundColor=[UIColor whiteColor];
                    bLabel.transform=CGAffineTransformMakeRotation(-M_PI_4);
                }
                //第二个温度
                [self setUpLabel:aLabel with_tag:10002 with_frame:CGRectMake(0, 25+5, width, 15) with_text:@"" with_Alignment:NSTextAlignmentRight fontSize:12.0];
            }
        }
        
        //天气图片
        x=5+width+5; y=0; width=55; height=55;
        UIImageView* weatherImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        weatherImgView.backgroundColor=[UIColor clearColor];
        [weatherImgView setTag:1008];
        {
            //天气文本 如果没有对应图片时显示
            [self setUpLabel:weatherImgView with_tag:10001 with_frame:weatherImgView.bounds with_text:@"" with_Alignment:NSTextAlignmentLeft fontSize:14.0];
            if ([weatherImgView viewWithTag:10001]) {
                [[weatherImgView viewWithTag:10001] setHidden:YES];
            }
        }
        [weatherView addSubview:weatherImgView];
        [weatherImgView release];
        
        //日期
        x=0; y=50; width=100; height=20;
        NSString *string_time=@"";
        NSString *week_day=@"";
        [self setUpLabel:weatherView with_tag:1004 with_frame:CGRectMake(x, y, width, height) with_text:string_time with_Alignment:NSTextAlignmentCenter fontSize:12];
        //星期几
        x=x+width-10; width=40;
        [self setUpLabel:weatherView with_tag:1005 with_frame:CGRectMake(x, y, width, height) with_text:week_day with_Alignment:NSTextAlignmentCenter fontSize:12];
        
        //明日限行
        x=0; y=70+2; width=90; height=28;
        [self setUpLabel:weatherView with_tag:-1 with_frame:CGRectMake(x, y, width, height) with_text:@"明日限行:" with_Alignment:NSTextAlignmentCenter];
        //限行尾数1
        x=x+width-3; y=y+(28-16)/2.0; width=15; height=16;
        {
            UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            //[bgImgView setImage:[UIImage imageNamed:@"shouye_shuzi_bg.png"]];
            [weatherView addSubview:bgImgView];
            [bgImgView release];
            
            [bgImgView setBackgroundColor:[UIColor blackColor]];
            [bgImgView setAlpha:0.4];
            bgImgView.layer.cornerRadius=4.0;
            bgImgView.layer.borderWidth=0.5;
            bgImgView.layer.borderColor=[UIColor whiteColor].CGColor;
        }
        [self setUpLabel:weatherView with_tag:1006 with_frame:CGRectMake(x, y, width, height) with_text:@"X" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1006];
            if (aLabel) {
                [aLabel setTextColor:[UIColor whiteColor]];
            }
        }
        //限行尾数2
        x=x+width+2;
        {
            UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            //[bgImgView setImage:[UIImage imageNamed:@"shouye_shuzi_bg.png"]];
            [weatherView addSubview:bgImgView];
            [bgImgView release];
            
            [bgImgView setBackgroundColor:[UIColor blackColor]];
            [bgImgView setAlpha:0.4];
            bgImgView.layer.cornerRadius=4.0;
            bgImgView.layer.borderWidth=0.5;
            bgImgView.layer.borderColor=[UIColor whiteColor].CGColor;
        }
        [self setUpLabel:weatherView with_tag:1007 with_frame:CGRectMake(x, y, width, height) with_text:@"X" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1007];
            if (aLabel) {
                [aLabel setTextColor:[UIColor whiteColor]];
            }
        }
    }
}

-(void)initSelfView_middle
{
    float centerX, centerY, width, height;
    
    //添加内容视图
    width=258/2.0; height=298/2.0;
    UIView* containView=[[UIView alloc] initWithFrame:CGRectMake(0, 190+DiffHeight/2.0, width, height)];
    [containView setTag:102];
    containView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:containView];
    [containView release];
    {
        //背景
        UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:containView.bounds];
        [bgImgView setImage:[UIImage imageNamed:@"new_shouyebanyuan_xinxibeijing.png"]];
        [containView addSubview:bgImgView];
        [bgImgView release];
        
        float x, y, width, height;

        //车牌号
        x=15; y=20; width=containView.bounds.size.width-2*x; height=50;
        UIButton* mangerBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [mangerBtn setTag:1001];
        [mangerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [mangerBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [mangerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mangerBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateHighlighted];
        [mangerBtn addTarget:self action:@selector(mangerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [containView addSubview:mangerBtn];
        [mangerBtn release];
        
        //信息按钮
        x=10; y=y+height; width=containView.bounds.size.width-x*2; height=30;
        UIButton* msgBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [msgBtn setTag:1002];
        [msgBtn setBackgroundColor:[UIColor clearColor]];
        [msgBtn addTarget:self action:@selector(msgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [containView addSubview:msgBtn];
        [msgBtn release];
        {
            //消息数
            UILabel* numLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            [numLabel setTag:10001];
            [numLabel setBackgroundColor:[UIColor clearColor]];
            [numLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
            [numLabel setTextAlignment:NSTextAlignmentCenter];
            [numLabel setFont:[UIFont systemFontOfSize:14]];
            [numLabel setTextColor:MsgTextColor];
            [numLabel setText:@""];
            numLabel.layer.cornerRadius=CGRectGetWidth(numLabel.frame)/2.0;
            numLabel.layer.borderWidth=1.0;
            numLabel.layer.borderColor=MsgTextColor.CGColor;
            [msgBtn addSubview:numLabel];
            [numLabel release];
            
            //文本
            [self setUpLabel:msgBtn with_tag:10002 with_frame:CGRectMake(height+5, 0, width-height-5, height) with_text:@"" with_Alignment:NSTextAlignmentLeft fontSize:12.0];
            UILabel* aLabel=(UILabel*)[msgBtn viewWithTag:10002];
            if (aLabel) {
                [aLabel setTextColor:MsgTextColor];
            }
        }
        
        //添加车辆
        x=0; y=y+height+5; width=containView.bounds.size.width-10*2; height=30;
        UIButton* addCarBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [addCarBtn setTag:1003];
        addCarBtn.backgroundColor=[UIColor clearColor];
        [addCarBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"new_xiaofeijilu_tianjia_dianjianniu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
        [addCarBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"new_xiaofeijilu_tianjia_dianjianniu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
        [addCarBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateNormal];
        [addCarBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateHighlighted];
        [addCarBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [addCarBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [addCarBtn setTitle:@"添加车辆" forState:UIControlStateNormal];
        [addCarBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [containView addSubview:addCarBtn];
        [addCarBtn release];
    }
    
    //设置初始化位置
    {
        UIButton* mangerBtn=(UIButton*)[containView viewWithTag:1001];
        if (mangerBtn) {
            mangerBtn.alpha=0.0;
        }
        UIButton* msgBtn=(UIButton*)[containView viewWithTag:1002];
        if (msgBtn) {
            msgBtn.alpha=0.0;
        }
        UIButton* addCarBtn=(UIButton*)[containView viewWithTag:1003];
        if (addCarBtn) {
            addCarBtn.center=CGPointMake(CGRectGetMidX(containView.bounds), CGRectGetMidY(containView.bounds));
        }
    }
    
    width=75; height=75;
    //事故报案
    {
        centerX=50; centerY=130+DiffHeight/2.0;
        UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [aBtn setCenter:CGPointMake(centerX, centerY)];
        aBtn.backgroundColor=[UIColor clearColor];
        [aBtn setImageEdgeInsets:UIEdgeInsetsMake(15, (75-26)/2.0, 75-53/2.0-15, (75-26)/2.0)];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_baoanzixun_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_baoanzixun_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_baibeijing.png"] forState:UIControlStateNormal];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateHighlighted];
        [aBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateNormal];
        [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateHighlighted];
        [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(35, -20, 0, 0)];
        [aBtn setTitle:@"事故报案" forState:UIControlStateNormal];
        [aBtn addTarget:self action:@selector(shiGuBaoAnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aBtn];
        [aBtn release];
    }
    
    //代维服务
    {
        centerX=150; centerY=170+DiffHeight/2.0;
        UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [aBtn setCenter:CGPointMake(centerX, centerY)];
        aBtn.backgroundColor=[UIColor clearColor];
        [aBtn setImageEdgeInsets:UIEdgeInsetsMake(15, (75-26)/2.0, 75-53/2.0-15, (75-26)/2.0)];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_daiweifuwu_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_daiweifuwu_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_baibeijing.png"] forState:UIControlStateNormal];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateHighlighted];
        [aBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateNormal];
        [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateHighlighted];
        [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(35, -20, 0, 0)];
        [aBtn setTitle:@"代维服务" forState:UIControlStateNormal];
        [aBtn addTarget:self action:@selector(daiWeiFuWuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aBtn];
        [aBtn release];
    }
    //消费记录
    {
        centerX=190; centerY=260+DiffHeight/2.0;
        UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [aBtn setCenter:CGPointMake(centerX, centerY)];
        aBtn.backgroundColor=[UIColor clearColor];
        [aBtn setImageEdgeInsets:UIEdgeInsetsMake(15, (75-26)/2.0, 75-53/2.0-15, (75-26)/2.0)];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_xiaofeijilu_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_xiaofeijilu_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_baibeijing.png"] forState:UIControlStateHighlighted];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateNormal];
        [aBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateHighlighted];
        [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateNormal];
        [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(35, -20, 0, 0)];
        [aBtn setTitle:@"消费记录" forState:UIControlStateNormal];
        [aBtn addTarget:self action:@selector(xiaoFeiJiLuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aBtn];
        [aBtn release];
    }
    
    //我要投保
    {
        centerX=150; centerY=350+DiffHeight/2.0;
        UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [aBtn setCenter:CGPointMake(centerX, centerY)];
        aBtn.backgroundColor=[UIColor clearColor];
        [aBtn setImageEdgeInsets:UIEdgeInsetsMake(15, (75-26)/2.0, 75-53/2.0-15, (75-26)/2.0)];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_woyaotoubao_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_woyaotoubao_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_baibeijing.png"] forState:UIControlStateNormal];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateHighlighted];
        [aBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateNormal];
        [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateHighlighted];
        [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(35, -20, 0, 0)];
        [aBtn setTitle:@"我要投保" forState:UIControlStateNormal];
        [aBtn addTarget:self action:@selector(woYaoTouBaoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aBtn];
        [aBtn release];
    }
    
    //违章查询
    {
        centerX=50; centerY=410+DiffHeight/2.0;
        UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [aBtn setCenter:CGPointMake(centerX, centerY)];
        aBtn.backgroundColor=[UIColor clearColor];
        [aBtn setImageEdgeInsets:UIEdgeInsetsMake(15, (75-26)/2.0, 75-53/2.0-15, (75-26)/2.0)];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_weizhangchaxun_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_weizhangchaxun_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_baibeijing.png"] forState:UIControlStateHighlighted];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateNormal];
        [aBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateHighlighted];
        [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateNormal];
        [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(35, -20, 0, 0)];
        [aBtn setTitle:@"违章查询" forState:UIControlStateNormal];
        [aBtn addTarget:self action:@selector(weiZhangChaXunBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aBtn];
        [aBtn release];
    }
    
    width=40; height=40;
    //套餐
    {
        if (Is_iPhone5) {
            centerX=80; centerY=525;
        }else{
            centerX=120; centerY=440;
        }
        UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [aBtn setCenter:CGPointMake(centerX, centerY)];
        aBtn.backgroundColor=[UIColor clearColor];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_taocan_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_taocan_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_toumingheibeijing.png"] forState:UIControlStateNormal];
        [aBtn addTarget:self action:@selector(taoCanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aBtn];
        [aBtn release];
    }
    
    //个人中心
    {
        centerX=centerX+70;
        UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [aBtn setCenter:CGPointMake(centerX, centerY)];
        aBtn.backgroundColor=[UIColor clearColor];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_yonghu_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_yonghu_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_toumingheibeijing.png"] forState:UIControlStateNormal];
        [aBtn addTarget:self action:@selector(geRenZhongXinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aBtn];
        [aBtn release];
    }
    //更多
    {
        centerX=centerX+70;
        UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [aBtn setCenter:CGPointMake(centerX, centerY)];
        aBtn.backgroundColor=[UIColor clearColor];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_gengduo_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
        [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_gengduo_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
        [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_toumingheibeijing.png"] forState:UIControlStateNormal];
        [aBtn addTarget:self action:@selector(gengDuoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aBtn];
        [aBtn release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationController.navigationBar.hidden=YES;
	// Do any additional setup after loading the view, typically from a nib.
    [self initSelfView_top];
    [self initSelfView_middle];
    if (Is_iPhone5) {
        self.navigationController.delegate=self;
        [self initTabScrollView];
    }
    
    //登录、登出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiviLoginNotification:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiviLogoutNotification:) name:LogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccessNotification:) name:LocationSuccessNotification object:nil];

    //网络获取数据
    [self startHttpRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView* containView=(UIView*)[self.view viewWithTag:102];
    if (containView) {
        NSArray* alreadyAry=[[NSUserDefaults standardUserDefaults] objectForKey:CSAddCarViewController_carList];
        if (alreadyAry) {
            //更新数据 为最后一个车牌号
            UIButton* mangerBtn=(UIButton*)[containView viewWithTag:1001];
            if (mangerBtn) {
                mangerBtn.alpha=1.0;
                
                NSString* signStr=[[alreadyAry lastObject] objectForKey:CSAddCarViewController_carSign]; //车牌号
                //NSString* standStr=[[alreadyAry lastObject] objectForKey:CSAddCarViewController_carStand]; //车架号
                [mangerBtn setTitle:[NSString stringWithFormat:@"%@",signStr] forState:UIControlStateNormal];
            }
            
            UIButton* msgBtn=(UIButton*)[containView viewWithTag:1002];
            if (msgBtn) {
                msgBtn.alpha=0.0;
            }
            
            //更新位置
            UIButton* addCarBtn=(UIButton*)[containView viewWithTag:1003];
            if (addCarBtn) {
                addCarBtn.frame=CGRectMake(0, CGRectGetMinY(msgBtn.frame)+5, addCarBtn.bounds.size.width, addCarBtn.bounds.size.height);
            }
        }else{
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.m_msgArray=nil;
    self.m_tabScrollView=nil;
    [super dealloc];
}

#pragma mark - window上的btn
-(void)initTabScrollView
{
    //底部导航栏
    float x,y,width,height;
    x=0; y=[UIScreen mainScreen].bounds.size.height; width=[UIScreen mainScreen].bounds.size.width; height=CSTabScrollHeight;
    self.m_tabScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _m_tabScrollView.backgroundColor=[UIColor clearColor];
    _m_tabScrollView.showsHorizontalScrollIndicator=NO;
    _m_tabScrollView.showsVerticalScrollIndicator=NO;
    //[[(CSAppDelegate*)[[UIApplication sharedApplication] delegate] window] addSubview:_m_tabScrollView];
    [self.navigationController.view addSubview:_m_tabScrollView];
    [_m_tabScrollView release];
    {
        float x, y, width, height;

        y=10; width=65; height=65;
        //事故报案
        {
            x=12;
            UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
            aBtn.tag=2001;
            aBtn.backgroundColor=[UIColor clearColor];
            [aBtn setImageEdgeInsets:UIEdgeInsetsMake(8, (width-26)/2.0, height-53/2.0-8, (width-26)/2.0)];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_baoanzixun_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_baoanzixun_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_baoanzixun_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateSelected];
            
            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_baibeijing.png"] forState:UIControlStateNormal];
            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateHighlighted];
            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateSelected];
            
            [aBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateNormal];
            [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateHighlighted];
            [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateSelected];
            
            [aBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
            [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -20, 0, 0)];
            [aBtn setTitle:@"事故报案" forState:UIControlStateNormal];
            [aBtn addTarget:self action:@selector(shiGuBaoAnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_m_tabScrollView addSubview:aBtn];
            [aBtn release];
        }
        
        //代维服务
        {
            x=x+width+12;
            UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
            aBtn.tag=2002;
            aBtn.backgroundColor=[UIColor clearColor];
            [aBtn setImageEdgeInsets:UIEdgeInsetsMake(8, (width-26)/2.0, height-53/2.0-8, (width-26)/2.0)];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_daiweifuwu_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_daiweifuwu_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_daiweifuwu_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateSelected];

            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_baibeijing.png"] forState:UIControlStateNormal];
            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateHighlighted];
            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateSelected];

            [aBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateNormal];
            [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateHighlighted];
            [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateSelected];
            
            [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -20, 0, 0)];
            [aBtn setTitle:@"代维服务" forState:UIControlStateNormal];
            [aBtn addTarget:self action:@selector(daiWeiFuWuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_m_tabScrollView addSubview:aBtn];
            [aBtn release];
        }
        //消费记录
        {
            x=x+width+12;
            UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
            aBtn.tag=2003;
            aBtn.backgroundColor=[UIColor clearColor];
            [aBtn setImageEdgeInsets:UIEdgeInsetsMake(8, (width-26)/2.0, height-53/2.0-8, (width-26)/2.0)];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_xiaofeijilu_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_xiaofeijilu_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_xiaofeijilu_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateSelected];

            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_baibeijing.png"] forState:UIControlStateNormal];
            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateHighlighted];
            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateSelected];

            [aBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateNormal];
            [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateHighlighted];
            [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateSelected];

            [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -20, 0, 0)];
            [aBtn setTitle:@"消费记录" forState:UIControlStateNormal];
            [aBtn addTarget:self action:@selector(xiaoFeiJiLuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_m_tabScrollView addSubview:aBtn];
            [aBtn release];
        }
        
        //我要投保
        {
            x=x+width+12;
            UIButton* aBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
            aBtn.tag=2004;
            aBtn.backgroundColor=[UIColor clearColor];
            [aBtn setImageEdgeInsets:UIEdgeInsetsMake(8, (width-26)/2.0, height-53/2.0-8, (width-26)/2.0)];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_woyaotoubao_tubiao.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_woyaotoubao_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
            [aBtn  setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"shouye_woyaotoubao_tubiao02.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateSelected];

            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_baibeijing.png"] forState:UIControlStateNormal];
            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateHighlighted];
            [aBtn setBackgroundImage:[UIImage imageNamed:@"shouye_anniu_lanbeijing.png"] forState:UIControlStateSelected];

            [aBtn setTitleColor:BtnTitleColorBlue forState:UIControlStateNormal];
            [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateHighlighted];
            [aBtn setTitleColor:BtnTitleColorWhite forState:UIControlStateSelected];

            [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [aBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -20, 0, 0)];
            [aBtn setTitle:@"我要投保" forState:UIControlStateNormal];
            [aBtn addTarget:self action:@selector(woYaoTouBaoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_m_tabScrollView addSubview:aBtn];
            [aBtn release];
        }
    }
}

-(void)showTabScrollView:(BOOL)flagShowBool
{
    if (flagShowBool) {
        [UIView animateWithDuration:0.6 animations:^{
            self.m_tabScrollView.frame=CGRectMake(self.m_tabScrollView.frame.origin.x, [UIScreen mainScreen].bounds.size.height-self.m_tabScrollView.bounds.size.height, self.m_tabScrollView.bounds.size.width, self.m_tabScrollView.bounds.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.6 animations:^{
            self.m_tabScrollView.frame=CGRectMake(self.m_tabScrollView.frame.origin.x, [UIScreen mainScreen].bounds.size.height, self.m_tabScrollView.bounds.size.width, self.m_tabScrollView.bounds.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(int)getSelectedIndexInWindow
{
    for (UIView* subView in self.m_tabScrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [(UIButton*)subView isSelected];
            return subView.tag-2000;
        }
    }
    return -1;
}

#pragma mark - 首页点击事件

//事故报案
-(void)shiGuBaoAnBtnClicked:(UIButton*)sender
{
    if (![[Util sharedUtil] hasLogin]) {
        if ([sender.superview isEqual:self.m_tabScrollView]) {
            
            if (self.navigationController.topViewController.presentedViewController) {
                [self.navigationController.topViewController dismissModalViewControllerAnimated:YES];
            }

            if ([self.navigationController.topViewController isKindOfClass:[CSReportCaseAskViewCtrler class]] || sender.isSelected==YES) {
                return;
            }
            
            CSReportCaseAskViewCtrler* viewCtrler=[[CSReportCaseAskViewCtrler alloc] init];
            viewCtrler.m_isPresentBool=YES;
            UINavigationController* navi=[[UINavigationController alloc] initWithRootViewController:viewCtrler];
            [navi.navigationBar setHidden:YES];
            [self.navigationController.topViewController presentModalViewController:navi animated:YES];
            [viewCtrler release];
            [navi release];
        }else{
            [self setTabBtnSelectedWithTag:2001];
            
            CSReportCaseAskViewCtrler* viewCtrler=[[CSReportCaseAskViewCtrler alloc] init];
            [self.navigationController pushViewController:viewCtrler animated:YES];
            [viewCtrler release];
        }
    }else{
        //提示登录
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"提示" message:@"查看消息详情请先登录！"];
        [alert setCancelButtonWithTitle:@"取消" block:nil];
        [alert setDestructiveButtonWithTitle:@"登录" block:^{
            CSLogInViewController *ctrler=[[CSLogInViewController alloc] initWithParentCtrler:self witjFlagStr:@"CSReportCaseAskViewCtrler" with_NibName:@"CSLogInViewController" bundle:nil];
            ctrler.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            ctrler.delegate=self;
            UINavigationController* navi=[[UINavigationController alloc] initWithRootViewController:ctrler];
            [navi.navigationBar setHidden:YES];
            [self presentModalViewController:navi animated:YES];
            [ctrler release];
            [navi release];
        }];
        [alert show];
    }
}

//代维服务
-(void)daiWeiFuWuBtnClicked:(UIButton*)sender
{
    if (![[Util sharedUtil] hasLogin]) {
        if ([sender.superview isEqual:self.m_tabScrollView]) {

            if (self.navigationController.topViewController.presentedViewController) {
                [self.navigationController.topViewController dismissModalViewControllerAnimated:YES];
            }
            
            if ([self.navigationController.topViewController isKindOfClass:[CSDelegateServiceViewController class]] || sender.isSelected==YES) {
                return;
            }
            
            CSDelegateServiceViewController* viewCtrler=[[CSDelegateServiceViewController alloc] init];
            viewCtrler.m_isPresentBool=YES;
            UINavigationController* navi=[[UINavigationController alloc] initWithRootViewController:viewCtrler];
            [navi.navigationBar setHidden:YES];
            [self.navigationController.topViewController presentModalViewController:navi animated:YES];
            [viewCtrler release];
            [navi release];
            
        }else{
            [self setTabBtnSelectedWithTag:2002];

            CSDelegateServiceViewController* ctrler=[[CSDelegateServiceViewController alloc] init];
            [self.navigationController pushViewController:ctrler animated:YES];
            [ctrler release];
        }
    }else{
        //提示登录
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"提示" message:@"查看消息详情请先登录！"];
        [alert setCancelButtonWithTitle:@"取消" block:nil];
        [alert setDestructiveButtonWithTitle:@"登录" block:^{
            CSLogInViewController *ctrler=[[CSLogInViewController alloc] initWithParentCtrler:self witjFlagStr:@"CSMessageViewController" with_NibName:@"CSLogInViewController" bundle:nil];
            ctrler.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            ctrler.delegate=self;
            UINavigationController* navi=[[UINavigationController alloc] initWithRootViewController:ctrler];
            [ApplicationPublic selfDefineNaviBar:navi.navigationBar];
            [self presentModalViewController:navi animated:YES];
            [ctrler release];
            [navi release];
        }];
        [alert show];
    }
}

//消费记录
-(void)xiaoFeiJiLuBtnClicked:(UIButton*)sender
{
   
}

//我要投保
-(void)woYaoTouBaoBtnClicked:(UIButton*)sender
{
    
}

//违章查询
-(void)weiZhangChaXunBtnClicked:(UIButton*)sender
{
    if ([sender.superview isEqual:self.m_tabScrollView]) {
        
    }else{
        [self setTabBtnSelectedWithTag:-1];

        CSSecondViewController* ctrler=[[CSSecondViewController alloc] init];
        [self.navigationController pushViewController:ctrler animated:YES];
        [ctrler release];
    }
}

//套餐
-(void)taoCanBtnClicked:(UIButton*)sender
{
    
}

//个人中心
-(void)geRenZhongXinBtnClicked:(UIButton*)sender
{
    CSForthViewController *controller = [[CSForthViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

//更多
-(void)gengDuoBtnClicked:(UIButton*)sender
{
    CSFifthViewController *controller = [[CSFifthViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)setTabBtnSelectedWithTag:(int)tag
{
    for (UIView* subView in self.m_tabScrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [(UIButton*)subView setSelected:NO];
        }
    }
    
    UIButton* aBtn=(UIButton*)[self.m_tabScrollView viewWithTag:tag];
    if (aBtn) {
        [aBtn setSelected:YES];
    }
}

#pragma mark 通知
-(void)startHttp_message
{
    //获取代维服务地点列表
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.m_msgArray=[ApplicationRequest startHttpRequest_UserMessage];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.m_msgArray==nil) {
                
            }else{
                UIView* containView=(UIView*)[self.view viewWithTag:102];
                if (containView) {
                    UIButton* msgBtn=(UIButton*)[containView viewWithTag:1002];
                    if (msgBtn) {
                        msgBtn.alpha=1.0;
                        
                        UILabel* aLabel=(UILabel*)[msgBtn viewWithTag:10001];
                        if (aLabel) {
                            [aLabel setText:[NSString stringWithFormat:@"%d",[self.m_msgArray count]]];
                        }
                        
                        UILabel* bLabel=(UILabel*)[msgBtn viewWithTag:10002];
                        if (bLabel) {
                            [bLabel setText:[NSString stringWithFormat:@"您有%d条新的信息",[self.m_msgArray count]]];
                        }
                    }
                    
                    //更新位置
                    UIButton* addCarBtn=(UIButton*)[containView viewWithTag:1003];
                    if (addCarBtn) {
                        addCarBtn.frame=CGRectMake(0, CGRectGetMaxY(msgBtn.frame)+5, addCarBtn.bounds.size.width, addCarBtn.bounds.size.height);
                    }
                }
            }
        });
    });
}

- (void)receiviLoginNotification:(NSNotification *)notify
{
    //获取用户消息
    [self startHttp_message];
}

- (void)receiviLogoutNotification:(NSNotification *)notify
{
    UIButton* msgBtn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
    if (msgBtn && [msgBtn isKindOfClass:[UIButton class]]) {
        UILabel* numLabel=(UILabel*)[msgBtn viewWithTag:1001];
        if (numLabel) {
            numLabel.text=@"";
        }
    }
}

- (void)locationSuccessNotification:(NSNotification *)notify
{
    NSString* address=(NSString*)notify.object;
    if (address) {
        if (address.length) {
            [self updateTextForLabel:address with_superViewTag:201 with_LabelTag:1011];
        }else{
            [self updateTextForLabel:@"获取当前位置信息失败..." with_superViewTag:201 with_LabelTag:1011];
        }
    }else{
        [self updateTextForLabel:@"获取当前位置信息失败..." with_superViewTag:201 with_LabelTag:1011];
    }
}

#pragma mark 网络相关

-(void)startHttpRequest{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self request_TrafficControls];
        [self request_weather];
    });
}

//今日限行
-(void)request_TrafficControls
{
    NSString *urlStr = [URL_TrafficControls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        //NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //NSString *testResponseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding] autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //CustomLog(@"<<Chao-->CSFirstViewController-->request_TrafficControls-->testResponseString:%@",testResponseString);
        NSDictionary *requestDic =[[request responseString] JSONValue];
        CustomLog(@"<<Chao-->CSFirstViewController-->request_TrafficControls-->requestDic:%@",requestDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([requestDic objectForKey:@"str"]) {
                NSString* backStr=[requestDic objectForKey:@"str"];
                if ([backStr isEqualToString:@"-1"]) {
                    
                }else{
                    if (backStr.length>0) {
                        [self updateTextForLabel:[backStr substringWithRange:NSMakeRange(0, 1)] with_superViewTag:201 with_LabelTag:1006];
                    }
                    if (backStr.length>2) {
                        [self updateTextForLabel:[backStr substringWithRange:NSMakeRange(2, 1)] with_superViewTag:201 with_LabelTag:1007];
                    }
                }
            }
        });
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载今日限行数据失败，请检验网络！", nil) with_type:TSMessageNotificationTypeError];
        });
    }];
    [request startAsynchronous];
}

//今日天气
-(void)request_weather
{
    NSString *urlStr = [URL_Weather stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"Get"];
    [request setCompletionBlock:^{
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *testResponseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding] autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        CustomLog(@"<<Chao-->CSFirstViewController-->request_weather-->testResponseString:%@",testResponseString);
        NSDictionary *requestDic =[[request responseString] JSONValue];
        CustomLog(@"<<Chao-->CSFirstViewController-->request_weather-->requestDic:%@",requestDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([requestDic objectForKey:@"weatherinfo"]) {
                NSDictionary* backDict=[requestDic objectForKey:@"weatherinfo"];
                
                //定位城市
                [self updateTextForLabel:@"北京市天气" with_superViewTag:201 with_LabelTag:1001];
                //天气
                if ([backDict objectForKey:@"weather1"]) {
                    [self updateTextForLabel:[NSString stringWithFormat:@"%@",[backDict objectForKey:@"weather1"]] with_superViewTag:201 with_LabelTag:1002];
                }
                //风力
                if ([backDict objectForKey:@"wind1"]) {
                    [self updateTextForLabel:[NSString stringWithFormat:@"%@",[backDict objectForKey:@"wind1"]] with_superViewTag:201 with_LabelTag:1003];
                }
                
                //日期
                if ([backDict objectForKey:@"date_y"]) {
                    [self updateTextForLabel:[NSString stringWithFormat:@"%@",[backDict objectForKey:@"date_y"]] with_superViewTag:201 with_LabelTag:1004];
                }
                
                //星期几
                if ([backDict objectForKey:@"week"]) {
                    [self updateTextForLabel:[NSString stringWithFormat:@"%@",[backDict objectForKey:@"week"]] with_superViewTag:201 with_LabelTag:1005];
                }
                
                //天气图片 1008
                if ([backDict objectForKey:@"weather1"]) {
                    NSString* weather1_str=[backDict objectForKey:@"weather1"];
                    //weather1_str=@"雷阵雨伴有冰雹";
                    [self updateTextForLabel:[NSString stringWithFormat:@"%@",weather1_str] with_superViewTag:201 with_LabelTag:1008];
                }
                
                //温度 1009
                if ([backDict objectForKey:@"temp1"]) {
                    [self updateTextForLabel_weather:[NSString stringWithFormat:@"%@",[backDict objectForKey:@"temp1"]] with_superViewTag:201 with_LabelTag:1009];
                }
                
                //提示信息 1010
                //这部分是读取 weather2 里面是否包含 雨 、雪、冰雹  这三组词任意一个时，即 上面的文案  即为：未来24小时天气变幻，不宜洗车！
                //如果都没有，文案则为： 未来24小时天气变幻，适宜洗车！
                if ([backDict objectForKey:@"weather2"]) {
                    NSString* textStr=@"未来24小时天气变幻，适宜洗车！";
                    NSString* weather2_str=[backDict objectForKey:@"weather2"];
                    //weather2_str=@"雷阵雨伴有冰雹";
                    if ([weather2_str rangeOfString:@"雨"].length==1 ||
                        [weather2_str rangeOfString:@"雪"].length==1 ||
                        [weather2_str rangeOfString:@"冰雹"].length==2) {
                        textStr=@"未来24小时天气变幻，不宜洗车！";
                    }                    
                    [self updateTextForLabel:textStr with_superViewTag:201 with_LabelTag:1010];
                }
            }
        });
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载天气数据失败，请检验网络！", nil) with_type:TSMessageNotificationTypeError];
        });
    }];
    [request startAsynchronous];
}


-(void)updateTextForLabel:(NSString*)text with_superViewTag:(int)superTag  with_LabelTag:(int)labelTag
{
    UIScrollView* scrollView=(UIScrollView*)[self.view viewWithTag:101];
    if (scrollView) {
        UIView* superView=[scrollView viewWithTag:superTag];
        if (superView) {
            if ([[superView viewWithTag:labelTag] isKindOfClass:[UILabel class]]) {
                UILabel* aLabel=(UILabel*)[superView viewWithTag:labelTag];
                aLabel.text=[NSString stringWithFormat:@"%@",text];
            }else if ([[superView viewWithTag:labelTag] isKindOfClass:[UIImageView class]]){
                UIImageView* aImgView=(UIImageView*)[superView viewWithTag:labelTag];
                if (aImgView) {
                    if ([UIImage imageNamed:text]) {
                        [aImgView setImage:[UIImage imageNamed:text]];
                    }else{
                        UILabel* aLabel=(UILabel*)[aImgView viewWithTag:10001];
                        if (aLabel) {
                            [aLabel setText:text];
                        }
                    }
                }
            }
        }
    }
}

-(void)updateTextForLabel_weather:(NSString*)text with_superViewTag:(int)superTag  with_LabelTag:(int)labelTag
{
    UIScrollView* scrollView=(UIScrollView*)[self.view viewWithTag:101];
    if (scrollView) {
        UIView* superView=[scrollView viewWithTag:superTag];
        if (superView) {
            if ([[superView viewWithTag:labelTag] isKindOfClass:[UILabel class]]) {
                if (labelTag==1009) {
                    UILabel* aLabel=(UILabel*)[superView viewWithTag:labelTag];

                    NSRange range=[text rangeOfString:@"~"];
                    if (range.length) {
                        {
                            NSString* firstStr=[text substringWithRange:NSMakeRange(0, range.location)];
                            if ([aLabel viewWithTag:10001]) {
                                UILabel* bLabel=(UILabel*)[aLabel viewWithTag:10001];
                                if (bLabel) {
                                    [bLabel setText:firstStr];
                                }
                            }
                        }
                        
                        {
                            NSString* secondStr=[text substringWithRange:NSMakeRange(range.location+1, text.length-(range.location+1))];
                            if ([aLabel viewWithTag:10002]) {
                                UILabel* bLabel=(UILabel*)[aLabel viewWithTag:10002];
                                if (bLabel) {
                                    [bLabel setText:secondStr];
                                }
                            }
                        }
                    }else{
                        for(UIView* subView in aLabel.subviews){
                            [subView setHidden:YES];
                        }
                        aLabel.text=[NSString stringWithFormat:@"%@",text];
                    }
                }
            }
        }
    }
}

-(void)showMessage:(NSString*)titleStr with_detail:(NSString*)detailStr with_type:(TSMessageNotificationType)type
{
    [TSMessage showNotificationInViewController:self
                                          title:titleStr
                                       subtitle:detailStr
                                          image:nil
                                           type:type
                                       duration:4.0
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                            canBeDismisedByUser:YES];
}

#pragma mark - 点击事件

-(void)msgBtnClick:(UIButton*)sender
{
    if ([[Util sharedUtil] hasLogin]) {
        //点击跳转
        [self push_messageViewCtrler];
    }else{
        //提示登录
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"提示" message:@"查看消息详情请先登录！"];
        [alert setCancelButtonWithTitle:@"取消" block:nil];
        [alert setDestructiveButtonWithTitle:@"登录" block:^{
            //[self.tabBarController setSelectedIndex:3];
            //[(CSAppDelegate*)[UIApplication sharedApplication].delegate updateSelectIndex:3];
            
            CSLogInViewController *ctrler=[[CSLogInViewController alloc] initWithParentCtrler:self witjFlagStr:@"CSMessageViewController" with_NibName:@"CSLogInViewController" bundle:nil];
            ctrler.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            ctrler.delegate=self;
            UINavigationController* navi=[[UINavigationController alloc] initWithRootViewController:ctrler];
            [ApplicationPublic selfDefineNaviBar:navi.navigationBar];
            [self presentModalViewController:navi animated:YES];
            [ctrler release];
            [navi release];
        }];
        [alert show];
    }
}

-(void)addBtnClick:(id)sender
{
    CSAddCarViewController* ctrler=[[CSAddCarViewController alloc] init];
    [self.navigationController pushViewController:ctrler animated:YES];
    [ctrler release];
}

-(void)mangerBtnClick:(id)sender
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@""];
    [sheet setCancelButtonWithTitle:@"取消" block:nil];
    [sheet setDestructiveButtonWithTitle:@"车辆管理" block:^{
        CSCarManageViewController* ctrler=[[CSCarManageViewController alloc] init];
        [self.navigationController pushViewController:ctrler animated:YES];
        [ctrler release];
    }];
    [sheet showInView:self.view];
}

#pragma mark - CSLogInViewController_Delegate
-(void)loginFinishCallBack:(NSString*)flagStr
{
    [self performSelector:@selector(delayCall:) withObject:flagStr afterDelay:0.5];
}

-(void)push_messageViewCtrler
{
    CSMessageViewController* controller = [[CSMessageViewController alloc] initWithNibName:@"CSMessageViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)delayCall:(NSString*)flagStr
{
    if ([flagStr isEqualToString:@"CSMessageViewController"]) {
        [self push_messageViewCtrler];
    }else if ([flagStr isEqualToString:@""]){
       
    }
}

#pragma mark - UINavigationControllerDelegate
// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    MyNSLog();
    if ([viewController isKindOfClass:[CSFirstViewController class]]) {
        [self showTabScrollView:NO];
    }else{
        [self showTabScrollView:YES];
    }
}

@end
