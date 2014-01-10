//
//  CSMyConsumeRecordViewController.m
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSMyConsumeRecordViewController.h"
#import "CSMyConsumeRecordCell.h"
#import "CSAppDelegate.h"

@interface CSMyConsumeRecordViewController ()

@property (nonatomic,retain) IBOutlet UIView *headerView;
@property (nonatomic,retain) IBOutlet UITableView *contentTableView;
@property (nonatomic,retain) ASIHTTPRequest *recordRuest;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) IBOutlet UIButton *headerButton;
@property (nonatomic,retain) IBOutlet UIImageView *triangleView;
@property (nonatomic,retain) IBOutlet UIView *fromView;
@property (nonatomic,retain) IBOutlet UIView *toView;
@property (nonatomic,retain) IBOutlet UILabel *fromeLabel;
@property (nonatomic,retain) IBOutlet UILabel *toLabel;
@property (nonatomic,retain) IBOutlet UILabel *toTipLabel;
@property (nonatomic,retain) UIBarButtonItem *rightButtonItem;
@property (nonatomic,retain) NSArray *classArray;
@property (nonatomic,retain) NSDate *fromDate;
@property (nonatomic,retain) NSDate *toDate;
@property (nonatomic,retain) NSDictionary *currentClassInfoDic;
@property (nonatomic,assign) BOOL firstDataRequest;
@property (nonatomic,retain) IBOutlet UIView *datePickerBackView;
@property (nonatomic,retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,assign) BOOL isFromTime;

- (void)showHeaderView:(BOOL)show;
- (IBAction)datePickerButtonPressed:(id)sender;
- (IBAction)headerButtonPressed:(id)sender;

@end

@implementation CSMyConsumeRecordViewController
@synthesize headerView;
@synthesize contentTableView;
@synthesize recordRuest;
@synthesize dataArray;
@synthesize headerButton;
@synthesize triangleView;
@synthesize fromView;
@synthesize toView;
@synthesize rightButtonItem;
@synthesize toLabel;
@synthesize fromeLabel;
@synthesize classArray;
@synthesize fromDate;
@synthesize toDate;
@synthesize currentClassInfoDic;
@synthesize firstDataRequest;
@synthesize datePicker;
@synthesize datePickerBackView;
@synthesize isFromTime;
@synthesize toTipLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setHeaderViewContent
{
    [self.headerButton setTitle:[self.currentClassInfoDic objectForKey:@"typename"] forState:UIControlStateNormal];
    [self.headerButton setTitle:[self.currentClassInfoDic objectForKey:@"typename"] forState:UIControlStateHighlighted];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.fromeLabel.text = [dateFormatter stringFromDate:self.fromDate];
    self.toLabel.text = [dateFormatter stringFromDate:self.toDate];
    [dateFormatter release];
}

