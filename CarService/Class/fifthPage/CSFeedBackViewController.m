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
@property (nonatomic,retain) IBOutlet UIImageView *textViewBackView;
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
@synthesize textViewBackView;

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
    [textViewBackView release];
    [super dealloc];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)adjustLayout:(BOOL)showKeyBoard
{
    if (showKeyBoard)
    {
        if (Is_iPhone5)
        {
            self.textViewBackView.frame = CGRectMake(self.textViewBackView.frame.origin.x, self.textViewBackView.frame.origin.y, self.textViewBackView.frame.size.width,180);
            self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width,180);
            self.confirmButton.frame = CGRectMake(self.confirmButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.confirmButton.frame.size.width, self.confirmButton.frame.size.height);
            self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
        }
        else
        {
            self.textViewBackView.frame = CGRectMake(self.textViewBackView.frame.origin.x, self.textViewBackView.frame.origin.y, self.textViewBackView.frame.size.width,100);
            self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width,100);
            self.confirmButton.frame = CGRectMake(self.confirmButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.confirmButton.frame.size.width, self.confirmButton.frame.size.height);
            self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
        }

    }
    else
    {
        if (Is_iPhone5)
        {
            self.textViewBackView.frame = CGRectMake(self.textViewBackView.frame.origin.x, self.textViewBackView.frame.origin.y, self.textViewBackView.frame.size.width,375);
            self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width,375);
            self.confirmButton.frame = CGRectMake(self.confirmButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.confirmButton.frame.size.width, self.confirmButton.frame.size.height);
            self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
        }
        else
        {
            self.textViewBackView.frame = CGRectMake(self.textViewBackView.frame.origin.x, self.textViewBackView.frame.origin.y, self.textViewBackView.frame.size.width,285);
            self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width,285);
            self.confirmButton.frame = CGRectMake(self.confirmButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.confirmButton.frame.size.width, self.confirmButton.frame.size.height);
            self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
        }

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self adjustLayout:self.textView.isFirstResponder];
    /*if (Is_iPhone5)
    {
        
        self.confirmButton.frame = CGRectMake(self.confirmButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 16, self.confirmButton.frame.size.width, self.confirmButton.frame.size.height);
        self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 16, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
    }
    else
    {
        self.confirmButton.frame = CGRectMake(self.confirmButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.confirmButton.frame.size.width, self.confirmButton.frame.size.height);
        self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height + 8, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
    }*/
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

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
    if (nil == [requestDic objectForKey:@"status"] || ![[requestDic objectForKey:@"status"] isEqualToString:@"0"])
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


#pragma mark KeyBoradNotification

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CustomLog(@"frame:%f,%f,%f,%f",keyboardRect.origin.x,keyboardRect.origin.y,keyboardRect.size.width,keyboardRect.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self adjustLayout:YES];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        [self adjustLayout:NO];

    }];
    
}

@end
