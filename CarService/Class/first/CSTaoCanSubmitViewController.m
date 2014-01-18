//
//  CSTaoCanSubmitViewController.m
//  CarService
//
//  Created by baidu on 14-1-10.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSTaoCanSubmitViewController.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ActionSheetDatePicker.h"
#import "MBProgressHUD.h"

#define NSStringIsUseless(_str) (_str==nil || _str ==(NSString*)[NSNull null] || [_str length]==0)

@interface CSTaoCanSubmitViewController ()<MBProgressHUDDelegate>
{
    TPKeyboardAvoidingScrollView* _scrollView;
}

@property(readonly,retain)MBProgressHUD *alertView;

@end

@implementation CSTaoCanSubmitViewController
@synthesize alertView;

- (id)initWithNibName:(NSDictionary *)aDict
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.m_dataDict=[NSMutableDictionary dictionaryWithDictionary:aDict];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [aLabel setTextColor:[UIColor blackColor]];
    [aLabel setText:text];
    aLabel.numberOfLines=0;
    aLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [superView addSubview:aLabel];
    [aLabel release];
}

-(void)initSelfView{
    CGRect frame=CGRectMake(10, DiffY+44+4, [UIScreen mainScreen].bounds.size.width-10*2, CSTabelViewHeight);
    UIImageView* tabviewBg=[[UIImageView alloc] initWithFrame:frame];
    [tabviewBg setImage:[ApplicationPublic getOriginImage:@"new_xiaofeijilu_liebiaoxinxi_toumingbeijing.png" withInset:UIEdgeInsetsMake(40, 40, 40, 40)]];
    tabviewBg.backgroundColor =[UIColor clearColor];
    [self.view addSubview:tabviewBg];
    [tabviewBg release];
    
    TPKeyboardAvoidingScrollView* scrollView=[[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectInset(frame, 5, 5)];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    [scrollView release];
    _scrollView=scrollView;
    {
        float x, y, width, height;
        
        //联系人
        x=0; y=0; width=scrollView.frame.size.width; height=50;
        [ApplicationPublic setUp_UITextField:scrollView with_frame:CGRectMake(x, y, width, height) with_tag:1001 with_placeHolder:@"" with_delegate:self];
        {
            UITextField* aField=(UITextField*)[scrollView viewWithTag:1001];
            if (aField) {
                [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaogetoubu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
                [ApplicationPublic setLeftView:aField text:@"联系人(必填)：" flag:YES fontSize:15.0];
            }
        }
        
        //联系电话
        y=y+height+1;
        [ApplicationPublic setUp_UITextField:scrollView with_frame:CGRectMake(x, y, width, height) with_tag:1002 with_placeHolder:@"" with_delegate:self];
        {
            UITextField* aField=(UITextField*)[scrollView viewWithTag:1002];
            if (aField) {
                [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_zhongbu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
                [ApplicationPublic setLeftView:aField text:@"联系电话：" flag:YES fontSize:15.0];
            }
        }
        
        //邮箱地址
        y=y+height+1;
        [ApplicationPublic setUp_UITextField:scrollView with_frame:CGRectMake(x, y, width, height) with_tag:1003 with_placeHolder:@"" with_delegate:self];
        {
            UITextField* aField=(UITextField*)[scrollView viewWithTag:1003];
            if (aField) {
                [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_zhongbu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
                [ApplicationPublic setLeftView:aField text:@"邮箱地址：" flag:YES fontSize:15.0];
            }
        }
        //车牌号码：
        y=y+height+1;
        [ApplicationPublic setUp_UITextField:scrollView with_frame:CGRectMake(x, y, width, height) with_tag:1004 with_placeHolder:@"" with_delegate:self];
        {
            UITextField* aField=(UITextField*)[scrollView viewWithTag:1004];
            if (aField) {
                [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_zhongbu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
                [ApplicationPublic setLeftView:aField text:@"车牌号码：" flag:YES fontSize:15.0];
            }
        }
        //驾驶证领取日期
        y=y+height+1;
        [ApplicationPublic setUp_UITextField:scrollView with_frame:CGRectMake(x, y, width, height) with_tag:1005 with_placeHolder:@"" with_delegate:self];
        {
            UITextField* aField=(UITextField*)[scrollView viewWithTag:1005];
            if (aField) {
                [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_zhongbu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
                [ApplicationPublic setLeftView:aField text:@"驾驶证领取日期：" flag:YES fontSize:15.0];
            }
        }
        //行驶证领取日期
        y=y+height+1;
        [ApplicationPublic setUp_UITextField:scrollView with_frame:CGRectMake(x, y, width, height) with_tag:1006 with_placeHolder:@"" with_delegate:self];
        {
            UITextField* aField=(UITextField*)[scrollView viewWithTag:1006];
            if (aField) {
                [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_zhongbu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
                [ApplicationPublic setLeftView:aField text:@"行驶证领取日期：" flag:YES fontSize:15.0];
            }
        }
        //发动机号
        y=y+height+1;
        [ApplicationPublic setUp_UITextField:scrollView with_frame:CGRectMake(x, y, width, height) with_tag:1007 with_placeHolder:@"" with_delegate:self];
        {
            UITextField* aField=(UITextField*)[scrollView viewWithTag:1007];
            if (aField) {
                [aField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_biaoge_dibu.png" withInset:UIEdgeInsetsMake(25, 25, 25, 25)]];
                [ApplicationPublic setLeftView:aField text:@"发动机号：" flag:YES fontSize:15.0];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ApplicationPublic selfDefineBg:self.view];
    {
        //添加按钮
        float x, y, width, height;
        x=0; y=0; width=34; height=34;
        UIButton* addCarBtn=[[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)] autorelease];
        [addCarBtn setBackgroundImage:[[UIImage imageNamed:@"new_baoxun.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [addCarBtn setBackgroundImage:[[UIImage imageNamed:@"new_baoxun_selected.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
        [addCarBtn addTarget:self action:@selector(addCarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [ApplicationPublic selfDefineNavigationBar:self.view title:@"套餐详情" withTarget:self with_action:@selector(backBtnClicked:) rightBtn:addCarBtn];
    }
    [self initSelfView];
}

-(void)backBtnClicked:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.m_dataDict=nil;
    [super dealloc];
}

-(void)addCarBtnClicked:(UIButton*)sender
{
    //检验数据合法性
    NSMutableDictionary* dictSubmit=[NSMutableDictionary dictionaryWithCapacity:3];
    BOOL backB=[self isDataValidate:dictSubmit];
    
    //网络请求
    if (backB) {
        [self startHttpRequest:dictSubmit];
    }

}

-(BOOL)isDataValidate:(NSMutableDictionary*)dictSubmit
{
    //联系人
    {
        UITextField* aField=(UITextField*)[_scrollView viewWithTag:1001];
        if (aField) {
            if (!NSStringIsUseless(aField.text)) {
                [dictSubmit setObject:aField.text forKey:@"username"];
            }
        }
        if (![dictSubmit objectForKey:@"username"]) {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"联系人不能为空！" message:@""];
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert show];
            return NO;
        }
    }
    
    //联系电话
    {
        UITextField* aField=(UITextField*)[_scrollView viewWithTag:1002];
        if (aField) {
            if (!NSStringIsUseless(aField.text)) {
                [dictSubmit setObject:aField.text forKey:@"phone"];
            }
        }
        if (![dictSubmit objectForKey:@"phone"]) {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"联系电话不能为空！" message:@""];
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert show];
            return NO;
        }
    }
    
    //邮箱地址
    {
        UITextField* aField=(UITextField*)[_scrollView viewWithTag:1003];
        if (aField) {
            if (!NSStringIsUseless(aField.text)) {
                [dictSubmit setObject:aField.text forKey:@"email"];
            }
        }
        if (![dictSubmit objectForKey:@"email"]) {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"邮箱地址不能为空！" message:@""];
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert show];
            return NO;
        }
    }
    //车牌号码
    {
        UITextField* aField=(UITextField*)[_scrollView viewWithTag:1004];
        if (aField) {
            if (!NSStringIsUseless(aField.text)) {
                [dictSubmit setObject:aField.text forKey:@"carcard"];
            }
        }
        if (![dictSubmit objectForKey:@"carcard"]) {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"车牌号码不能为空！" message:@""];
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert show];
            return NO;
        }
    }
    //驾驶证领取日期
    {
        UITextField* aField=(UITextField*)[_scrollView viewWithTag:1005];
        if (aField) {
            if (!NSStringIsUseless(aField.text)) {
                [dictSubmit setObject:aField.text forKey:@"drivecard_addtime"];
            }
        }
        if (![dictSubmit objectForKey:@"drivecard_addtime"]) {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"请选择驾驶证领取日期！" message:@""];
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert show];
            return NO;
        }
    }
    //行驶证领取日期
    {
        UITextField* aField=(UITextField*)[_scrollView viewWithTag:1006];
        if (aField) {
            if (!NSStringIsUseless(aField.text)) {
                [dictSubmit setObject:aField.text forKey:@"xsz_addtime"];
            }
        }
        if (![dictSubmit objectForKey:@"xsz_addtime"]) {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"请选择行驶证领取日期！" message:@""];
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert show];
            return NO;
        }
    }
    //发动机号
    {
        UITextField* aField=(UITextField*)[_scrollView viewWithTag:1007];
        if (aField) {
            if (!NSStringIsUseless(aField.text)) {
                [dictSubmit setObject:aField.text forKey:@"fadongjihao"];
            }
        }
        if (![dictSubmit objectForKey:@"fadongjihao"]) {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"发动号不能为空" message:@""];
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert show];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark 网络相关

-(void)startHttpRequest:(NSMutableDictionary*)submitDict{
    {
        self.alertView.mode = MBProgressHUDModeText;
        self.alertView.labelText = NSLocalizedString(@"提交中...", nil);
        [self.alertView show:YES];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlStr = [[NSString stringWithFormat:@"%@?json={\"action\":\"mall_order\",\"mallname\":\"%@\",\"mid\":\"%@\",\"username\":\"%@\",\"email\":\"%@\",\"phone\":\"%@\",\"carcard\":\"%@\",\"drivecard_addtime\":\"%@\",\"xsz_addtime\":\"%@\",\"fadongjihao\":\"%@\"}",
                             ServerAddress,
                             [self.m_dataDict objectForKey:@"mallname"],
                             [self.m_dataDict objectForKey:@"id"],
                             
                             [submitDict objectForKey:@"username"],
                             [submitDict objectForKey:@"email"],
                             [submitDict objectForKey:@"phone"],
                             [submitDict objectForKey:@"carcard"],
                             [submitDict objectForKey:@"drivecard_addtime"],
                             [submitDict objectForKey:@"xsz_addtime"],
                             [submitDict objectForKey:@"fadongjihao"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

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
                        case 2:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"套餐名为空！", nil) with_type:TSMessageNotificationTypeError];
                            break;
                        case 3:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"套餐id为空！", nil) with_type:TSMessageNotificationTypeError];
                            break;
                        case 4:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"联系人为空！", nil) with_type:TSMessageNotificationTypeError];
                            break;
                        case 5:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"邮箱地址为空！", nil) with_type:TSMessageNotificationTypeError];
                            break;
                        case 6:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"联系电话为空！", nil) with_type:TSMessageNotificationTypeError];
                            break;
                        case 7:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"车牌号为空！", nil) with_type:TSMessageNotificationTypeError];
                            break;
                        case 8:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"驾驶证领取日期为空！", nil) with_type:TSMessageNotificationTypeError];
                            break;
                        case 9:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"行驶证领取日期为空！", nil) with_type:TSMessageNotificationTypeError];
                            break;
                        case 10:
                            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"发动机号为空！", nil) with_type:TSMessageNotificationTypeError];
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

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==1005 || textField.tag==1006) {
        [ActionSheetDatePicker showPickerWithTitle:@"选择日期"
                                    datePickerMode:UIDatePickerModeDate
                                      selectedDate:[NSDate date]
                                            target:self
                                            action:@selector(dateWasSelected:element:)
                                            origin:textField];
        return NO;
    }
    
    return YES;
}

// 选择查询日期
-(void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    if (selectedDate!=nil && element!=nil) {
        UITextField* textField = (UITextField*)element;
        if (textField) {
            //显示到中间
            [textField setTextAlignment:NSTextAlignmentCenter];
            
            NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString* formatStr=[formatter stringFromDate:selectedDate];
            [textField setText:formatStr];
        }
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
// Remove HUD from screen when the HUD was hidded
- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (alertView&&alertView.superview) {
        alertView.delegate = nil;
        [alertView removeFromSuperview];
        alertView=nil;
    }
}
- (MBProgressHUD*) alertView
{
    if (alertView==nil) {
        id delegate = [UIApplication sharedApplication].delegate;
        UIWindow *window = [delegate window];
        alertView = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:alertView];
        //        alertView.dimBackground = YES;
        alertView.labelText = NSLocalizedString(@"加载中", @"");
        alertView.delegate = self;
    }
    return alertView;
}


@end
