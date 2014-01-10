//
//  CSWoYaoTouBaoSubmitViewCtrler.m
//  CarService
//
//  Created by baidu on 14-1-10.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSWoYaoTouBaoSubmitViewCtrler.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"

@interface CSWoYaoTouBaoSubmitViewCtrler ()<MBProgressHUDDelegate>
{
    
}
@property(readonly,assign)MBProgressHUD *alertView;

@end

@implementation CSWoYaoTouBaoSubmitViewCtrler
@synthesize alertView;

-(void)init_selfView
{
    CGRect frame=CGRectMake(10, DiffY+44+4, [UIScreen mainScreen].bounds.size.width-10*2, CSTabelViewHeight);
    UIImageView* tabviewBg=[[UIImageView alloc] initWithFrame:frame];
    [tabviewBg setImage:[ApplicationPublic getOriginImage:@"new_xiaofeijilu_liebiaoxinxi_toumingbeijing.png" withInset:UIEdgeInsetsMake(40, 40, 40, 40)]];
    tabviewBg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:tabviewBg];
    [tabviewBg release];
    
    float x, y, width, height;
    //投保人姓名
    x=frame.origin.x+5; y=frame.origin.y+5; width=frame.size.width-5*2; height=40;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:101 with_placeHolder:@"车牌号" with_delegate:self];
    
    //联系电话
    y=y+height+1;
    [ApplicationPublic setUp_UITextField:self.view with_frame:CGRectMake(x, y, width, height) with_tag:102 with_placeHolder:@"联系电话" with_delegate:self];
   
    //查询
    width=133/2.0+20; x=(320-width)/2.0; y=y+height+30; height=48/2.0+10;
    UIButton* queryBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [queryBtn setTitle:@"提 交" forState:UIControlStateNormal];
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

#pragma mark - 点击事件
-(void)queryBtnClick:(id)sender
{
    //姓名
    UITextField* aTextField=(UITextField*)[self.view viewWithTag:101];
    if (aTextField.text.length==0) {
        [ApplicationPublic showMessage:self with_title:@"请输入车牌号！" with_detail:@"" with_type:TSMessageNotificationTypeError with_Duration:2.0];
        return;
    }
    //手机号
    UITextField* bTextField=(UITextField*)[self.view viewWithTag:102];
    if (bTextField.text.length==0) {
        [ApplicationPublic showMessage:self with_title:@"请输入联系电话！" with_detail:@"" with_type:TSMessageNotificationTypeError with_Duration:2.0];
        return;
    }
    
    //开始网络请求
    NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:aTextField.text, @"tel", bTextField.text, @"idcar", nil];
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
        
        NSString *urlStr = [[NSString stringWithFormat:@"%@?json={\"action\":\"toubao\",\"tel\":\"%@\",\"idcar\":\"%@\"}",
                             ServerAddress,
                             [dict objectForKey:@"tel"],
                             [dict objectForKey:@"idcar"]
                             ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
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
                            [self showMessage:NSLocalizedString(@"成功", nil) with_detail:NSLocalizedString(@"提交成功！", nil) with_type:TSMessageNotificationTypeSuccess];
                            [self performSelector:@selector(backBtnClicked:) withObject:nil afterDelay:1.5];
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
