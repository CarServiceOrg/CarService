//
//  CSOrderListViewController.m
//  CarService
//
//  Created by baidu on 13-9-24.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSOrderListViewController.h"
#import "ASIHTTPRequest.h"
#import "CSOrderListCell.h"
#import "CSCommentViewController.h"

@interface CSOrderListViewController ()

@property (nonatomic,retain) IBOutlet UIView *headerView;
@property (nonatomic,retain) IBOutlet UITableView *contentTableView;
@property (nonatomic,retain) ASIHTTPRequest *recordRuest;
@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation CSOrderListViewController
@synthesize headerView;
@synthesize contentTableView;
@synthesize recordRuest;
@synthesize dataArray;

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
    [headerView release];
    [contentTableView release];
    [recordRuest clearDelegatesAndCancel];
    [recordRuest release];
    [dataArray release];
    [super dealloc];
}

- (void)receiveOrderRateNotification:(NSNotification *)notify
{
    CSCommentViewController *controller = [[CSCommentViewController alloc] initWithNibName:@"CSCommentViewController" bundle:nil];
    controller.orderInfoDic = notify.userInfo;
     [self.navigationController pushViewController:controller animated:YES];
     [controller release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOrderRateNotification:) name:RateOrderNotification object:nil];
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"代维服务列表";
    self.headerView.hidden = YES;
    [self loadContent];
}

- (void)loadContent
{
    [self.recordRuest clearDelegatesAndCancel];
    NSDictionary *dic = [[Util sharedUtil] getUserInfo];
    NSString *uid = [dic objectForKey:@"id"];
    NSString *sessionId = [dic objectForKey:@"session_id"];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"order_list",@"action",sessionId,@"session_id",uid,@"user_id",nil];
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.recordRuest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];
    self.recordRuest.delegate = self;
    [self.recordRuest setDidFinishSelector:@selector(requestDidFinished:)];
    [self.recordRuest setDidFailSelector:@selector(requestDidFailed:)];
    [self.recordRuest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleWhite];
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
                self.dataArray = [requestDic objectForKey:@"list"];
                if ([self.dataArray count] > 0)
                {
                    [self.contentTableView reloadData];
                    self.headerView.hidden = NO;
                }
                break;
            case 2:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"session id不正确，请重新登陆!"];
                break;
            case 3:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"用户id不正确，请重新登陆!"];
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
    
    CSOrderListCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"CSOrderListCell"];
    
    if(cell == nil)
    {
        cell = [CSOrderListCell createCell];
    }
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    [cell reloadConetent:dic];
    
    if (indexPath.row % 2 == 0)
    {
        [cell setBackgroundImage:[UIImage imageNamed:@"cell_bg_01.png"]];
    }
    else
    {
        [cell setBackgroundImage:[UIImage imageNamed:@"cell_bg_02.png"]];
    }
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

@end
