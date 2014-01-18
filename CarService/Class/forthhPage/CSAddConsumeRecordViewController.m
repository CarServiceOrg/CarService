//
//  CSAddConsumeRecordViewController.m
//  CarService
//
//  Created by baidu on 14-1-15.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSAddConsumeRecordViewController.h"
#import "BlockActionSheet.h"
#import "CSAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "LBSDataUtil.h"

@interface CSAddConsumeRecordViewController ()

@property (nonatomic,retain) IBOutlet UIView *datePickerBackView;
@property (nonatomic,retain) IBOutlet UITextField *timeField;
@property (nonatomic,retain) IBOutlet UITextField *constField;
@property (nonatomic,retain) IBOutlet UIButton *headerButton;
@property (nonatomic,retain) NSArray *classInfoDicArray;
@property (nonatomic,retain) NSDictionary *currentClassInfoDic;
@property (nonatomic,retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,retain) ASIHTTPRequest *recordRuest;
@property (nonatomic,retain) IBOutlet UITextField *addressField;
@property (nonatomic,retain) IBOutlet UIView *backView;

@end


@implementation CSAddConsumeRecordViewController
@synthesize datePickerBackView;
@synthesize timeField;
@synthesize constField;
@synthesize headerButton;
@synthesize classInfoDicArray;
@synthesize currentClassInfoDic;
@synthesize datePicker;
@synthesize recordRuest;
@synthesize addressField;
@synthesize backView;

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmButtonPressed:(id)sender;
{
    [self.recordRuest clearDelegatesAndCancel];
    
    if ([self.timeField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"时间不能为空!"];
        return;
    }
    
    if ([self.constField.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"花费不能为空!"];
        return;
    }
    
    NSString *uid = [[[Util sharedUtil] getUserInfo] objectForKey:@"id"];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"consuming",@"action",self.timeField.text,@"cons_time",uid,@"user_id",@"",@"cons_address",self.constField.text,@"cons_num",[self.currentClassInfoDic objectForKey:@"id"] ,@"cons_type", nil];
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.recordRuest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];
    self.recordRuest.delegate = self;
    [self.recordRuest setDidFinishSelector:@selector(classRequestDidFinished:)];
    [self.recordRuest setDidFailSelector:@selector(classRequestDidFailed:)];
    [self.recordRuest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleWhite];
}

- (void)classRequestDidFinished:(ASIHTTPRequest *)request
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *responseString = [[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease];
    
    NSDictionary *requestDic = [responseString JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == [requestDic objectForKey:@"status"] ||[[requestDic objectForKey:@"status"] intValue]!= 0 )
    {
        CustomLog(@"parse error");
        [self hideActView];
        switch ([[requestDic objectForKey:@"status"] intValue])
        {
            case 2:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"消费时间不正确，请重新填写!"];
                break;
                
            case 3:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"消费地址不正确，请重新填写!"];
                break;
            case 4:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"消费数量不正确，请重新填写!"];
                break;
            default:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"服务器出错，请稍后重试!"];
                break;
        }
        return;
    }
    else
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"添加成功!"];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:ConsumeRecordChangeNotification object:nil];
    }
}

- (void)classRequestDidFailed:(ASIHTTPRequest *)request
{
    [self hideActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"网络请求失败，请检查网络连接"];
}

- (IBAction)chooseTypeButtonPressed:(id)sender
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@""];
    [sheet setCancelButtonWithTitle:@"取消" block:nil];
    for (NSDictionary *dic in self.classInfoDicArray)
    {
        [sheet setDestructiveButtonWithTitle:[dic objectForKey:@"typename"] block:^{
            self.currentClassInfoDic = dic;
            [self.headerButton setTitle:[self.currentClassInfoDic objectForKey:@"typename"] forState:UIControlStateNormal];
            [self.headerButton setTitle:[self.currentClassInfoDic objectForKey:@"typename"] forState:UIControlStateHighlighted];
        }];
    }
    
    [sheet showInView:self.view];
}

- (id)initWithTypeDic:(NSArray *)typeDicArray
{
    self = [super initWithNibName:@"CSAddConsumeRecordViewController" bundle:nil];
    if (self)
    {
        self.classInfoDicArray = typeDicArray;
        self.currentClassInfoDic = [typeDicArray objectAtIndex:0];
    }
    return self;
}

- (void)dealloc
{
    [backView release];
    [datePickerBackView release];
    [timeField release];
    [constField release];
    [headerButton release];
    [classInfoDicArray release];
    [currentClassInfoDic release];
    [datePicker release];
    [recordRuest clearDelegatesAndCancel];
    [recordRuest release];
    [addressField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* formatStr=[formatter stringFromDate:[NSDate date]];
    self.timeField.text = formatStr;
    self.timeField.delegate = self;
    if (nil != [LBSDataUtil shareUtil].address)
    {
        self.addressField.text = [LBSDataUtil shareUtil].address;
    }
    [self.headerButton setTitle:[self.currentClassInfoDic objectForKey:@"typename"] forState:UIControlStateNormal];
    [self.headerButton setTitle:[self.currentClassInfoDic objectForKey:@"typename"] forState:UIControlStateHighlighted];
    
    //self.constField.delegate = self;
    //self.addressField.delegate = self;
    //点击页面使键盘消失
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.delegate = self;
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];
    
}

- (void)hideKeyBoard
{
    [self.constField resignFirstResponder];
    [self.addressField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CustomLog(@"listen the event");
    if (textField == timeField)
    {
        [self.datePicker setDate:[NSDate date]];
        
        CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
        self.datePickerBackView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
        [delegate.window addSubview:self.datePickerBackView];
        [UIView animateWithDuration:0.3 animations:^{
            self.datePickerBackView.frame = CGRectMake(0, 0, 320, delegate.window.frame.size.height);
        }];
        return NO;
    }
    else if(textField == addressField)
    {
        [UIView animateWithDuration:0.3 animations:^{
            if (Is_iPhone5)
            {
                
            }
            else
            {
                self.backView.frame = CGRectMake(0, -50, 300, 410);
            }
        }];
        return YES;
    }
    else if(textField == constField)
    {
        [UIView animateWithDuration:0.3 animations:^{
            if (Is_iPhone5)
            {
                
            }
            else
            {
                self.backView.frame = CGRectMake(0, -50, 300, 410);
            }
        }];
        return YES;
    }
    return NO;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
            self.backView.frame = CGRectMake(0, 0, 300, 410);
            
        }
    }];    return YES;
}

- (IBAction)comfirmActionPressed:(id)sender
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* formatStr=[formatter stringFromDate:self.datePicker.date];
    self.timeField.text = formatStr;
    
    CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePickerBackView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
    } completion:^(BOOL finish){
        [self.datePickerBackView removeFromSuperview];
    }];
    
}

- (IBAction)cancelActionPressed:(id)sender
{
    CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePickerBackView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
    } completion:^(BOOL finish){
        [self.datePickerBackView removeFromSuperview];
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
            self.backView.frame = CGRectMake(0, -50, 300, 410);
            
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
            self.backView.frame = CGRectMake(0, 0, 300, 410);
            
        }
    }];
    
}


@end
