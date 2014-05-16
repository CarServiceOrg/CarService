//
//  CSHeartServiceViewController.m
//  CarService
//
//  Created by baidu on 14-5-15.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSHeartServiceViewController.h"
#import "ActionSheetDatePicker.h"

@interface CSHeartServiceViewController ()

@end

@implementation CSHeartServiceViewController
@synthesize backView;
@synthesize backScrollView;
@synthesize textFiled1;
@synthesize textFiled2;
@synthesize textFiled3;
@synthesize textFiled4;
@synthesize textFiled5;
@synthesize recordRuest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [backView release];
    [backScrollView release];
    [textFiled5 release];
    [textFiled4 release];
    [textFiled3 release];
    [textFiled2 release];
    [textFiled1 release];
    [recordRuest clearDelegatesAndCancel];
    [recordRuest release];
    [super dealloc];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getTimeInterval:(NSString *)string
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [formatter dateFromString:string];
    return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
}

- (IBAction)confirmButtonPressed:(id)sender
{
    NSLog(@"confirmButtonPressed");
    
    [self.recordRuest clearDelegatesAndCancel];
    NSDictionary *dic = [[Util sharedUtil] getUserInfo];
    NSString *uid = [dic objectForKey:@"id"];
    NSString *sessionId = [dic objectForKey:@"session_id"];

    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"edit_user_carinfo",@"action",uid,@"user_id",[self getTimeInterval:self.textFiled1.text],@"birthday",[self getTimeInterval:self.textFiled2.text],@"drivecard_exp",[self getTimeInterval:self.textFiled3.text],@"secure_exp",[self getTimeInterval:self.textFiled4.text],@"last_repair_time",[self getTimeInterval:self.textFiled5.text],@"next_repair_time",sessionId,@"session_id",nil];
    
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.recordRuest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];
    self.recordRuest.delegate = self;
    [self.recordRuest setDidFinishSelector:@selector(requestDidFinished:)];
    [self.recordRuest setDidFailSelector:@selector(requestDidFailed:)];
    [self.recordRuest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleGray];
}

#pragma mark - ASIHttpRequest Delegate Methods

- (void)requestDidFinished:(ASIHTTPRequest *)request
{
    [self hideActView];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *responseString = [[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease];
    
    NSDictionary *requestDic = [responseString JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == [requestDic objectForKey:@"status"])
    {
        CustomLog(@"parse error");
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"服务器出错，请稍后重试!"];
        return;
    }
    else
    {
        switch ([[requestDic objectForKey:@"status"] intValue])
        {
            case 0:
                NSLog(@"data:%@",requestDic);
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"已成功提交信息!"];
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case 2:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"session id不正确，请重新登陆!"];
                break;
            case 3:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"用户id不正确，请重新登陆!"];
                break;
            default:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"服务器出错，请稍后重试!"];
                break;
        }
    }
}

- (void)requestDidFailed:(ASIHTTPRequest *)request
{
    [self hideActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"网络请求失败，请检查网络连接"];
}
// 选择查询日期
-(void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    if (selectedDate!=nil && element!=nil) {
        UITextField* textField = (UITextField*)element;
        if (textField) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSString* formatStr=[formatter stringFromDate:selectedDate];
            [formatter release];
            [textField setText:formatStr];
        }
    }
}

- (void)hideKeyBoard
{
    [self.textFiled1 resignFirstResponder];
    [self.textFiled2 resignFirstResponder];
    [self.textFiled3 resignFirstResponder];
    [self.textFiled4 resignFirstResponder];
    [self.textFiled5 resignFirstResponder];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //点击页面使键盘消失
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.frame.size.width, self.backScrollView.frame.size.height + 5);

    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.delegate = self;
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark KeyBoradNotification

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"enter here");
    if (textField == self.textFiled1)
    {
        [ActionSheetDatePicker showPickerWithTitle:@"出生日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:textField];
    }
    else if (textField == self.textFiled2)
    {
        [ActionSheetDatePicker showPickerWithTitle:@"驾驶证到期日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:textField];
    }
    else if (textField == self.textFiled3)
    {
        [ActionSheetDatePicker showPickerWithTitle:@"保险到期日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:textField];
    }
    else if (textField == self.textFiled4)
    {
        [ActionSheetDatePicker showPickerWithTitle:@"上次保养日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:textField];
    }
    else if (textField == self.textFiled5)
    {
        [ActionSheetDatePicker showPickerWithTitle:@"下次验车日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:textField];
    }
    return NO;
/*
    CGFloat startY = 0;
    if (Is_iPhone5)
    {
        if ((self.textFiled1 == textField)||(self.textFiled2 == textField)||(self.textFiled3 == textField))
        {
            startY = 0;
        }
        else if (self.textFiled4 == textField)
        {
            startY = -120;
        }
        else
        {
            startY = -150;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            self.backView.frame = CGRectMake(0, startY, self.backView.frame.size.width, self.backView.frame.size.height);
            
        }
        else
        {
            self.backView.frame = CGRectMake(0,startY, self.backView.frame.size.width, self.backView.frame.size.height);
            
            
        }
    }];
    return YES;*/
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    /*NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CustomLog(@"frame:%f,%f,%f,%f",keyboardRect.origin.x,keyboardRect.origin.y,keyboardRect.size.width,keyboardRect.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            self.backView.frame = CGRectMake(0, -150, self.backView.frame.size.width, self.backView.frame.size.height);

        }
        else
        {
            self.backView.frame = CGRectMake(0, -150, self.backView.frame.size.width, self.backView.frame.size.height);
            
            
        }
    }];*/
    
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
