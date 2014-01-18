//
//  CSCommentViewController.m
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSCommentViewController.h"
#import "ASIHTTPRequest.h"

@interface CSCommentViewController ()

@property (nonatomic,retain) IBOutlet UILabel *textPlaceHolderLabel;
@property (nonatomic,retain) IBOutlet UITextView *textView;
@property (nonatomic,retain) IBOutlet UIButton *firstStarView;
@property (nonatomic,retain) IBOutlet UIButton *secondStarView;
@property (nonatomic,retain) IBOutlet UIButton *thirdStarView;
@property (nonatomic,retain) IBOutlet UIButton *forthStarView;
@property (nonatomic,retain) IBOutlet UIButton *fifthStarView;
@property (nonatomic,assign) int currentRateStar;
@property (nonatomic,retain) NSArray *rateButtonArray;
@property (nonatomic,retain) ASIHTTPRequest *commentRequest;
@property (nonatomic,retain) IBOutlet UIScrollView *contentScrollView;

- (void)hideKeyBoard;

@end

@implementation CSCommentViewController
@synthesize textPlaceHolderLabel;
@synthesize textView;
@synthesize firstStarView;
@synthesize secondStarView;
@synthesize thirdStarView;
@synthesize forthStarView;
@synthesize fifthStarView;
@synthesize currentRateStar;
@synthesize rateButtonArray;
@synthesize commentRequest;
@synthesize contentScrollView;
@synthesize orderInfoDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentRateStar = 4;
    }
    return self;
}

- (void)dealloc
{
    [contentScrollView release];
    [textPlaceHolderLabel release];
    [textView release];
    [firstStarView release];
    [secondStarView release];
    [thirdStarView release];
    [forthStarView release];
    [fifthStarView release];
    [rateButtonArray release];
    [commentRequest clearDelegatesAndCancel];
    [commentRequest release];
    [orderInfoDic release];
    [super dealloc];
}

- (void)hideKeyBoard
{
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"我要点评";
    
    self.rateButtonArray = [NSArray arrayWithObjects:self.firstStarView,self.secondStarView,self.thirdStarView,self.forthStarView,self.fifthStarView, nil];
    
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.delegate = self;
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.contentScrollView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)commentButtonPressed:(id)sender
{
    if ([self.textView.text length] == 0)
    {
        [[Util sharedUtil] showAlertWithTitle:nil message:@"评论内容不能为空"];
        return;
    }
    [self.commentRequest clearDelegatesAndCancel];
    NSDictionary *dic = [[Util sharedUtil] getUserInfo];
    NSString *uid = [dic objectForKey:@"id"];
    NSString *sessionId = [dic objectForKey:@"session_id"];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"evaluate",@"action",sessionId,@"session_id",uid,@"user_id",[self.orderInfoDic objectForKey:@"order_sn"],@"order_id",self.textView.text,@"content",[NSString stringWithFormat:@"%d",self.currentRateStar],@"star",[self.orderInfoDic objectForKey:@"serve_type"],@"serve_type",[self.orderInfoDic objectForKey:@"server_id"],@"server_id", nil];
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.commentRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];
    
    [commentRequest setShouldAttemptPersistentConnection:NO];
    [commentRequest setValidatesSecureCertificate:NO];
    
    [commentRequest setDelegate:self];
    [commentRequest setDidFinishSelector:@selector(editingRequestDidFinished:)];
    [commentRequest setDidFailSelector:@selector(editingRequestDidFailed:)];
    [commentRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleGray];
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
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"评论失败，请稍后重试!"];
        return;
    }
    else
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"评论成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)editingRequestDidFailed:(ASIHTTPRequest *)request
{
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"评论失败，请检查网络连接!"];
    return;
    CustomLog(@"%@",[request responseString]);
}

- (IBAction)starButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.currentRateStar = button.tag + 1;
    for (int i = 0; i < 5; i ++)
    {
        UIButton *tempButton = (UIButton *)[self.rateButtonArray objectAtIndexWithCheck:i];
        if (i <= button.tag)
        {
            [tempButton setBackgroundImage:[UIImage imageNamed:@"comment_highlight_star.png"] forState:UIControlStateNormal];
        }
        else
        {
            [tempButton setBackgroundImage:[UIImage imageNamed:@"comment_normal_star.png"] forState:UIControlStateNormal];
        }
    }
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
