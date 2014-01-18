//
//  CSWoDeDaiWeiViewController.m
//  CarService
//
//  Created by baidu on 14-1-10.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "CSWoDeDaiWeiViewController.h"
#import "ASIHTTPRequest.h"
#import "CSCarTracViewController.h"
#import "LBSDataUtil.h"
#import "UIImageView+WebCache.h"

@interface CSWoDeDaiWeiViewController ()

@property (nonatomic,retain) IBOutlet UILabel *timeLabel;
@property (nonatomic,retain) IBOutlet UILabel *locationLabel;
@property (nonatomic,retain) IBOutlet UILabel *personLabel;
@property (nonatomic,retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic,retain) IBOutlet UILabel *detailLabel;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) IBOutlet ASIHTTPRequest *infoRequest;
@property (nonatomic,retain) IBOutlet UIView *contentView;
@property (nonatomic,retain) IBOutlet NSDictionary *originalInfoDic;
@property (nonatomic,retain) NSDictionary *contentDic;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)carTracButtonPressed:(id)sender;

@end

@implementation CSWoDeDaiWeiViewController
@synthesize timeLabel;
@synthesize locationLabel;
@synthesize personLabel;
@synthesize phoneLabel;
@synthesize detailLabel;
@synthesize imageView;
@synthesize infoRequest;
@synthesize contentView;
@synthesize originalInfoDic;
@synthesize contentDic;

- (id) initWithOrderInfo:(NSDictionary *)info
{
    self = [super initWithNibName:@"CSWoDeDaiWeiViewController" bundle:nil];
    if (self)
    {
        self.originalInfoDic = info;
    }
    return self;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [originalInfoDic release];
    [contentView release];
    [timeLabel release];
    [locationLabel release];
    [personLabel release];
    [phoneLabel release];
    [detailLabel release];
    [infoRequest clearDelegatesAndCancel];
    [infoRequest release];
    [imageView release];
    [contentDic release];
    [super dealloc];
}

- (void)loadContent
{
    [self.infoRequest clearDelegatesAndCancel];
    NSDictionary *dic = [[Util sharedUtil] getUserInfo];
    //NSString *uid = [dic objectForKey:@"id"];
   // NSString *sessionId = [dic objectForKey:@"session_id"];
    
    double longitude=[LBSDataUtil shareUtil].m_addrResult.geoPt.longitude;
    double latitude=[LBSDataUtil shareUtil].m_addrResult.geoPt.latitude;
    NSString *longitudeStr = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:longitude*100]];
    NSString *latitudeStr = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:latitude*100]];
    NSString *address = [LBSDataUtil shareUtil].address;
    
    //NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"k_order_status",@"action",[self.originalInfoDic objectForKey:@"id"],@"id",[dic objectForKey:@"phone"],@"phone",[self.originalInfoDic objectForKey:@"name"],@"server_name",address,@"address",longitudeStr,@"lon",latitudeStr,@"lat", nil];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"k_order_status",@"action",[self.originalInfoDic objectForKey:@"id"],@"id", nil];

    
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.infoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];
    self.infoRequest.delegate = self;
    [self.infoRequest setDidFinishSelector:@selector(requestDidFinished:)];
    [self.infoRequest setDidFailSelector:@selector(requestDidFailed:)];
    [self.infoRequest startAsynchronous];
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
                CustomLog(@"set data");
                self.contentDic = requestDic;
                NSDictionary *info = [requestDic objectForKey:@"list"];
                self.contentView.hidden = NO;
                [self.imageView setImageWithURL:[NSURL URLWithString:[info objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"new_daiweifuwu_tupianweishangchuan_tupianbeijing.png"]];
                self.timeLabel.text = [info objectForKey:@"addtime"];
                self.locationLabel.text = [info objectForKey:@"address"];
                self.personLabel.text = [info objectForKey:@"server_name"];
                self.phoneLabel.text = [info objectForKey:@"phone"];
                
                NSString *description = [info objectForKey:@"description"];
                CGSize size = [description sizeWithFont:self.detailLabel.font constrainedToSize:CGSizeMake(self.detailLabel.frame.size.width, 1000)];
                self.detailLabel.frame = CGRectMake(self.detailLabel.frame.origin.x, self.detailLabel.frame.origin.y,self.detailLabel.frame.size.width, size.height+5);
                self.detailLabel.text = [info objectForKey:@"description"];
                break;
            case 3:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"代维人，请稍后重试!"];
                break;
            case 4:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"电话不正确，请稍后重试!"];
                break;
            case 5:
                [[Util sharedUtil] showAlertWithTitle:@"" message:@"抵制不正确，请稍后重试!"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentView.hidden = YES;
    [self loadContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)carTracButtonPressed:(id)sender
{
    CSCarTracViewController *controller = [[CSCarTracViewController alloc] initWithDaiWeiInfo:self.contentDic];
    [self.navigationController pushViewController:controller  animated:YES];
    [controller release];
}

@end
