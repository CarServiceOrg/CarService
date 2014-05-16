//
//  CSMyProfileViewController.m
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSMyProfileViewController.h"
#import "ASIFormDataRequest.h"
#import "CSAppDelegate.h"

@interface CSMyProfileViewController ()

@property (nonatomic,retain) IBOutlet UITextField *nameLabel;
@property (nonatomic,retain) IBOutlet UITextField *ageField;
@property (nonatomic,retain) IBOutlet UILabel *sexLabel;
@property (nonatomic,retain) IBOutlet UITextField *phoneField;
@property (nonatomic,retain) IBOutlet UITextField *driverLecenseField;
@property (nonatomic,retain) NSMutableDictionary *userInfo;
@property (nonatomic,retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic,retain) IBOutlet UIView *dataPickerView;
@property (nonatomic,retain) ASIHTTPRequest *changeInfoRequest;
@property (nonatomic,retain) IBOutlet UIView *backView;
@property (nonatomic,retain) IBOutlet UIImageView *headerSexImageView;
@property (nonatomic,retain) IBOutlet UILabel *headerNameLabel;
@property (nonatomic,retain) IBOutlet UIButton *changeInfoButton;

@end

@implementation CSMyProfileViewController

@synthesize nameLabel;
@synthesize ageField;
@synthesize sexLabel;
@synthesize phoneField;
@synthesize driverLecenseField;
@synthesize userInfo;
@synthesize pickerView;
@synthesize dataPickerView;
@synthesize changeInfoRequest;
@synthesize backView;
@synthesize headerNameLabel;
@synthesize headerSexImageView;
@synthesize changeInfoButton;

- (id)initWithInfo:(NSMutableDictionary *)info
{
    self = [self initWithNibName:@"CSMyProfileViewController" bundle:nil];
    if (self)
    {
        self.userInfo = info;
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


- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadContent
{
    self.backView.hidden = NO;
    self.nameLabel.text = [self.userInfo objectForKey:@"username"];
    self.ageField.text = [self.userInfo objectForKey:@"age"];
    if ([[self.userInfo objectForKey:@"sex"] isEqualToString:@"0"])
    {
        self.sexLabel.text = @"保密";
        self.headerSexImageView.hidden = YES;
    }
    else if ([[self.userInfo objectForKey:@"sex"] isEqualToString:@"1"])
    {
        self.sexLabel.text = @"男";
        self.headerSexImageView.hidden = NO;
        self.headerSexImageView.image = [UIImage imageNamed:@"new_gerenziliao_nantubiao.png"];
        self.headerSexImageView.frame = CGRectMake(self.headerSexImageView.frame.origin.x, self.headerSexImageView.frame.origin.y, 18, 18);
    }
    else
    {
        self.sexLabel.text = @"女";
        self.headerSexImageView.hidden = NO;
        self.headerSexImageView.image = [UIImage imageNamed:@"new_gerenziliao_nvtubiao.png"];
        self.headerSexImageView.frame = CGRectMake(self.headerSexImageView.frame.origin.x, self.headerSexImageView.frame.origin.y, 12, 18);
    }
    //set headerSexImageView
    self.phoneField.text = [self.userInfo objectForKey:@"phone"];
    self.headerNameLabel.text = [self.userInfo objectForKey:@"phone"];
    self.driverLecenseField.text = [self.userInfo objectForKey:@"drivecard"];
}

- (void)loadProfileInfo
{
    self.backView.hidden = YES;
    self.changeInfoButton.enabled = NO;
    [self.changeInfoRequest clearDelegatesAndCancel];
    NSDictionary *dic = [[Util sharedUtil] getUserInfo];

    NSString *uid = [dic objectForKey:@"id"];
    NSString *sessionId = [dic objectForKey:@"session_id"];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"user_info",@"action",uid,@"user_id",sessionId,@"session_id", nil];
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.changeInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];
    
    [changeInfoRequest setShouldAttemptPersistentConnection:NO];
    [changeInfoRequest setValidatesSecureCertificate:NO];
    
    [changeInfoRequest setDelegate:self];
    [changeInfoRequest setDidFinishSelector:@selector(profileRequestDidFinished:)];
    [changeInfoRequest setDidFailSelector:@selector(profileRequestDidFailed:)];
    
    [changeInfoRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleGray];
}