- (void)showHeaderView:(BOOL)show
{
    self.headerButton.hidden = !show;
    self.fromView.hidden = !show;
    self.toTipLabel.hidden = !show;
    self.toView.hidden = !show;
    self.headerView.hidden = !show;
    if (show)
    {
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)dealloc
{
    [headerView release];
    [contentTableView release];
    [recordRuest clearDelegatesAndCancel];
    [recordRuest release];
    [dataArray release];
    [headerButton release];
    [triangleView release];
    [fromView release];
    [toView release];
    [rightButtonItem release];
    [toLabel release];
    [classArray release];
    [fromDate release];
    [currentClassInfoDic release];
    [toDate release];
    [fromeLabel release];
    [datePickerBackView release];
    [datePicker release];
    [toTipLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"消费记录";
    self.rightButtonItem = [self getRithtItem:@"筛选"];
    self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    [self showHeaderView:NO];
    [self loadClasses];
    firstDataRequest  = YES;
    
    if (!IsIOS6OrLower)
    {
        self.datePicker.backgroundColor = [UIColor whiteColor];
        self.datePicker.tintColor = [UIColor blackColor];
    }
}

- (void)loadClasses
{
    [self.recordRuest clearDelegatesAndCancel];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"contype",@"action", nil];
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

- (void)loadContent
{
    [self.recordRuest clearDelegatesAndCancel];
    NSDictionary *dic = [[Util sharedUtil] getUserInfo];
     NSString *uid = [dic objectForKey:@"id"];
     NSString *sessionId = [dic objectForKey:@"session_id"];
#warning test argument
    //NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"cons_list",@"action",sessionId,@"session_id",uid,@"user_id",[self.currentClassInfoDic objectForKey:@"id"],@"cons_type",[NSString stringWithFormat:@"%f",[self.fromDate timeIntervalSince1970]],@"start_time",[NSString stringWithFormat:@"%f",[self.fromDate timeIntervalSince1970]],@"end_time",nil];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"cons_list",@"action",sessionId,@"session_id",uid,@"user_id",[self.currentClassInfoDic objectForKey:@"id"],@"cons_type",@"",@"start_time",@"",@"end_time",nil];

    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.recordRuest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];    self.recordRuest.delegate = self;
    [self.recordRuest setDidFinishSelector:@selector(requestDidFinished:)];
    [self.recordRuest setDidFailSelector:@selector(requestDidFailed:)];
    [self.recordRuest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleWhite];
}

#pragma mark - ASIHttpRequest Delegate Methods

- (void)requestDidFinished:(ASIHTTPRequest *)request
{
    [self hideActView];
    if (firstDataRequest)
    {
        firstDataRequest = NO;
        [self showHeaderView:YES];
        [self setHeaderViewContent];
    }
    
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
                self.dataArray = [requestDic objectForKey:@"list"];
                [self.contentTableView reloadData];
                break;
            case 2:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"session id不正确，请重新登陆!"];
                break;
            case 3:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"用户id不正确，请重新登陆!"];
                break;
            case 4:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"消费类型不正确，请稍后重试!"];
                break;
            case 1:
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
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"服务器出错，请稍后重试!"];
        return;
    }
    else
    {
        /*
         {"id":"4","typename":"\u517b\u8def\u8d39"}
         */
        if ([[requestDic objectForKey:@"list"] count] > 0)
        {
            self.classArray = [requestDic objectForKey:@"list"];
            self.currentClassInfoDic = [self.classArray objectAtIndex:0];
            NSTimeInterval secondsPerDay = 24 * 60 * 60;
            self.fromDate = [NSDate dateWithTimeIntervalSinceNow:- 7 * secondsPerDay];
            self.toDate = [NSDate date];
            [self loadContent];
        }
        else
        {
            [self hideActView];
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"服务器出错，请稍后重试!"];
        }
    }
}

- (void)classRequestDidFailed:(ASIHTTPRequest *)request
{
    [self hideActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"网络请求失败，请检查网络连接"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource && Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CSMyConsumeRecordCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"ConsumeRecordCell"];
    
    if(cell == nil)
    {
        cell = [CSMyConsumeRecordCell createCell];
    }
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    [cell reloadConetent:dic];
    /*if (indexPath.row % 2 == 0)
    {
        [cell setBackgroundImage:[UIImage imageNamed:@"cell_bg_01.png"]];
    }
    else
    {
        [cell setBackgroundImage:[UIImage imageNamed:@"cell_bg_02.png"]]; 
    }*/
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)comfirmActionPressed:(id)sender
{
    if (isFromTime)
    {
        self.fromDate = self.datePicker.date;
    }
    else 
    {
        self.toDate = self.datePicker.date ;
    }
    [self setHeaderViewContent];
    CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePickerBackView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
    } completion:^(BOOL finish){
        [self.datePickerBackView removeFromSuperview];
    }];
    [self loadContent];

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


- (IBAction)rightButtonItemPressed:(id)sender
{
    [self loadContent];
}

- (IBAction)headerButtonPressed:(id)sender
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@""];
    [sheet setCancelButtonWithTitle:@"取消" block:nil];
    for (NSDictionary *dic in self.classArray)
    {
        [sheet setDestructiveButtonWithTitle:[dic objectForKey:@"typename"] block:^{
            self.currentClassInfoDic = dic;
            [self setHeaderViewContent];
            [self loadContent];
        }];
    }
    
    [sheet showInView:self.view];
}

- (IBAction)datePickerButtonPressed:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    if (item.tag == 0)
    {
        isFromTime = YES;
        [self.datePicker setDate:self.fromDate];
    }
    else
    {
        isFromTime = NO;
        [self.datePicker setDate:self.toDate];
    }
    
    CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;

    self.datePickerBackView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
    [delegate.window addSubview:self.datePickerBackView];
    [UIView animateWithDuration:0.3 animations:^{
        self.datePickerBackView.frame = CGRectMake(0, 0, 320, delegate.window.frame.size.height);
    }];
}

@end
