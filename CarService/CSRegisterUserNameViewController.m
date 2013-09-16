//
//  RegisterUserNameViewController.m
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "CSRegisterUserNameViewController.h"
#import "ASIFormDataRequest.h"
#import "CSAppDelegate.h"
#import "Util.h"
#import "URLConfig.h"
#import "NSString+SBJSON.h"

@interface CSRegisterUserNameViewController ()

@property (nonatomic,retain) IBOutlet UITextField *phoneNumberField;
@property (nonatomic,retain) IBOutlet UIImageView *phoneNumberBackView;
@property (nonatomic,retain) IBOutlet UITextField *idField;
@property (nonatomic,retain) IBOutlet UIImageView *idBackView;
@property (nonatomic,retain) IBOutlet UITextField *driverLicenceField;
@property (nonatomic,retain) IBOutlet UIImageView *driverLicenseBackView;
@property (nonatomic,retain) IBOutlet UITextField *secretCodeField;
@property (nonatomic,retain) IBOutlet UIImageView *secretCodeBackView;
@property (nonatomic,retain) IBOutlet UITextField *checkSecretCodeField;
@property (nonatomic,retain) IBOutlet UIImageView *checkSecretCodeBackView;
@property (nonatomic,retain) IBOutlet UIView *backView;
@property (nonatomic,retain) IBOutlet UIView *inputBackView;
@property (nonatomic,retain) IBOutlet ASIFormDataRequest *registerRequest;
@property (nonatomic,retain) IBOutlet UIButton *registerButton;
@property (nonatomic,retain) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic,retain) IBOutlet ASIHTTPRequest *getVerifyCodeRequest;

- (void)adjustSubView:(int)startY;

@end

@implementation CSRegisterUserNameViewController
@synthesize secretCodeField;
@synthesize checkSecretCodeField;
@synthesize backView;
@synthesize inputBackView;
@synthesize registerRequest;
@synthesize phoneNumberField;
@synthesize idField;
@synthesize driverLicenceField;
@synthesize phoneNumberBackView;
@synthesize idBackView;
@synthesize driverLicenseBackView;
@synthesize secretCodeBackView;
@synthesize checkSecretCodeBackView;
@synthesize registerButton;
@synthesize contentScrollView;
@synthesize getVerifyCodeRequest;

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
    self.contentScrollView.contentSize = CGSizeMake(320, self.view.frame.size.height - 40 );
    if (Is_iPhone5)
    {
       // self.inputBackView.frame = 
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //点击页面使键盘消失
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];

}

- (void)hideKeyBoard
{
    [self.phoneNumberField resignFirstResponder];
    [self.idField resignFirstResponder];
    [self.driverLicenceField resignFirstResponder];
    [self.secretCodeField resignFirstResponder];
    [self.checkSecretCodeField resignFirstResponder];
}

- (void)adjustSubView:(int)startY
{
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
            self.phoneNumberBackView.frame = CGRectMake(self.phoneNumberBackView.frame.origin.x, startY, self.phoneNumberBackView.frame.size.width, self.phoneNumberBackView.frame.size.height);
            self.phoneNumberField.frame = CGRectMake(self.phoneNumberField.frame.origin.x, startY + 1, self.phoneNumberField.frame.size.width, self.phoneNumberField.frame.size.height);
            self.idBackView.frame = CGRectMake(self.idBackView.frame.origin.x, startY + 40, self.idBackView.frame.size.width, self.idBackView.frame.size.height);
            self.idField.frame = CGRectMake(self.idField.frame.origin.x, startY + 40, self.idField.frame.size.width, self.idField.frame.size.height);
            self.driverLicenseBackView.frame = CGRectMake(self.driverLicenseBackView.frame.origin.x, startY + 80, self.driverLicenseBackView.frame.size.width, self.driverLicenseBackView.frame.size.height);
            self.driverLicenceField.frame = CGRectMake(self.driverLicenceField.frame.origin.x, startY + 80, self.driverLicenceField.frame.size.width, self.driverLicenceField.frame.size.height);
            self.secretCodeBackView.frame = CGRectMake(self.secretCodeBackView.frame.origin.x, startY + 120, self.secretCodeBackView.frame.size.width, self.secretCodeBackView.frame.size.height);
            self.secretCodeField.frame = CGRectMake(self.secretCodeField.frame.origin.x, startY + 120, self.secretCodeField.frame.size.width, self.secretCodeField.frame.size.height);
            self.checkSecretCodeBackView.frame = CGRectMake(self.checkSecretCodeBackView.frame.origin.x, startY + 160, self.checkSecretCodeBackView.frame.size.width, self.checkSecretCodeBackView.frame.size.height);
            self.checkSecretCodeField.frame = CGRectMake(self.checkSecretCodeField.frame.origin.x, startY + 160, self.checkSecretCodeField.frame.size.width, self.checkSecretCodeField.frame.size.height);
            self.registerButton.frame = CGRectMake(self.registerButton.frame.origin.x, startY + 220, self.registerButton.frame.size.width, self.registerButton.frame.size.height);

        }
    }];

}

#pragma mark KeyBoradNotification

