//
//  LogInViewController.m
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "CSLogInViewController.h"
#import "ASIFormDataRequest.h"
#import "KeyChainUtil.h"
#import "CSAppDelegate.h"
#import "Util.h"
#import "URLConfig.h"
#import "CSRegisterUserNameViewController.h"
#import "NSString+SBJSON.h"
#import "CSForthViewController.h"
#import "CSThirdViewController.h"
#import "CSFirstViewController.h"

#define AnimationChangeHeight 170

@interface CSLogInViewController ()

@property (nonatomic,retain) IBOutlet UITextField *userNameField;
@property (nonatomic,retain) IBOutlet UITextField *passwordField;
@property (nonatomic,retain) IBOutlet UIView *backView;
@property (nonatomic,retain) ASIHTTPRequest *loginRequest;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,assign) BOOL rememberPassword;
@property (nonatomic,retain) IBOutlet UIButton *rememberPasswordButton;
@property (nonatomic,retain) NSDictionary *userInfo;
@property (nonatomic,assign) BOOL keyboardShowed;
//chao add
@property (nonatomic,retain) NSString* m_flagString;
@end

@implementation CSLogInViewController

@synthesize userNameField;
@synthesize passwordField;
@synthesize backView;
@synthesize loginRequest;
@synthesize scrollView;
@synthesize rememberPassword;
@synthesize rememberPasswordButton;
@synthesize userInfo;
@synthesize keyboardShowed;
@synthesize parentController;

@synthesize delegate;
@synthesize m_flagString;

- (id)initWithParentCtrler:(UIViewController*)viewCtrler witjFlagStr:(NSString*)aStr with_NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.parentController=viewCtrler;
        self.m_flagString=aStr;
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

-(void)backClicked
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.parentController && ([self.parentController isKindOfClass:[CSThirdViewController class]] || [self.parentController isKindOfClass:[CSFirstViewController class]])) {
        self.navigationItem.title=@"登录";
        [ApplicationPublic setUp_BackBtn:self.navigationItem withTarget:self with_action:@selector(backClicked)];
    }else{
        self.navigationController.navigationBar.hidden = YES;
    }
    self.scrollView.contentSize = CGSizeMake(320, self.view.frame.size.height - 40 - 49);
    rememberPassword = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHeightChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    keyboardShowed = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //点击页面使键盘消失
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.delegate = self;
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];
    
    
    //[self.userNameField becomeFirstResponder];
//    self.userNameField.text=@"15101059823";
//    self.passwordField.text=@"1";
    /*if (Is_iPhone5)
    {
        self.backView.frame = CGRectMake(self.backView.frame.origin.x,  - (AnimationChangeHeight - DeviceDiffHeight), self.backView.frame.size.width, self.backView.frame.size.height);
    }
    else
    {
        self.backView.frame = CGRectMake(self.backView.frame.origin.x,  - 100, self.backView.frame.size.width, self.backView.frame.size.height);

    }*/

}

- (void)hideKeyBoard
{
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)keyboardHeightChanged:(NSNotification *)notify
{
    NSDictionary *meInfo = [notify userInfo];
    NSValue *endRectValue = [meInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [endRectValue CGRectValue];
    CustomLog(@"rect :%f,%f,%f,%f",endRect.origin.x,endRect.origin.y,endRect.size.width,endRect.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
            CustomLog(@"enter here");
        }
    }];
    
}

- (IBAction)loginButtonPressed:(id)sender
{
    
    if ([self.userNameField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"用户名不能为空!"];
        return;
    }
    
    if ([self.passwordField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"密码不能为空!"];
        return;
    }
    
    [self hideKeyBoard];
    
    [self.loginRequest clearDelegatesAndCancel];
    
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"login",@"action",self.userNameField.text,@"phone",[self.passwordField.text md5String],@"password", nil];
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    self.loginRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];
    
    self.loginRequest.delegate = self;
    [self.loginRequest setDidFinishSelector:@selector(requestDidFinished:)];
    [self.loginRequest setDidFailSelector:@selector(requestDidFailed:)];
    [self.loginRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleGray];
    
    self.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.userNameField.text,@"username",self.passwordField.text,@"password", nil];
}

