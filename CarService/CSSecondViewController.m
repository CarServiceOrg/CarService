//
//  CSSecondViewController.m
//  CarService
//
//  Created by Chao on 13-9-12.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSSecondViewController.h"
#import "ASIFormDataRequest.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"
#import "MBProgressHUD.h"
#import "CSAuthCodeViewController.h"

@interface CSSecondViewController ()<UITextFieldDelegate, MBProgressHUDDelegate>
{
    
}

@property(readonly,assign)MBProgressHUD *alertView;
@property(nonatomic,retain)NSString* m_responseString;
@property(nonatomic,retain)NSArray* m_responseCookieAry;

@end

@implementation CSSecondViewController
@synthesize alertView;
@synthesize m_responseString;
@synthesize m_responseCookieAry;

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
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:@"车牌号：" with_delegate:self];
    
    //发动机号
    y=y+height+15;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:102 with_placeHolder:@"发动机号：" with_delegate:self];

    //查询
    width=133/2.0+20; x=(320-width)/2.0; y=y+height+30; height=48/2.0+10;
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
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"违章查询";
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
    self.m_responseString=nil;
    self.m_responseCookieAry=nil;
    
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
        BOOL backBool=[self startHttpRequest_first];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertView hide:YES];
            if (backBool) {
                //跳转到验证码页面
                CSAuthCodeViewController* ctrler=[[CSAuthCodeViewController alloc] init];
                ctrler.m_firstResponseString=self.m_responseString;
                ctrler.m_firstResponseCookieAry=[NSMutableArray arrayWithArray:self.m_responseCookieAry];
                [self.navigationController pushViewController:ctrler animated:YES];
                [ctrler release];
            }else{
                [self showErrorMessage];
            }
        });
    });
}
/*
    http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/wzcx_preview.jsp  （post请求）
    post的参数正文是：carno=phq600&fdjh=80229789&sf=11
    其中  carno  是车牌号   fdjh 是 发动机号    sf  是省份的代号
    请求头要带：
    Referer   http://www.bjjtgl.gov.cn/portals/0/weifachaxun/new001_wfchaxun.htm
    Content-Type   application/x-www-form-urlencoded
*/
-(BOOL)startHttpRequest_first
{
    NSString *urlStr =@"http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/wzcx_preview.jsp";
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Referer" value:@"http://www.bjjtgl.gov.cn/portals/0/weifachaxun/new001_wfchaxun.htm"];
    //[request setUseCookiePersistence:YES];
    //[request setUseSessionPersistence:YES];

    //车牌号
    UITextField* aTextField=(UITextField*)[self.view viewWithTag:101];
    if (aTextField.text) {
        [request setPostValue:aTextField.text forKey:@"carno"];
    }
    //发动机号
    UITextField* bTextField=(UITextField*)[self.view viewWithTag:102];
    if (bTextField.text) {
        [request setPostValue:bTextField.text forKey:@"fdjh"];
    }
    //for test
    //[request setPostValue:@"phq600" forKey:@"carno"];
    //[request setPostValue:@"80229789" forKey:@"fdjh"];

    [request setPostValue:@"11" forKey:@"sf"];
    [request startSynchronous];
    
    NSError* error=[request error];
    if (error) {
        return NO;
    }else{
        CustomLog(@"<<Chao-->CSSecondViewController-->startHttpRequest_UserMessage-->[request responseString] : %@",[request responseString]);
        
        if ([request responseStatusCode]==200) {
            if ([request responseString]) {
                self.m_responseString=[request responseString];
                if ([request responseCookies] && [[request responseCookies] count]) {
                    NSHTTPCookie* cookies=[[request responseCookies] objectAtIndex:0];
                    CustomLog(@"<<Chao-->CSSecondViewController-->startHttpRequest_UserMessage-->cookies.properties : %@",cookies.properties);
                    self.m_responseCookieAry=[request responseCookies];
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
-(void)queryBtnClick:(id)sender
{
    //车牌号
    UITextField* aTextField=(UITextField*)[self.view viewWithTag:101];
    if (aTextField.text.length==0) {
        [ApplicationPublic showMessage:self with_title:@"请输入车牌号！" with_detail:@"" with_type:TSMessageNotificationTypeError with_Duration:2.0];
        return;
    }
    //发动机号
    UITextField* bTextField=(UITextField*)[self.view viewWithTag:102];
    if (bTextField.text.length==0) {
        [ApplicationPublic showMessage:self with_title:@"请输入发动机号！" with_detail:@"" with_type:TSMessageNotificationTypeError with_Duration:2.0];
        return;
    }
    
    //开始网络请求
    [self startHttpRequest];
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
