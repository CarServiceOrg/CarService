//
//  CSMyConsumeRecordViewController.m
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSMyConsumeRecordViewController.h"
#import "CSMyConsumeRecordCell.h"

@interface CSMyConsumeRecordViewController ()

@property (nonatomic,retain) IBOutlet UIView *headerView;
@property (nonatomic,retain) IBOutlet UITableView *contentTableView;
@property (nonatomic,retain) ASIHTTPRequest *recordRuest;
@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation CSMyConsumeRecordViewController
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
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"修改密码";
    
}

- (void)loadContent
{
    [self.recordRuest clearDelegatesAndCancel];
    self.recordRuest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_myconsumerecord]];
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
    if (nil == [requestDic objectForKey:@"code"])
    {
        CustomLog(@"parse error");
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"服务器出错，请稍后重试!"];
        return;
    }
    else
    {
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
    
    CSMyConsumeRecordCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"ConsumeRecordCell"];
    
    if(cell == nil)
    {
        cell = [CSMyConsumeRecordCell createCell];
    }
    
    [cell reloadConetent:nil];
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
