//
//  CSMessageViewController.m
//  CarService
//
//  Created by baidu on 13-9-23.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSMessageViewController.h"
#import "CSMessageTableViewCell.h"
#import "CSMessageDetailViewController.h"
#import "NSString+SBJSON.h"

@interface CSMessageViewController ()

@property (nonatomic,retain) IBOutlet UITableView *contentTableView;
@property (nonatomic,retain) ASIHTTPRequest *messageRequest;
@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation CSMessageViewController
@synthesize contentTableView;
@synthesize messageRequest;
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
    [contentTableView release];
    [messageRequest clearDelegatesAndCancel];
    [messageRequest release];
    [dataArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"我的消息";
    
    [self loadContent];
}

- (void)loadContent
{
    [self.messageRequest clearDelegatesAndCancel];
    NSDictionary *dic = [[Util sharedUtil] getUserInfo];
    NSString *uid = [dic objectForKey:@"id"];
    NSString *sessionId = [dic objectForKey:@"session_id"];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"station_news",@"action",uid,@"user_id",sessionId,@"session_id", nil];
    NSString *jsonArg = [[argDic JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr =[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg];
    CustomLog(@"<<Chao-->CSMessageViewController-->urlStr:%@",urlStr);
    self.messageRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    self.messageRequest.delegate = self;
    [self.messageRequest setDidFinishSelector:@selector(requestDidFinished:)];
    [self.messageRequest setDidFailSelector:@selector(requestDidFailed:)];
    [self.messageRequest startAsynchronous];
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
        self.dataArray = [requestDic objectForKey:@"list"];
        [self.contentTableView reloadData];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CSMessageTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"CSMessageTableViewCell"];
    
    if(cell == nil)
    {
        cell = [CSMessageTableViewCell createCell];
    }
    
    [cell reloadConetent:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"宏状元是北京很出名的一家连锁粥店，它把各种口味的粥做的滋味十足，虽然每种粥顶多算差强人意，不过想喝什么粥基本上都可以在粥店找到。宏状元粥店的小吃也是种类丰富，制作考究的，点几样小吃再来上一碗粥，不仅美味还十分健康。宏状元的菜也做得可以，凉菜主食分量十足",@"content",@"2013-09-01",@"time", nil];
    
    CSMessageDetailViewController *controller = [[CSMessageDetailViewController alloc] initWithContent:dic];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
