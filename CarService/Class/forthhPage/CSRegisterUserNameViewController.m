//
//  RegisterUserNameViewController.m
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "CSRegisterUserNameViewController.h"
#import "ASIHTTPRequest.h"
#import "CSAppDelegate.h"
#import "Util.h"
#import "URLConfig.h"
#import "NSString+SBJSON.h"
#import "SBJSON.h"

@interface CSRegisterUserNameViewController ()

@property (nonatomic,retain) IBOutlet UITextField *phoneNumberField;
@property (nonatomic,retain) IBOutlet UIImageView *phoneNumberBackView;
@property (nonatomic,retain) IBOutlet UITextField *secretCodeField;
@property (nonatomic,retain) IBOutlet UIImageView *secretCodeBackView;
@property (nonatomic,retain) IBOutlet UITextField *checkSecretCodeField;
@property (nonatomic,retain) IBOutlet UIImageView *checkSecretCodeBackView;
@property (nonatomic,retain) IBOutlet UIView *backView;
@property (nonatomic,retain) IBOutlet UIView *inputBackView;
@property (nonatomic,retain) IBOutlet ASIHTTPRequest *registerRequest;
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
@synthesize phoneNumberBackView;
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
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"注册";
    
    self.contentScrollView.contentSize = CGSizeMake(320, self.view.frame.size.height - 40 );
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //点击页面使键盘消失
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];
    
    //[self.phoneNumberField becomeFirstResponder];
    //[self keyboardWillShow:nil];

}

- (void)hideKeyBoard
{
    [self.phoneNumberField resignFirstResponder];
    [self.secretCodeField resignFirstResponder];
    [self.checkSecretCodeField resignFirstResponder];
}

- (void)adjustSubView:(int)startY
{
    [UIView animateWithDuration:0.3 animations:^{
        /*if (Is_iPhone5)
        {
            
        }
        else*/
        {
            /*self.phoneNumberBackView.frame = CGRectMake(self.phoneNumberBackView.frame.origin.x, startY, self.phoneNumberBackView.frame.size.width, self.phoneNumberBackView.frame.size.height);
            self.phoneNumberField.frame = CGRectMake(self.phoneNumberField.frame.origin.x, startY + 1, self.phoneNumberField.frame.size.width, self.phoneNumberField.frame.size.height);
            self.secretCodeBackView.frame = CGRectMake(self.secretCodeBackView.frame.origin.x, startY + 40,self.secretCodeBackView.frame.size.width, self.secretCodeBackView.frame.size.height);
            self.secretCodeField.frame = CGRectMake(self.secretCodeField.frame.origin.x, startY + 40, self.secretCodeField.frame.size.width, self.secretCodeField.frame.size.height);
            self.checkSecretCodeBackView.frame = CGRectMake(self.checkSecretCodeBackView.frame.origin.x, startY + 80, self.checkSecretCodeBackView.frame.size.width, self.checkSecretCodeBackView.frame.size.height);
            self.checkSecretCodeField.frame = CGRectMake(self.checkSecretCodeField.frame.origin.x, startY + 80, self.checkSecretCodeField.frame.size.width, self.checkSecretCodeField.frame.size.height);
            self.registerButton.frame = CGRectMake(self.registerButton.frame.origin.x, startY + 140, self.registerButton.frame.size.width, self.registerButton.frame.size.height);
        
*/
            self.backView.frame = CGRectMake(0, startY, self.backView.frame.size.width, self.backView.frame.size.height);
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
            if ([self.phoneNumberField isFirstResponder] || [self.secretCodeField isFirstResponder] || [self.checkSecretCodeField isFirstResponder])
            {
                CustomLog(@"Do Nothing");
                self.backView.frame = CGRectMake(0, - 80, self.backView.frame.size.width, self.backView.frame.size.height);
            }
        }
        else
        {
            self.backView.frame = CGRectMake(0, -150, self.backView.frame.size.width, self.backView.frame.size.height);

        }
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification 
{
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            self.backView.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);

        }
        else
        {
            self.backView.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);

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
    [phoneNumberBackView release];
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
    [self.phoneNumberField resignFirstResponder];
    [self.secretCodeField resignFirstResponder];
    [self.checkSecretCodeField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginButtonPressed:(id)sender
{
    [self.phoneNumberField resignFirstResponder];
    [self.secretCodeField resignFirstResponder];
    [self.checkSecretCodeField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButtonPressed:(id)sender
{
    if ([self.phoneNumberField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"手机号不能为空!"];
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
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"register",@"action",self.phoneNumberField.text,@"phone",self.phoneNumberField.text,@"username", [self.secretCodeField.text md5String],@"password", nil];
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    self.registerRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];
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
    if (nil == [requestDic objectForKey:@"status"]) 
    {
        CustomLog(@"parse error");
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"注册失败，请重新输入"];
        return;
    }
    else
    {
        int code = [[requestDic objectForKey:@"status"] intValue];
        switch (code) {
            case 0:
                [[Util sharedUtil] showAlertWithTitle:@"提示" message:@"恭喜您，注册成功,请登陆!"];
                [self.navigationController popViewControllerAnimated:YES];
                /*[[NSUserDefaults standardUserDefaults] setObject:requestDic forKey:UserDefaultUserInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter ] postNotificationName:LoginSuccessNotification object:nil userInfo:nil];*/

                break;
            case 1:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"插入数据库时失败,请稍后重试"];
                break;
            case 2:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"手机号码不正确,请重新输入!"];
                break;
            case 3:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"车牌号码不正确,请重新输入!"];
            case 4:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"密码不正确或不是md5格式,请重新输入!"];
                break;
            case 5:
            case 7:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"身份证号已存在,请重新输入或直接登陆!"];
                break;
            case 6:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"手机号码已经存在,请重新输入!"];
                break;
            case 8:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"驾驶证号已经存在,请重新输入!"];
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
            if ([self.phoneNumberField isFirstResponder])
            {
                CustomLog(@"Do Nothing");
                [self adjustSubView:0];
            }
            else if ([self.secretCodeField isFirstResponder])
            {
                [self adjustSubView:0];
            }
            else if ([self.checkSecretCodeBackView isFirstResponder])
            {
                [self adjustSubView:-40];
            }
        }
    }];

}

@end
