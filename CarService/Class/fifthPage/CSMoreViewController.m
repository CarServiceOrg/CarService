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
#import "WeiboSDK.h"

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

- (void)receiveShareResultNotification:(NSNotification *)notify
{
    NSDictionary *dic = notify.userInfo;
    int status = [[dic objectForKey:@"statusCode"]intValue];
    if (status == WeiboSDKResponseStatusCodeSuccess)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"分享成功"];
    }
    else if (status == WeiboSDKResponseStatusCodeUserCancel)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"用户取消发送"];
    }
    else if (status == WeiboSDKResponseStatusCodeSentFail)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"分享失败"];
    }
    else if (status == WeiboSDKResponseStatusCodeAuthDeny)
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"授权失败，请稍后重试"];
    }
    else if (status == WeiboSDKResponseStatusCodeUserCancelInstall)
    {
        //[[Util sharedUtil] showAlertWithTitle:@"" message:@"用户取消安装客户端"];
    }
    else
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"分享失败"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShareResultNotification:) name:SinaWeiboShareResultNotification object:nil];
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
    
    //if ([[Util sharedUtil] hasLogin])
    
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
            //分享
            BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@""];
            [sheet setCancelButtonWithTitle:@"取消" block:nil];
            [sheet setDestructiveButtonWithTitle:@"新浪微博" block:^{
                WBImageObject *imageObject = [WBImageObject object];
                imageObject.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"test" ofType:@"png" ]];
                WBMessageObject *message1 = [ [ WBMessageObject alloc] init];
                message1.text = @"This is a test";
                //message1.imageObject = imageObject;
                WBSendMessageToWeiboRequest *req = [[[WBSendMessageToWeiboRequest alloc] init] autorelease];
                req.message = message1;
                BOOL ret = [ WeiboSDK sendRequest:req ];
                if (!ret)
                {
                    CustomLog(@"arg wrong");
                    [[Util sharedUtil] showAlertWithTitle:@"" message:@"分享失败，请稍后重试"];
                }
                else
                {
                    CustomLog(@"share by sina weibo app");
                }

            }];
            [sheet setDestructiveButtonWithTitle:@"短信" block:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://10086"]];
            }];
            [sheet showInView:self.view];
            
                        break;
        case 4:
            CustomLog(@"客服电话");
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"客服电话" message:@"是否电话呼叫咨询？"];
            [alert setCancelButtonWithTitle:@"取消" block:nil];
            [alert setDestructiveButtonWithTitle:@"呼叫" block:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",TELEPHONE_KEFU]]];
            }];
            [alert show];

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

- (IBAction)backButtonPressed:(id)sender
{
    [self.parentController.navigationController popViewControllerAnimated:YES];
}

- (void)checkNewVersion
{
    [self.checkVersionRequest clearDelegatesAndCancel];
    
    //NSString *uid = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo] objectForKey:@"id"];
    //NSString *sessionId = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo] objectForKey:@"session_id"];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS",@"sys",@"versiongoup",@"action", nil];
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.checkVersionRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];
    
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
    if (nil == [requestDic objectForKey:@"status"])
    {
        CustomLog(@"parse error");
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"服务器出错，请稍后重试"];

        return;
    }
    else
    {
        if ([[requestDic objectForKey:@"status"] integerValue]==0)
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
                
             BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:content];
             [alert setCancelButtonWithTitle:@"取消" block:nil];
             [alert setDestructiveButtonWithTitle:@"确定" block:^{
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_rateurl]];

             }];
             [alert show];
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

@end