- (void)keyboardWillShow:(NSNotification *)notification 
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CustomLog(@"frame:%f,%f,%f,%f",keyboardRect.origin.x,keyboardRect.origin.y,keyboardRect.size.width,keyboardRect.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
            if ([self.phoneNumberField isFirstResponder] || [self.idField isFirstResponder])
            {
                CustomLog(@"Do Nothing");
            }
            else if ([self.driverLicenceField isFirstResponder])
            {
                [self adjustSubView:-40];
            }
            else if ([self.secretCodeField isFirstResponder])
            {
                [self adjustSubView:-60];
            }
            else if([self.checkSecretCodeField isFirstResponder])
            {
                [self adjustSubView:-80];
            }
        }
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification 
{
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
            //self.inputBackView.frame = CGRectMake(15, 115, self.inputBackView.frame.size.width, self.inputBackView.frame.size.height);
            [self adjustSubView:10];
        }
    }];
    
}
/*
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
            [self adjustSubView:-80];

        }
    }];
    
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [secretCodeField release];
    [checkSecretCodeField release];
    [backView release];
    [inputBackView release];
    [registerRequest clearDelegatesAndCancel];
    [registerRequest release];
    [phoneNumberField release];
    [idField release];
    [driverLicenceField release];
    [phoneNumberBackView release];
    [idBackView release];
    [driverLicenseBackView release];
    [secretCodeBackView release];
    [checkSecretCodeBackView release];
    [registerButton release];
    [contentScrollView release];
    [getVerifyCodeRequest  clearDelegatesAndCancel];
    [getVerifyCodeRequest release];
    [super dealloc];
}

#pragma mark - button click methods

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButtonPressed:(id)sender
{
    if ([self.phoneNumberField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"手机号不能为空!"];
        return;
    }
    if ([self.idField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"身份证号不能为空!"];
        return;
    }
    if ([self.driverLicenceField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"驾驶证号不能为空!"];
        return;
    }
    
    if ([self.secretCodeField.text length] == 0 || [self.checkSecretCodeField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"密码不能为空!"];
        return;
    }

    if (![self.secretCodeField.text isEqualToString:self.checkSecretCodeField.text])
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"两次输入密码不一致，请重新输入!"];
        return;
    }
    
    [self.registerRequest clearDelegatesAndCancel];
    self.registerRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_register]];
    [self.registerRequest setPostValue:@"1" forKey:@"status"];
    [self.registerRequest setRequestMethod:@"POST"];
    [self.registerRequest setPostValue:self.driverLicenceField.text forKey:@"username"];
    [self.registerRequest setPostValue:self.secretCodeField.text forKey:@"password"];
    [self.registerRequest setPostValue:self.checkSecretCodeField.text forKey:@"password2"];
    [self.registerRequest setPostValue:self.idField.text forKey:@"email"];
    self.registerRequest.delegate = self;
    [self.registerRequest setDidFinishSelector:@selector(requestDidFinished:)];
    [self.registerRequest setDidFailSelector:@selector(requestDidFailed:)];
    [self.registerRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleGray];
    
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
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"注册失败，请重新输入"];
        return;
    }
    else
    {
        int code = [[requestDic objectForKey:@"code"] intValue];
        switch (code) {
            case 0:
                /*[[NSUserDefaults standardUserDefaults] setObject:[requestDic objectForKey:@"data"] forKey:UserDefaultUserInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];*/
                [[Util sharedUtil] showAlertWithTitle:@"提示" message:@"恭喜您，注册成功!"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[requestDic objectForKey:@"data"] forKey:UserDefaultUserInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //CSAppDelegate *del = [UIApplication sharedApplication].delegate;
                //[del updatePushTag];
                
                [[NSNotificationCenter defaultCenter ] postNotificationName:LoginSuccessNotification object:nil userInfo:nil];

                break;
            case -1:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"验证码不正确,请重新输入!"];
                break;
            case -2:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"账户名不合法,请重新输入!"];
                break;
            case -3:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"密码不合法,请重新输入!"];
            case -4:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"两次输入的密码不一致,请重新输入!"];
                break;
            case -5:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"邮箱格式不正确,请重新输入!"];
                break;
            case -6:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"账户名已经注册过了,请重新输入!"];
                break;
            case -7:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"邮箱已经注册过了,请重新输入!"];
                break;
            default:
                 [[Util sharedUtil] showAlertWithTitle:@"" message:@"注册失败,请重新输入!"];
                break;
        }
    }
}

- (void)requestDidFailed:(ASIHTTPRequest *)request
{
    [self hideActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"注册失败，请检查网络连接"];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

#pragma mark -UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField       // became first responder
{
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
            if ([self.phoneNumberField isFirstResponder] || [self.idField isFirstResponder])
            {
                CustomLog(@"Do Nothing");
                [self adjustSubView:0];
            }
            else if ([self.idField isFirstResponder])
            {
                [self adjustSubView:0];
            }
            else if ([self.driverLicenceField isFirstResponder])
            {
                [self adjustSubView:-40];
            }
            else if ([self.secretCodeField isFirstResponder])
            {
                [self adjustSubView:-60];
            }
            else if([self.checkSecretCodeField isFirstResponder])
            {
                [self adjustSubView:-80];
            }
        }
    }];

}

@end
