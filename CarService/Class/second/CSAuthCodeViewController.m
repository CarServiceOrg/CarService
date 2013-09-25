//
//  CSAuthCodeViewController.m
//  CarService
//
//  Created by baidu on 13-9-26.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSAuthCodeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"
#import "TFHpple.h"
#import "MBProgressHUD.h"

@interface CSAuthCodeViewController ()<UITextFieldDelegate, MBProgressHUDDelegate>
{
    UITextField* m_codeTextField; //输入的验证码
    UIButton* m_queryBtn; //查询按钮
    UIButton* m_getCodeBtn; //点击获取验证码
    UIView* m_authView;     //提示信息、验证码、重新获取按钮
    UILabel* m_noteLabel; //提示信息
    UIImageView* m_asynImageView; //异步加载获取的图片
}

@property(readonly,assign)MBProgressHUD *alertView;
@property(nonatomic,retain)NSArray* m_dataArray;

@end

@implementation CSAuthCodeViewController
@synthesize m_firstResponseString;
@synthesize m_firstResponseCookieAry;
@synthesize alertView;
@synthesize m_dataArray;

-(void)init_selfView
{
    //返回按钮
    [ApplicationPublic setUp_BackBtn:self.navigationItem withTarget:self with_action:@selector(backBtnClick:)];

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
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:@"请输入验证码" with_delegate:self];
    {
        m_codeTextField=(UITextField*)[self.view viewWithTag:101];
    }
    
    //点击获取验证码
    x=10; y=y+height+10; width=170; height=40;
    m_getCodeBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [m_getCodeBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [m_getCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"chaoxun_btn.png"] forState:UIControlStateNormal];
    [m_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"chanxun_btn_press.png"] forState:UIControlStateHighlighted];
    [m_getCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_getCodeBtn];
    [m_getCodeBtn release];

    x=10; y=20+40; width=320-10*2; height=25+200+25;
    m_authView=[[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [m_authView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:m_authView];
    [m_authView release];
    m_authView.alpha=0.0;
    
    {
        //说明：请输入图片中的变形文字
        x=0; y=0; width=320-10*2; height=25;
        [self setUpLabel:m_authView with_tag:1001 with_frame:CGRectMake(x, y, width, height) with_text:@"（说明：请输入图片中的变形文字）" with_Alignment:NSTextAlignmentLeft];
        {
            UILabel* alabel=(UILabel*)[m_authView viewWithTag:1001];
            if (alabel) {
                m_noteLabel=alabel;
            }
        }
        
        //图片
        x=50; y=y+height; width=200; height=200;
        m_asynImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        m_asynImageView.contentMode=UIViewContentModeScaleAspectFit;
        [m_asynImageView setBackgroundColor:[UIColor whiteColor]];
        m_asynImageView.layer.borderWidth=1.0;
        m_asynImageView.layer.backgroundColor=[UIColor grayColor].CGColor;
        [m_authView addSubview:m_asynImageView];
        [m_asynImageView release];
        {
            m_asynImageView.userInteractionEnabled=YES;
            UITapGestureRecognizer* recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(asynImageViewClick:)];
            [m_asynImageView addGestureRecognizer:recognizer];
            [recognizer release];
        }
        
        //看不清？换一张
        x=0; y=y+height; width=320-10*2; height=25;
        [self setUpLabel:m_authView with_tag:1002 with_frame:CGRectMake(x, y, width, height) with_text:@"看不清？换一张" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* alabel=(UILabel*)[m_authView viewWithTag:1002];
            if (alabel) {
                m_noteLabel=alabel;
            }
        }
    }
    
    //查询
    width=133/2.0+20; x=(320-width)/2.0; y=20+40+10+40+20; height=48/2.0+10;
    m_queryBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [m_queryBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [m_queryBtn setTitleColor:[UIColor colorWithRed:0xe9/255.0f green:0x9e/255.0f blue:0x72/255.0f alpha:1] forState:UIControlStateNormal];
    [m_queryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [m_queryBtn setBackgroundImage:[UIImage imageNamed:@"chaoxun_btn.png"] forState:UIControlStateNormal];
    [m_queryBtn setBackgroundImage:[UIImage imageNamed:@"chanxun_btn_press.png"] forState:UIControlStateHighlighted];
    [m_queryBtn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_queryBtn];
    [m_queryBtn release];
    [m_queryBtn setEnabled:NO];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"";
    [self init_selfView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    if (alertView&&alertView.superview) {
        alertView.delegate = nil;
        [alertView removeFromSuperview];
        [alertView release],alertView = nil;
    }
    self.m_firstResponseString=nil;
    self.m_firstResponseCookieAry=nil;
    self.m_dataArray=nil;
    [super dealloc];
}


#pragma mark - 网络请求
-(void)startHttpRequest{
    {
        self.alertView.mode = MBProgressHUDModeText;
        self.alertView.color=[UIColor darkGrayColor];
        self.alertView.labelText = NSLocalizedString(@"加载中...", nil);
        [self.alertView show:YES];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage* backImg=[self startHttpRequest_first];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertView hide:YES];
            if (backImg) {
                m_getCodeBtn.alpha=0.0;
                m_authView.alpha=1.0;
                m_asynImageView.image=backImg;
                m_queryBtn.frame=CGRectMake(m_queryBtn.frame.origin.x, CGRectGetMaxY(m_authView.frame)+20, m_queryBtn.frame.size.width, m_queryBtn.frame.size.height);
            }else{
                [self showErrorMessage];
            }
        });
    });
}

