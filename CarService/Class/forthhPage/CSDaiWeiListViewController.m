//
//  CSDaiWeiListViewController.m
//  CarService
//
//  Created by baidu on 14-1-10.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSDaiWeiListViewController.h"
#import "ASIHTTPRequest.h"
#import "CSDaiWeiListViewCell.h"

@interface CSDaiWeiListViewController ()

@property (nonatomic,retain) IBOutlet UITableView *contentTableView;
@property (nonatomic,retain) ASIHTTPRequest *recordRuest;
@property (nonatomic,retain) NSMutableArray *dataArray;


@end

@implementation CSDaiWeiListViewController
@synthesize contentTableView;
@synthesize recordRuest;
@synthesize dataArray;


- (void)dealloc
{
    [contentTableView release];
    [recordRuest clearDelegatesAndCancel];
    [recordRuest release];
    [dataArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"暂无代维服务!"];
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

#pragma mark - UITableView DataSource && Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CSDaiWeiListViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"CSDaiWeiListViewCell"];
    
    if(cell == nil)
    {
        cell = [CSDaiWeiListViewCell createCell];
        cell.parentViewController = self;
    }
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    [cell reloadConetent:dic];
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
