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
#import "CSPeccancyRecordViewController.h"

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
    CGRect frame=CGRectMake(10, DiffY+44+4, [UIScreen mainScreen].bounds.size.width-10*2, CSTabelViewHeight);
    UIImageView* tabviewBg=[[UIImageView alloc] initWithFrame:frame];
    [tabviewBg setImage:[ApplicationPublic getOriginImage:@"new_xiaofeijilu_liebiaoxinxi_toumingbeijing.png" withInset:UIEdgeInsetsMake(40, 40, 40, 40)]];
    tabviewBg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:tabviewBg];
    [tabviewBg release];

    float x, y, width, height;

    x=frame.origin.x+5; y=frame.origin.y+5; width=frame.size.width-5*2; height=40;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:100 with_placeHolder:@"仅支持北京地区车牌" with_delegate:self];
    {
        UITextField* aField=(UITextField*)[self.view viewWithTag:100];
        if (aField) {
            [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaogetoubu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
            [aField setEnabled:NO];
            [ApplicationPublic setLeftView:aField text:@"选择城市：" flag:YES fontSize:15.0];
        }
    }
    
    //车牌号
    y=y+height+1;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:@"请输入车牌号" with_delegate:self];
    {
        UITextField* aField=(UITextField*)[self.view viewWithTag:101];
        if (aField) {
            [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_zhongbu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
            [ApplicationPublic setLeftView:aField text:@"车牌号码：" flag:YES fontSize:15.0];
            //[aField setText:@"phq600"];
        }
    }
    //发动机号
    y=y+height+1;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:102 with_placeHolder:@"请输入发动机号" with_delegate:self];
    {
        UITextField* aField=(UITextField*)[self.view viewWithTag:102];
        if (aField) {
            [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_dibu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
            [ApplicationPublic setLeftView:aField text:@"发动机号：" flag:YES fontSize:15.0];
            //[aField setText:@"80229789"];
        }
    }
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

-(void)backBtnClicked:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [ApplicationPublic selfDefineBg:self.view];
    [ApplicationPublic selfDefineNavigationBar:self.view title:@"违章查询" withTarget:self with_action:@selector(backBtnClicked:)];
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
    
//    //(1)开始网络请求
//    [self startHttpRequest];
    
    //(2)开始网络请求
    NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:aTextField.text, @"lsnum", bTextField.text, @"engineno", nil];
    [self startHttpRequest:dict];
}

#pragma mark 网络相关

-(void)startHttpRequest:(NSMutableDictionary*)dict{
    {
        self.alertView.mode = MBProgressHUDModeText;
        self.alertView.labelText = NSLocalizedString(@"提交中...", nil);
        [self.alertView show:YES];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlStr = [NSString stringWithFormat:@"%@?json={\"action\":\"wzcx\",\"lsprefix\":\"%@\",\"lsnum\":\"%@\",\"engineno\":\"%@\"}",
                            ServerAddress,
                            @"京",   //[[[Util sharedUtil] getUserInfo] objectForKey:@"id"],
                            [dict objectForKey:@"lsnum"],
                            [dict objectForKey:@"engineno"]
                            ];
       urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [request setTimeOutSeconds:60.0];
        [request setRequestMethod:@"POST"];
        [request setCompletionBlock:^{
            
            NSDictionary *requestDic =[[request responseString] JSONValue];
            MyNSLog(@"requestDic:%@",requestDic);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.alertView hide:YES];
                
                if ([requestDic objectForKey:@"status"]) {
                    int status=[[requestDic objectForKey:@"status"] intValue];
                    
                    switch (status) {
                        case 0:
                        {
                            if ([requestDic objectForKey:@"list"]) {
                                NSMutableArray* array=[requestDic objectForKey:@"list"];
                                //跳转进入到下一个界面
                                CSPeccancyRecordViewController* ctrler=[[CSPeccancyRecordViewController alloc] initWithDataArray:array];
                                [self.navigationController pushViewController:ctrler animated:YES];
                                [ctrler release];
                            }
                        }
                            //[self showMessage:NSLocalizedString(@"成功", nil) with_detail:NSLocalizedString(@"提交成功！", nil) with_type:TSMessageNotificationTypeSuccess];
                            //[self performSelector:@selector(backBtnClicked:) withObject:nil afterDelay:1.5];
                            break;
                        case 1:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"提交数据失败！", nil) with_type:TSMessageNotificationTypeError];
                            break;
                            
                        default:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"提交数据失败！", nil) with_type:TSMessageNotificationTypeError];
                            break;
                    }
                }
            });
        }];
        [request setFailedBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.alertView hide:YES];
                [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"提交数据失败，请检验网络！", nil) with_type:TSMessageNotificationTypeError];
            });
        }];
        [request startAsynchronous];
    });
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
