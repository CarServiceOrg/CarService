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
@property (nonatomic,retain) ASIFormDataRequest *changeInfoRequest;
@property (nonatomic,retain) IBOutlet UIView *backView;

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


- (void)reloadContent
{
    //based on userinfo
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightButtonItemPressed:(id)sender
{
    [self.changeInfoRequest clearDelegatesAndCancel];
    self.changeInfoRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_changeprofile]];
    [changeInfoRequest setRequestMethod:@"POST"];
    [changeInfoRequest setShouldAttemptPersistentConnection:NO];
    [changeInfoRequest setValidatesSecureCertificate:NO];
    
    [changeInfoRequest setPostValue:@"edit" forKey:@"op"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [changeInfoRequest setStringEncoding:enc];
    
    [changeInfoRequest setDelegate:self];
    [changeInfoRequest setDidFinishSelector:@selector(editingRequestDidFinished:)];
    [changeInfoRequest setDidFailSelector:@selector(editingRequestDidFailed:)];
    [changeInfoRequest setPostValue:@"7" forKey:@"type"];
    [changeInfoRequest setPostValue:[NSString stringWithFormat:@"%d",[self.pickerView selectedRowInComponent:0] + 1]  forKey:@"content"];
    
    [changeInfoRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleWhite];
}

- (void)editingRequestDidFinished:(ASIFormDataRequest *)request
{
    CustomLog(@"%@",[request responseString]);
    [self hideActView];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *responseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *requestDic = [responseString JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == [requestDic objectForKey:@"status"] || ![[requestDic objectForKey:@"status"] isEqualToString:@"0"])
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请稍后重试!"];
        return;
    }
    else
    {
        
    }
    
}

- (void)editingRequestDidFailed:(ASIFormDataRequest *)request
{
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请检查网络连接!"];
    return;
    CustomLog(@"%@",[request responseString]);
}


- (IBAction)comfirmActionPressed:(id)sender
{
    [self.userInfo setObject:[NSString stringWithFormat:@"%d",[self.pickerView selectedRowInComponent:0] + 1] forKey:@"sex"];
    [self reloadContent];
    
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
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.rightBarButtonItem = [self getRithtItem:@"修改"];
    self.navigationItem.title = @"个人资料";
    
    //点击页面使键盘消失
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];
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

@end