-(void)startHttpRequest_final{
    {
        self.alertView.mode = MBProgressHUDModeText;
        self.alertView.color=[UIColor darkGrayColor];
        self.alertView.labelText = NSLocalizedString(@"加载中...", nil);
        [self.alertView show:YES];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL backBool=[self startHttpRequest_second];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertView hide:YES];
            if (backBool) {
                CustomLog(@"<<Chao-->CSAuthCodeViewController-->startHttpRequest_final-->self.m_dataArray : %@",self.m_dataArray);
            }else{
                [self showErrorMessage];
            }
        });
    });
}

/*
 如果点击   点击获取验证码
 则发送下面的请求
 http://sslk.bjjtgl.gov.cn/jgjwwcx/servlet/YzmImg?t=1380013873007   （get请求）
 其中  t这个参数为 当前时间的时间戳
 
 请求头带：
 Referer     http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/wzcx_preview.jsp
 cookie      在上一步会发的结果里面带上了
 */
-(UIImage*)startHttpRequest_first
{
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970]*1;
    long long gap=now*1000;
    NSString *urlStr=[NSString stringWithFormat:@"http://sslk.bjjtgl.gov.cn/jgjwwcx/servlet/YzmImg?t=%lld",gap];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Referer" value:@"http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/wzcx_preview.jsp"];
    [request setRequestCookies:self.m_firstResponseCookieAry];
    [request startSynchronous];
    
    NSError* error=[request error];
    if (error) {
        return nil;
    }else{
        CustomLog(@"<<Chao-->CSAuthCodeViewController-->startHttpRequest_first-->[request responseString] : %@",[request responseString]);
        
        if ([request responseStatusCode]==200) {
            if ([request responseData]) {
                return [UIImage imageWithData:[request responseData]];
            }else{
                
            }
        }else{
            
        }
    }
    
    return nil;
}

/*
 点击 确定 之后
 http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/getWzcxXx.action     （post请求）
 post参数的正文是：
 c_flag=0&carnono=phq600&fdjhhm=80229789&ip=222.131.157.144&sf=11&yzm=%E5%BF%97%E9%80%9A
 
 其中前5个参数都是从第一步回发的结果里面取出的的隐藏字段
 div.box_login > form > input    即选取  class为box_login的div ，直接标签为  form的子节点，  再取 其 的直接 子节点（标签是input） ，分别取每个的name属性（即为参数的key），每个的value属性（即为参数的value）
 yzm 为输入的验证码
 
 请求头带：
 Referer    http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/wzcx_preview.jsp
 cookie     为最初的一步的设置的cookie
 Content-Type   application/x-www-form-urlencoded
 
 */