- (IBAction)backButtonPressed:(id)sender
{
    if ([self.parentController isKindOfClass:[CSForthViewController class]]) {
        [self.parentController.navigationController popViewControllerAnimated:YES];
    }else if ([self.parentController isKindOfClass:[CSThirdViewController class]]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([self.parentController isKindOfClass:[CSFirstViewController class]]){
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)registerButtonPressed:(id)sender
{
    CustomLog(@"enter register view controller");
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    if ([self.parentController isKindOfClass:[CSForthViewController class]]) {
        CSRegisterUserNameViewController *controller = [[CSRegisterUserNameViewController alloc] initWithNibName:@"CSRegisterUserNameViewController" bundle:nil];
        [self.parentController.navigationController pushViewController:controller animated:YES];
        [controller release];
    }else if (([self.parentController isKindOfClass:[CSThirdViewController class]] || [self.parentController isKindOfClass:[CSFirstViewController class]])){
        CSRegisterUserNameViewController *controller = [[CSRegisterUserNameViewController alloc] initWithNibName:@"CSRegisterUserNameViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

- (IBAction)remeberPasswordButtonPressed:(id)sender
{
    self.rememberPassword = !self.rememberPassword;
    
    if (self.rememberPassword)
    {
        [self.rememberPasswordButton setBackgroundImage:[UIImage imageNamed:@"new_denglu_fuxuankuang_dianji.png"] forState:UIControlStateNormal];
        [self.rememberPasswordButton setBackgroundImage:[UIImage imageNamed:@"new_denglu_fuxuankuang_dianji.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.rememberPasswordButton setBackgroundImage:[UIImage imageNamed:@"new_denglu_fuxuankuang.png"] forState:UIControlStateNormal];
        [self.rememberPasswordButton setBackgroundImage:[UIImage imageNamed:@"new_denglu_fuxuankuang.png"] forState:UIControlStateHighlighted];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITextField Delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ((textField == self.userNameField) && ([self.passwordField.text length] == 0) && ([self.userNameField.text length] > 0))
    {
        NSString *password = [[NSString alloc] initWithData:[KeyChainUtil load:self.userNameField.text] encoding:NSUTF8StringEncoding];
        if ([password length] > 0)
        {
            self.passwordField.text = password;
        }
        [password release];
    }
    return YES;
}

#pragma mark - ASIHttpRequest Delegate Methods

- (void)requestDidFinished:(ASIHTTPRequest *)request
{
    [self hideActView];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *testResponseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    CustomLog(@"response string:%@",testResponseString);
    NSDictionary *requestDic = [[request responseString] JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == [requestDic objectForKey:@"status"]) 
    {
        CustomLog(@"parse error");
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"登陆失败，请重新登陆"];
        return;
    }
    else
    {
        int code = [[requestDic objectForKey:@"status"] intValue];
        switch (code) {
            case 1:
            {
                CustomLog(@"登陆成功");
                
                NSMutableDictionary* dataDict=[NSMutableDictionary dictionaryWithDictionary:requestDic];
                [dataDict setObject:[self.userInfo objectForKey:@"username"] forKey:@"username"];
                [[Util sharedUtil] setLoginUserInfo:dataDict];
                [[Util sharedUtil] scheduleLocalNotification];
                //save user data in keychain
                if (rememberPassword)
                {
                    NSString *username = [self.userInfo objectForKey:@"username"];
                    NSString *password = [self.userInfo objectForKey:@"password"];
                    if ([username length] > 0 && [password length] > 0)
                    {
                        [KeyChainUtil delete:username];
                        [KeyChainUtil save:username data:[password dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                }
                
                [[NSNotificationCenter defaultCenter ] postNotificationName:LoginSuccessNotification object:nil userInfo:nil];

                if ([self.parentController isKindOfClass:[CSForthViewController class]]) {
                    
                }else if (([self.parentController isKindOfClass:[CSThirdViewController class]] || [self.parentController isKindOfClass:[CSFirstViewController class]])){
                    [self backClicked];
                    if (self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector(loginFinishCallBack:)]) {
                        [self.delegate loginFinishCallBack:self.m_flagString];
                    }
                }
            }
                break;
            case 0:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"登陆失败,请重新输入!"];
                break;
            case 2:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"手机号码为空,请重新输入!"];
                break;
            case 3:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"密码为空,请重新输入!"];
                break;
            default:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"登陆失败,请重新输入!"];
                break;
        }
    }
}

- (void)requestDidFailed:(ASIHTTPRequest *)request
{
    [self hideActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"登陆失败，请检查网络连接"];
}

#pragma mark KeyBoradNotification

- (void)keyboardWillShow:(NSNotification *)notification 
{
    if (!self.userNameField.isFirstResponder && !self.passwordField.isFirstResponder)
    {
        return;
    }
    
    if (!keyboardShowed)
    {
        keyboardShowed = YES;
    }
    else
    {
        return;
    }
    
    NSDictionary *tempUserInfo = [notification userInfo];
    NSValue* aValue = [tempUserInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CustomLog(@"frame:%f,%f,%f,%f",keyboardRect.origin.x,keyboardRect.origin.y,keyboardRect.size.width,keyboardRect.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            self.backView.frame = CGRectMake(self.backView.frame.origin.x,  - 70, self.backView.frame.size.width, self.backView.frame.size.height);

        }
        else
        {
            self.backView.frame = CGRectMake(self.backView.frame.origin.x,  - 160, self.backView.frame.size.width, self.backView.frame.size.height);

        }
    }];

}

- (void)keyboardWillHide:(NSNotification *)notification 
{
    if (!self.userNameField.isFirstResponder && !self.passwordField.isFirstResponder)
    {
        return;
    }
    
    keyboardShowed = NO;

    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, 20, self.backView.frame.size.width, self.backView.frame.size.height);
        }
        else
        {
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, 20, self.backView.frame.size.width, self.backView.frame.size.height);
        }
    }];

}

- (void)dealloc
{
    CustomLog(@"dealloc login viewcontroller");
    self.m_flagString=nil;
    [self hideKeyBoard];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [userNameField release];
    [passwordField release];
    [backView release];
    [loginRequest clearDelegatesAndCancel];
    [loginRequest release];
    [scrollView release];
    [rememberPasswordButton release];
    [userInfo release];
    [super dealloc];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

#pragma mark - UIGesture Delegate Method

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
