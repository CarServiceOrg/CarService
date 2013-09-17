//
//  CSMoreViewController.m
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSMoreViewController.h"
#import "CSFifthViewController.h"
#import "CSSettingsViewController.h"
#import "CSFeedBackViewController.h"
#import "ASIHTTPRequest.h"
#import "AboutViewController.h"

#define AlertTag_NewVersion 1000

@interface CSMoreViewController ()

@property (nonatomic,retain) IBOutlet UITableView *contentTableView;
@property (nonatomic,retain) ASIHTTPRequest *checkVersionRequest;

- (void)checkNewVersion;

@end

@implementation CSMoreViewController
@synthesize contentTableView;
@synthesize parentController;
@synthesize checkVersionRequest;

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
    [checkVersionRequest clearDelegatesAndCancel];
    [checkVersionRequest release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource && Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ImageTypeCell = @"ManagerCell";
    
    UITableViewCell *cell;
    UIImageView *iconView;
    UILabel *title;
    
    cell = [tableView dequeueReusableCellWithIdentifier:ImageTypeCell];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageTypeCell]autorelease];
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 18, 17)];
        iconView.tag = 1000;
        [cell.contentView addSubview:iconView];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 150, 44)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:14];
        title.minimumFontSize = 10;
        title.adjustsFontSizeToFitWidth = YES;
        title.textAlignment = UITextAlignmentLeft;
        title.textColor = [UIColor colorWithRed:0x81/255.0f green:0x81/255.0f blue:0x81/255.0f alpha:1];
        title.tag = 100;
        [cell.contentView addSubview:title];
        [title release];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"membercenter_arrow.png"]];
        arrowView.frame = CGRectMake(280, 16, 8, 11);
        
        [cell.contentView addSubview:arrowView];
        [arrowView release];
    }
    
    title = (UILabel *)[cell.contentView viewWithTag:100];
    
    UIImage *normalImage = nil;
    UIImage *selectImage = nil;
    
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo])
    {
        
        if (indexPath.row == 0)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_top.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_top_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"设置";
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"gengduo_setting.png"];
                icon.frame = CGRectMake(10, 13, 18, 17);
            }
            
        }
        else if (indexPath.row == 1)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"意见反馈";
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"gengduo_feedback.png"];
                icon.frame = CGRectMake(10, 13, 18, 17);
            }
            
        }
        else if (indexPath.row == 2)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"检查更新";
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"gengduo_update.png"];
                icon.frame = CGRectMake(10, 13, 18, 17);
            }
            
        }
        else if (indexPath.row == 3)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"分享软件";
            
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"gengduo_share.png"];
                icon.frame = CGRectMake(10, 13, 18, 17);
            }
            
        }
        else if (indexPath.row == 4)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"客服电话";
            
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"gengduo_phone.png"];
                icon.frame = CGRectMake(10, 13, 18, 17);
            }
            
        }
        else if (indexPath.row == 5)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_bottom.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_bottom_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"关于";
            
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"gengduo_about.png"];
                icon.frame = CGRectMake(10, 13, 18, 17);
            }
            
        }
        
    }
    else
    {
        CustomLog(@"error here");
    }
    
    if (nil != normalImage && nil != selectImage)
    {
        cell.backgroundView = [[[UIImageView alloc] initWithImage:normalImage]autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc]initWithImage:selectImage]autorelease];
    }
    else
    {
        cell.backgroundView.hidden = YES;
        cell.selectedBackgroundView.hidden = YES;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo])
    {
        UIViewController *controller;
        
        switch (indexPath.row)
        {
            case 0:
                CustomLog(@"设置");
                controller = [[CSSettingsViewController alloc] initWithNibName:@"CSSettingsViewController" bundle:nil];
                [self.parentController.navigationController pushViewController:controller animated:YES];
                [controller release];
                break;
            case 1:
                CustomLog(@"意见反馈");
                controller = [[CSFeedBackViewController alloc] initWithNibName:@"CSFeedBackViewController" bundle:nil];
                [self.parentController.navigationController pushViewController:controller animated:YES];
                [controller release];
                break;
            case 2:
                CustomLog(@"检查更新");
                [self checkNewVersion];
                break;
            case 3:
                CustomLog(@"分享软件");
                break;
            case 4:
                CustomLog(@"客服电话");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
                break;
            case 5:
                CustomLog(@"关于");
                controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
                [self.parentController.navigationController pushViewController:controller animated:YES];
                [controller release];
                break;
            default:
                break;
        }
    }
    else
    {
        CustomLog(@"Do Nothing");
    }
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.parentController.navigationController popViewControllerAnimated:YES];
}

- (void)checkNewVersion
{
    [self.checkVersionRequest clearDelegatesAndCancel];
    self.checkVersionRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_checknewversion]];
    self.checkVersionRequest.delegate = self;
    [self.checkVersionRequest setDidFinishSelector:@selector(requestDidFinished:)];
    [self.checkVersionRequest setDidFailSelector:@selector(requestDidFailed:)];
    [self.checkVersionRequest startAsynchronous];
    [self showFullActView:UIActivityIndicatorViewStyleWhite];
}

#pragma mark - ASIHttpRequest Delegate Methods

- (void)requestDidFinished:(ASIHTTPRequest *)request
{
    [self hideFullActView];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *responseString = [[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease];
    
    NSDictionary *requestDic = [responseString JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == [requestDic objectForKey:@"code"])
    {
        CustomLog(@"parse error");
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"服务器出错，请稍后重试"];

        return;
    }
    else
    {
        if ([[requestDic objectForKey:@"code"] isEqualToString:@"0"])
        {
            NSString *content = [[requestDic objectForKey:@"data"] objectForKey:@"content"];
            NSString *newVersion = [[requestDic objectForKey:@"data"] objectForKey:@"version"];
            
            if ([newVersion floatValue] > [[[Util sharedUtil] get_appVersion]floatValue])
            {
                CustomLog(@"new version exist");
                if ([content length] == 0)
                {
                    content = @"有新版本了,是否现在更新?";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alert.tag = AlertTag_NewVersion;
                [alert show];
                [alert release];
            }
        }
        else
        {
            CustomLog(@"parse error");
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"服务器出错，请稍后重试"];

        }
    }
}

- (void)requestDidFailed:(ASIHTTPRequest *)request
{
    [self hideFullActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"请求失败，请检查网络连接"];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AlertTag_NewVersion)
    {
        CustomLog(@"index:%d",buttonIndex);
        switch (buttonIndex)
        {
            case 0:
                CustomLog(@"cancel");
                break;
            case 1:
                CustomLog(@"update now");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_rateurl]];
                break;
            default:
                break;
        }
    }
}

@end