-(BOOL)startHttpRequest_second
{
    NSString *urlStr=@"http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/getWzcxXx.action";
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Referer" value:@"http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/wzcx_preview.jsp"];
    [request setRequestCookies:self.m_firstResponseCookieAry];
    
    //解析第一步的html数据 同时设置内容
    NSData* data=[self.m_firstResponseString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple* doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray* dataAry=[doc searchWithXPathQuery:@"//input"];
    //CustomLog(@"<<Chao-->CSAuthCodeViewController-->startHttpRequest_second-->dataAry : %@",dataAry);
    for (TFHppleElement* element in dataAry) {
        if (element) {
            if (element.attributes) {
                NSDictionary* dict=element.attributes;
                NSString* name=[dict objectForKey:@"name"];
                NSString* value=[dict objectForKey:@"value"];
                if (name && value) {
                    if ([name isEqualToString:@"carnono"] || [name isEqualToString:@"sf"] || [name isEqualToString:@"fdjhhm"] ||
                        [name isEqualToString:@"ip"] || [name isEqualToString:@"c_flag"]) {
                        [request setPostValue:value forKey:name];
                    }
                }
            }
        }
    }
    //carnono=phq600&sf=11&fdjhhm=80229789&ip=125.39.34.198&c_flag=0&yzm=%E5%BF%97
    //carnono=phq600&sf=11&fdjhhm=80229789&ip=125.39.34.198&c_flag=0&yzm=%E7%9A%84
    //设置验证码文本
    [request setPostValue:m_codeTextField.text forKey:@"yzm"];
    [request startSynchronous];
    
    NSError* error=[request error];
    if (error) {
        return NO;
    }else{
        CustomLog(@"<<Chao-->CSAuthCodeViewController-->startHttpRequest_second-->[request responseString] : %@",[request responseString]);
        if ([request responseStatusCode]==200) {
            if ([request responseString]) {
                
                //解析第一步的html数据 同时设置内容
                NSData* data=[[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
                TFHpple* doc = [[TFHpple alloc] initWithHTMLData:data];
                NSArray* backDataAry=[doc searchWithXPathQuery:@"//table[@class='tab_2']//tbody"];
                CustomLog(@"<<Chao-->CSAuthCodeViewController-->startHttpRequest_second-->backDataAry : %@",backDataAry);
                for (TFHppleElement* element in backDataAry) {
                    if (element) {
                        if (element.attributes) {
                            NSDictionary* dict=element.attributes;
                            NSString* name=[dict objectForKey:@"name"];
                            NSString* value=[dict objectForKey:@"value"];
                            if (name && value) {
                                if ([name isEqualToString:@"carnono"] || [name isEqualToString:@"sf"] || [name isEqualToString:@"fdjhhm"] ||
                                    [name isEqualToString:@"ip"] || [name isEqualToString:@"c_flag"]) {
                                    [request setPostValue:value forKey:name];
                                }
                            }
                        }
                    }
                }
                
                
                return YES;
            }else{
                
            }
        }else{
            
        }
    }
    
    return NO;
}

-(void)showErrorMessage{
    [ApplicationPublic showMessage:self with_title:@"加载数据失败！" with_detail:@"" with_type:TSMessageNotificationTypeError with_Duration:2.0];
}


#pragma mark - 点击事件
-(void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)queryBtnClick:(id)sender
{
    [self startHttpRequest_final];
}

-(void)getCodeBtnClick:(id)sender
{
    [self startHttpRequest];
}

-(void)asynImageViewClick:(UIGestureRecognizer*)sender
{
    m_asynImageView.image=nil;
    [self startHttpRequest];
}

#pragma mark - UITextFieldDelegate
//按Done键键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [m_queryBtn setEnabled:NO];
    return YES;
}

// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length==0) {
        if (range.location==0) {
            [m_queryBtn setEnabled:NO];
        }
    }else{
        if (m_asynImageView.image) {
            [m_queryBtn setEnabled:YES];
        }
    }
    return YES;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    if (alertView&&alertView.superview) {
        alertView.delegate = nil;
        [alertView removeFromSuperview];
        [alertView release],alertView = nil;
    }
}
- (MBProgressHUD*) alertView
{
    if (alertView==nil) {
        id delegate = [UIApplication sharedApplication].delegate;
        UIWindow *window = [delegate window];
        alertView = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:alertView];
        alertView.dimBackground = YES;
        alertView.labelText = NSLocalizedString(@"加载中", @"");
        alertView.delegate = self;
    }
    return alertView;
}

@end