- (void)profileRequestDidFinished:(ASIFormDataRequest *)request
{
    CustomLog(@"%@",[request responseString]);
    [self hideActView];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *responseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *requestDic = [responseString JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    int statusCode = [[requestDic objectForKey:@"status"] intValue];
    switch (statusCode)
    {
        case 0:
            self.userInfo = [NSMutableDictionary dictionaryWithDictionary:[requestDic objectForKey:@"list"]];
            [[Util sharedUtil] updateUserInfo:self.userInfo];
            [self reloadContent];
            self.changeInfoButton.enabled = YES;
            break;
        case 2:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"session_id不正确，请稍后重试!"];
            break;
        case 3:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"用户id不正确，请稍后重试!"];
            break;
        case 4:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"消费类型不正确，请稍后重试!"];
            break;
        case 1:
        default:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请稍后重试!"];
            break;
    }
    
}

- (void)profileRequestDidFailed:(ASIFormDataRequest *)request
{
    [self hideActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"请求失败，请检查网络连接!"];
    return;
    CustomLog(@"%@",[request responseString]);
}

- (IBAction)rightButtonItemPressed:(id)sender
{
    if (self.backView.hidden == YES)
    {
        return;
    }
    
    if ([self.nameLabel.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"请输入姓名"];
        return;
    }
    if ([self.ageField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"请输入年龄"];
        return;
    }
    
    if ([self.driverLecenseField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"请输入驾驶证号"];
        return;
    }

    [self.changeInfoRequest clearDelegatesAndCancel];
    NSDictionary *dic = [[Util sharedUtil] getUserInfo];

    NSString *uid = [dic objectForKey:@"id"];
    NSString *sessionId = [dic objectForKey:@"session_id"];
    NSString *sexTip = @"0";
    if ([self.sexLabel.text isEqualToString:@"男"])
    {
        sexTip = @"1";
    }
    else if ([self.sexLabel.text isEqualToString:@"女"])
    {
        sexTip = @"2";
    }
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"edit_user_info",@"action",uid,@"user_id",sessionId,@"session_id",self.nameLabel.text,@"username",self.ageField.text,@"age",sexTip,@"sex",self.phoneField.text,@"phone",self.driverLecenseField.text,@"drivecard", nil];
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.changeInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];    [changeInfoRequest setShouldAttemptPersistentConnection:NO];
    [changeInfoRequest setValidatesSecureCertificate:NO];
    
    [changeInfoRequest setDelegate:self];
    [changeInfoRequest setDidFinishSelector:@selector(editingRequestDidFinished:)];
    [changeInfoRequest setDidFailSelector:@selector(editingRequestDidFailed:)];
    
    [changeInfoRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleGray];
}

- (void)editingRequestDidFinished:(ASIFormDataRequest *)request
{
    CustomLog(@"%@",[request responseString]);
    [self hideActView];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *responseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *requestDic = [responseString JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == requestDic || nil == [requestDic objectForKey:@"status"])
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请稍后重试!"];
        return;
    }
    int statusCode = [[requestDic objectForKey:@"status"] intValue];
    switch (statusCode)
    {
        case 0:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改成功!"];
            NSMutableDictionary *newProfileDic = [NSMutableDictionary dictionaryWithDictionary:[[Util sharedUtil] getUserInfo]];
            [newProfileDic setObject:nameLabel.text forKey:@"username"];
            [newProfileDic setObject:ageField.text forKey:@"age"];
            [newProfileDic setObject:phoneField.text forKey:@"phone"];
            [newProfileDic setObject:driverLecenseField.text forKey:@"drivecard"];
            NSString *sexTip = @"0";
            if ([sexLabel.text isEqualToString:@"男"])
            {
                sexTip = @"1";
            }
            else if([sexLabel.text isEqualToString:@"女"])
            {
                sexTip = @"2";
            }
            [newProfileDic setObject:sexTip forKey:@"sex"];
            [[Util sharedUtil] updateUserInfo:newProfileDic];
            [[NSNotificationCenter defaultCenter ] postNotificationName:UserInfoChangeNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"session_id不正确，请稍后重试!"];
            break;
        case 3:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"用户id不正确，请稍后重试!"];
            break;
        case 4:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"手机号已存在，请更换后重试!"];
            break;
        case 5:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"驾驶证号已存在，请更换后重试!"];
            break;
        case 1:
        default:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请稍后重试!"];
            break;
    }
    
}

