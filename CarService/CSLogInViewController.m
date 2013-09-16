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
#import "CSForthViewController.h"
#import "NSString+SBJSON.h"

#define AnimationChangeHeight 105

@interface CSLogInViewController ()

@property (nonatomic,retain) IBOutlet UITextField *userNameField;
@property (nonatomic,retain) IBOutlet UITextField *passwordField;
@property (nonatomic,retain) IBOutlet UIView *backView;
@property (nonatomic,retain) ASIFormDataRequest *loginRequest;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,assign) BOOL rememberPassword;
@property (nonatomic,retain) IBOutlet UIButton *rememberPasswordButton;
@property (nonatomic,retain) NSDictionary *userInfo;
@property (nonatomic,assign) BOOL keyboardShowed;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    self.scrollView.contentSize = CGSizeMake(320, self.view.frame.size.height - 40 - 49);
    rememberPassword = YES;
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
    
    if (Is_iPhone5) 
    {
       // self.loginBackView.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
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
    self.loginRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_login]];
    [self.loginRequest setRequestMethod:@"POST"];
    [self.loginRequest setPostValue:@"1" forKey:@"status"];
    [self.loginRequest setPostValue:self.userNameField.text forKey:@"username"];
    [self.loginRequest setPostValue:self.passwordField.text forKey:@"password"];
    self.loginRequest.delegate = self;
    [self.loginRequest setDidFinishSelector:@selector(requestDidFinished:)];
    [self.loginRequest setDidFailSelector:@selector(requestDidFailed:)];
    [self.loginRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleGray];
    
    self.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.userNameField.text,@"username",self.passwordField.text,@"password", nil];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.parentController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButtonPressed:(id)sender
{
    CustomLog(@"enter register view controller");
    
    CSRegisterUserNameViewController *controller = [[CSRegisterUserNameViewController alloc] initWithNibName:@"CSRegisterUserNameViewController" bundle:nil];
    [self.parentController.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)remeberPasswordButtonPressed:(id)sender
{
    self.rememberPassword = !self.rememberPassword;
    
    if (self.rememberPassword)
    {
        [self.rememberPasswordButton setBackgroundImage:[UIImage imageNamed:@"denglu_check_yes.png"] forState:UIControlStateNormal];
        [self.rememberPasswordButton setBackgroundImage:[UIImage imageNamed:@"denglu_check_yes.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.rememberPasswordButton setBackgroundImage:[UIImage imageNamed:@"denglu_check_no.png"] forState:UIControlStateNormal];
        [self.rememberPasswordButton setBackgroundImage:[UIImage imageNamed:@"denglu_check_no.png"] forState:UIControlStateHighlighted];
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
    NSDictionary *requestDic = [[request responseString] JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == [requestDic objectForKey:@"code"]) 
    {
        CustomLog(@"parse error");
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"登陆失败，请重新登陆"];
        return;
    }
    else
    {
        int code = [[requestDic objectForKey:@"code"] intValue];
        switch (code) {
            case 0:
                CustomLog(@"登陆成功");
                [[NSUserDefaults standardUserDefaults] setObject:[requestDic objectForKey:@"data"] forKey:UserDefaultUserInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //CSAppDelegate *del = [UIApplication sharedApplication].delegate;
                //[del updatePushTag];
                
                //授权第三方登陆
                if ([[[requestDic objectForKey:@"data"] objectForKey:@"sina"]  isKindOfClass:[NSDictionary class]] && nil != [[[requestDic objectForKey:@"data"] objectForKey:@"sina"] objectForKey:@"token"])
                {
                    /*NSString *tokenStr = [[[requestDic objectForKey:@"data"] objectForKey:@"sina"] objectForKey:@"token"];
                    id <ISSCredential> credential = [ShareSDK credentialWithData:[tokenStr dataUsingEncoding:NSUTF8StringEncoding] type:ShareTypeSinaWeibo];
                    [ShareSDK setCredential:credential type:ShareTypeSinaWeibo];
                    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
                    {
                        CustomLog(@"success");
                    }
                    else
                    {
                        CustomLog(@"fail");
                    }*/
                }
                
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
                
                [[Util sharedUtil] showCookieInfo];

                break;
            case -1:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"账户名不合法,请重新输入!"];
                break;
            case -2:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"密码不合法,请重新输入!"];
                break;
            case -3:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"账户名不存在或密码不正确,请重新输入!"];
                break;
            case -4:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"您的错误次数已超过5次，请15分钟后再尝试!"];
                break;
            default:
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
    
    /*NSDictionary *tempUserInfo = [notification userInfo];
    NSValue* aValue = [tempUserInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CustomLog(@"frame:%f,%f,%f,%f",keyboardRect.origin.x,keyboardRect.origin.y,keyboardRect.size.width,keyboardRect.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y - (AnimationChangeHeight - DeviceDiffHeight), self.backView.frame.size.width, self.backView.frame.size.height);

        }
        else
        {
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y - AnimationChangeHeight, self.backView.frame.size.width, self.backView.frame.size.height);

        }
    }];*/

}

- (void)keyboardWillHide:(NSNotification *)notification 
{
    if (!self.userNameField.isFirstResponder && !self.passwordField.isFirstResponder)
    {
        return;
    }
    
    keyboardShowed = NO;

   /* [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y + (AnimationChangeHeight - DeviceDiffHeight), self.backView.frame.size.width, self.backView.frame.size.height);
        }
        else
        {
            self.backView.frame = CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y + AnimationChangeHeight, self.backView.frame.size.width, self.backView.frame.size.height);
        }
    }];*/

}

- (void)dealloc
{
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
