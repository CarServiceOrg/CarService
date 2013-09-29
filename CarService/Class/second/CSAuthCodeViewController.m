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
#import "CSPeccancyRecordViewController.h"

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
@property(nonatomic,retain)NSMutableArray* m_dataArray;

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
        int back=[self startHttpRequest_second];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertView hide:YES];
            if (back==0) {
                [self showErrorMessage];
            }else if (back==1){
                [ApplicationPublic showMessage:self with_title:@"验证码输入有误！请重新输入！" with_detail:@"" with_type:TSMessageNotificationTypeWarning with_Duration:2.0];
            }else if (back==2){
                //跳转进入到下一个界面
                CSPeccancyRecordViewController* ctrler=[[CSPeccancyRecordViewController alloc] initWithDataArray:self.m_dataArray];
                [self.navigationController pushViewController:ctrler animated:YES];
                [ctrler release];
            }else if (back==3){
                BlockAlertView *alert = [BlockAlertView alertWithTitle:@"提示" message:@"超时，请重新查询！"];
                [alert setDestructiveButtonWithTitle:@"确定" block:^{
                    [self backBtnClick:nil];
                }];
                [alert show];
            }else if (back==4){
                BlockAlertView *alert = [BlockAlertView alertWithTitle:@"提示" message:@"输入信息有误！请重新输入！"];
                [alert setDestructiveButtonWithTitle:@"确定" block:^{
                    [self backBtnClick:nil];
                }];
                [alert show];
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

-(int)startHttpRequest_second
{
    NSString *urlStr=@"http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/getWzcxXx.action";
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Referer" value:@"http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/wzcx_preview.jsp"];
    [request setRequestCookies:self.m_firstResponseCookieAry];

    //[request addRequestHeader:@"Accept-Language" value:@"zh-cn"];
    //[request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1"];
    //[request addRequestHeader:@"Origin" value:@"http://sslk.bjjtgl.gov.cn"];
    //[request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"];
    //[request addRequestHeader:@"Accept-Encoding" value:@"gzip, deflate"];
    //[request addRequestHeader:@"Connection" value:@"keep-alive"];

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
    //carnono=phq600&sf=11&fdjhhm=80229789&ip=125.39.34.215&c_flag=0&yzm=%E8%B6%85 -->超 -->me
    //carnono=phq600&sf=11&fdjhhm=80229789&ip=125.39.34.215&c_flag=0&yzm=%E8%B6%85 -->超 -->safari
    //设置验证码文本
    [request setPostValue:m_codeTextField.text forKey:@"yzm"];
    [request startSynchronous];
    
    NSError* error=[request error];
    if (error) {
        return 0;
    }else{
        CustomLog(@"<<Chao-->CSAuthCodeViewController-->startHttpRequest_second-->[request responseString] : %@",[request responseString]);
        if ([request responseStatusCode]==200) {
            if ([request responseString]) {
                //NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                //NSString *testResponseString = [[NSString alloc] initWithData:[request responseData] encoding:gbkEncoding];
                //CustomLog(@"<<Chao-->ApplicationRequest-->startHttpRequest_UserMessage-->testResponseString:%@",testResponseString);
                
                //解析第一步的html数据 同时设置内容
                NSData* data=[[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
                TFHpple* doc = [[TFHpple alloc] initWithHTMLData:data];
                NSArray* backDataAry=[doc searchWithXPathQuery:@"//table[@class='tab_2']//tbody//tr"];
                //CustomLog(@"<<Chao-->CSAuthCodeViewController-->startHttpRequest_second-->backDataAry : %@",backDataAry);
                if ([backDataAry count]) {
                    NSMutableArray* dataArray=[NSMutableArray arrayWithCapacity:3];
                    for (TFHppleElement* element in backDataAry) {
                        NSArray* listArray=element.children;    //<td>*****</td>
                        if ([listArray count]) {
                            int flag=-1;
                            NSMutableArray* indexArray=[NSMutableArray arrayWithCapacity:3];
                            for (int i=0; i<[listArray count]; i++) {
                                TFHppleElement* element=[listArray objectAtIndex:i];
                                if ([element.tagName isEqualToString:@"td"]) {
                                    flag++;
                                    CustomLog(@"<<Chao-->CSAuthCodeViewController-->startHttpRequest_second-->element:%d ------- element:%@",flag,element);

                                    switch (flag) {
                                        case 0:
                                        case 1:
                                        case 2:
                                        case 4:
                                        case 5:
                                        case 6:
                                        case 7:
                                        {
                                            NSArray* child=element.children;
                                            if ([child count]) {
                                                TFHppleElement* data=[child objectAtIndex:0];
                                                [indexArray addObject:[NSString stringWithFormat:@"%@",data.content]];
                                            }
                                        }
                                            break;
                                        case 3:
                                        {
                                            NSArray* child=element.children;
                                            if ([child count]) {
                                                for (TFHppleElement* subTag in child) {
                                                    if ([subTag.tagName isEqualToString:@"a"]) {
                                                        TFHppleElement* dataSub=[subTag.children objectAtIndex:0];
                                                        [indexArray addObject:[NSString stringWithFormat:@"%@",dataSub.content]];
                                                    }
                                                }
                                            }
                                        }
                                            break;
                                        default:
                                            break;
                                    }
                                }
                            }
                    
                            //添加记录到数组中
                            [dataArray addObject:indexArray];
                        }else{
                            //没有违章记录
                        }
                    }
                    CustomLog(@"<<Chao-->CSAuthCodeViewController-->startHttpRequest_second-->dataArray : %@",dataArray);
                    self.m_dataArray=dataArray;
                    return 2;
                }else{
                    //验证码错误问题
                    NSArray* errorAry=[doc searchWithXPathQuery:@"//script[@type='text/javascript']"];
                    if ([errorAry count]) {
                        for (TFHppleElement* errorE in errorAry) {
                            NSArray* subArray=errorE.children;
                            if ([subArray count]) {
                                TFHppleElement* subE=[subArray objectAtIndex:0];
                                if ([subE.content isEqualToString:@"alert('验证码输入有误！请重新输入！');"]) {
                                    return 1;
                                }else if ([subE.content isEqualToString:@"alert('输入信息有误！请重新输入！');"]){
                                    return 4;
                                }
                            }
                        }
                    }else{
                        //超时，请重新查询。
                        NSArray* errorAry=[doc searchWithXPathQuery:@"//title"];
                        if (errorAry) {
                            for (TFHppleElement* element in errorAry) {
                                if ([[(TFHppleElement*)[element.children objectAtIndex:0] content] isEqualToString:@"记分查询结果"]) {
                                    NSArray* array1=[doc searchWithXPathQuery:@"//div[@class='div_tab1']//tr//td"];
                                    if ([array1 count]) {
                                        for (TFHppleElement* element in array1) {
                                            if ([[(TFHppleElement*)[element.children objectAtIndex:0] content] rangeOfString:@"超时"].length) {
                                                return 3;
                                            }
                                        }
                                    }
                                }
                                else{
                                    
                                }
                            }
                        }

                    }
                }
            }else{
                
            }
        }else{
            
        }
    }
    
    return 0;
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
    [m_codeTextField resignFirstResponder];
    [self startHttpRequest_final];
}

-(void)getCodeBtnClick:(id)sender
{
    [m_codeTextField resignFirstResponder];
    [self startHttpRequest];
}

-(void)asynImageViewClick:(UIGestureRecognizer*)sender
{
    [m_codeTextField resignFirstResponder];
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