- (void)editingRequestDidFailed:(ASIFormDataRequest *)request
{
    [self hideActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请检查网络连接!"];
    return;
    CustomLog(@"%@",[request responseString]);
}


- (IBAction)comfirmActionPressed:(id)sender
{
    if ([self.pickerView selectedRowInComponent:0] == 0)
    {
        [self.userInfo setObject:@"保密" forKey:@"sex"];
        self.headerSexImageView.hidden = YES;
        
    }
    else if ([self.pickerView selectedRowInComponent:0] == 1)
    {
        [self.userInfo setObject:@"男" forKey:@"sex"];
        self.headerSexImageView.image = [UIImage imageNamed:@"new_gerenziliao_nantubiao.png"];
        self.headerSexImageView.frame = CGRectMake(self.headerSexImageView.frame.origin.x, self.headerSexImageView.frame.origin.y, 12, 18);
        self.headerSexImageView.hidden = NO;

    }
    else
    {
        [self.userInfo setObject:@"女" forKey:@"sex"];
        self.headerSexImageView.image = [UIImage imageNamed:@"new_gerenziliao_nvtubiao.png"];
        self.headerSexImageView.frame = CGRectMake(self.headerSexImageView.frame.origin.x, self.headerSexImageView.frame.origin.y, 12, 18);
        self.headerSexImageView.hidden = NO;

    }

    self.sexLabel.text = [self.userInfo objectForKey:@"sex"];
    
    CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
    } completion:^(BOOL finish){
        [self.dataPickerView removeFromSuperview];
    }];
}

- (IBAction)cancelActionPressed:(id)sender
{
    CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
    } completion:^(BOOL finish){
        [self.dataPickerView removeFromSuperview];
    }];
}

- (IBAction)showSexSelectionView:(id)sender
{
    [self hideKeyBoard];
    CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.dataPickerView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
    [delegate.window addSubview:self.dataPickerView];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerView.frame = CGRectMake(0, 0, 320, delegate.window.frame.size.height);
    }];
    [self.pickerView reloadAllComponents];
    int row = 0;
    if ([self.sexLabel.text isEqualToString:@"男"])
    {
        row = 1;
    }
    else if ([self.sexLabel.text isEqualToString:@"女"])
    {
        row = 2;
    }
    [self.pickerView selectRow:row inComponent:0 animated:NO];
}

- (void)dealloc
{
    [pickerView release];
    [dataPickerView release];
    [changeInfoRequest clearDelegatesAndCancel];
    [changeInfoRequest release];
    [userInfo release];
    [nameLabel release];
    [ageField release];
    [sexLabel release];
    [phoneField release];
    [driverLecenseField release];
    [headerSexImageView release];
    [headerNameLabel release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.rightBarButtonItem = [self getRithtItem:@"修改"];
    self.navigationItem.title = @"个人资料";
    
    if (!IsIOS6OrLower)
    {
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.tintColor = [UIColor blackColor];
    }
    //点击页面使键盘消失
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];
    
    [self loadProfileInfo];
}

- (void)hideKeyBoard
{
    [self.nameLabel resignFirstResponder];
    [self.ageField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.driverLecenseField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
            self.backView.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            if ([self.nameLabel isFirstResponder] || [self.ageField isFirstResponder])
            {
                self.backView.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
            }
            else if([self.phoneField isFirstResponder])
            {
                self.backView.frame = CGRectMake(0, -20, self.backView.frame.size.width, self.backView.frame.size.height);
            }
            else if([self.driverLecenseField isFirstResponder])
            {
                self.backView.frame = CGRectMake(0, -40, self.backView.frame.size.width, self.backView.frame.size.height);
            }
        }
    }];
    
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0)
    {
        return @"保密";
    }
    else if (row == 1)
    {
        return @"男";
    }
    else if (row == 2)
    {
        return @"女";
    }
    return  nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 35;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

@end
