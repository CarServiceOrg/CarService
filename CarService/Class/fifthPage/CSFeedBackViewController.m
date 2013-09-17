//
//  CSFeedBackViewController.m
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSFeedBackViewController.h"
#import "ASIHTTPRequest.h"

@interface CSFeedBackViewController ()

@property (nonatomic,retain) IBOutlet UILabel *textPlaceHolderLabel;
@property (nonatomic,retain) IBOutlet UITextView *textView;
@property (nonatomic,retain) ASIHTTPRequest *commentRequest;
@property (nonatomic,retain) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic,retain) IBOutlet UIButton *confirmButton;
@property (nonatomic,retain) IBOutlet UIButton *cancelButton;

- (void)hideKeyBoard;

@end

@implementation CSFeedBackViewController
@synthesize textPlaceHolderLabel;
@synthesize textView;
@synthesize commentRequest;
@synthesize contentScrollView;
@synthesize confirmButton;
@synthesize cancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)hideKeyBoard
{
    [self.textView resignFirstResponder];
}

- (void)dealloc
{
    [textPlaceHolderLabel release];
    [textView release];
    [commentRequest clearDelegatesAndCancel];
    [commentRequest release];
    [contentScrollView release];
    [super dealloc];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (Is_iPhone5)
    {
        
        self.confirmButton.frame = CGRectMake(self.confirmButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 16, self.confirmButton.frame.size.width, self.confirmButton.frame.size.height);
        self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 16, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
    }
    else
    {
        self.confirmButton.frame = CGRectMake(self.confirmButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.confirmButton.frame.size.width, self.confirmButton.frame.size.height);
        self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"意见反馈";
    
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.delegate = self;
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.contentScrollView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];

}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmButtonPressed:(id)sender
{
    [self.commentRequest clearDelegatesAndCancel];
    self.commentRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_feedback]];
    [commentRequest setShouldAttemptPersistentConnection:NO];
    [commentRequest setValidatesSecureCertificate:NO];
    
    [commentRequest setDelegate:self];
    [commentRequest setDidFinishSelector:@selector(editingRequestDidFinished:)];
    [commentRequest setDidFailSelector:@selector(editingRequestDidFailed:)];
    [commentRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleWhite];
}

- (void)editingRequestDidFinished:(ASIHTTPRequest *)request
{
    CustomLog(@"%@",[request responseString]);
    [self hideActView];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *responseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *requestDic = [responseString JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == [requestDic objectForKey:@"code"] || ![[requestDic objectForKey:@"code"] isEqualToString:@"0"])
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请稍后重试!"];
        return;
    }
    else
    {
        
    }
    
}

- (void)editingRequestDidFailed:(ASIHTTPRequest *)request
{
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请检查网络连接!"];
    return;
    CustomLog(@"%@",[request responseString]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
    int length = [self.textView.text length];
    if (length == 0)
    {
        self.textPlaceHolderLabel.hidden = NO;
    }
    else
    {
        self.textPlaceHolderLabel.hidden = YES;
    }
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView)
    {
        [self hideKeyBoard];
    }
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
