//
//  MemberCenterViewController.m
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "ASIHTTPRequest.h"
#import "CSForthViewController.h"
#import "ChangePasswordController.h"
#import "CSMyConsumeRecordViewController.h"
#import "CSMyProfileViewController.h"
#import "CSCarTracViewController.h"
#import "CSMessageViewController.h"
#import "CSOrderListViewController.h"
#import "CSDaiWeiViewController.h"
#import "CSFirstViewController.h"
#import "CSHeartServiceViewController.h"

@interface MemberCenterViewController ()

@property (nonatomic,retain) IBOutlet UITableView *contentTableView;
@property (nonatomic,retain) ASIHTTPRequest *logoutRequest;
@property (nonatomic,retain) IBOutlet UILabel *timeLabel;
@property (nonatomic,retain) IBOutlet UILabel *weatherLabel;
@property (nonatomic,retain) IBOutlet UIImageView *sexImageView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UIButton *messageButton;

- (IBAction)messageButtonPressed:(id)sender;
- (IBAction)changePasswordButtonPressed:(id)sender;
- (IBAction)woDeDaiWeiButtonPressed:(id)sender;
- (IBAction)myResumeRecordButtonPressed:(id)sender;

@end

@implementation MemberCenterViewController
@synthesize contentTableView;
@synthesize logoutRequest;
@synthesize parentController;
@synthesize timeLabel;
@synthesize weatherLabel;
@synthesize sexImageView;
@synthesize nameLabel;
@synthesize messageButton;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.contentTableView = nil;
    [logoutRequest clearDelegatesAndCancel];
    [logoutRequest release];
    [timeLabel release];
    [weatherLabel release];
    [sexImageView release];
    [nameLabel release];
    [messageButton release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    //刷新消息数目
    [super viewWillAppear:animated];

}

- (void)reloadContent
{
    //CSFirstViewController *controller = (CSFirstViewController *)[self.parentController.navigationController.viewControllers objectAtIndex:0];
    CSFirstViewController *controller = [CSFirstViewController getCommonFirstController];
    if ([controller isKindOfClass:[CSFirstViewController class]])
    {
        CustomLog(@"set message and weather info");
        if (nil == controller.m_weatherDict)
        {
            self.timeLabel.text = @"加载时间失败";
            self.weatherLabel.text = @"加载天气信息失败";
        }
        else
        {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSString* string_time = [formatter stringFromDate:date];
            [formatter setDateFormat:@"EEEE"];
            NSString* week_day = [formatter stringFromDate:date];
            [formatter release];
            
            self.timeLabel.text = [NSString stringWithFormat:@"%@,%@",string_time,week_day];
            self.weatherLabel.text = [NSString stringWithFormat:@"%@  %@~%@",[controller.m_weatherDict objectForKey:@"weather"],[controller.m_weatherDict objectForKey:@"temp1"],[controller.m_weatherDict objectForKey:@"temp2"]];
        }
        
    }
    NSDictionary *userInfo = [[Util sharedUtil] getUserInfo];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ ,你好",[userInfo objectForKey:@"username"]];
    if ([[userInfo objectForKey:@"sex"] isEqualToString:@"0"])
    {
        self.sexImageView.hidden = YES;
        
    }
    else if ([[userInfo objectForKey:@"sex"] isEqualToString:@"1"])
    {
        self.sexImageView.image = [UIImage imageNamed:@"new_gerenziliao_nantubiao.png"];
        self.sexImageView.frame = CGRectMake(self.sexImageView.frame.origin.x, self.sexImageView.frame.origin.y, 18, 18);
        self.sexImageView.hidden = NO;
        
    }
    else
    {
        self.sexImageView.image = [UIImage imageNamed:@"new_gerenziliao_nvtubiao.png"];
        self.sexImageView.frame = CGRectMake(self.sexImageView.frame.origin.x, self.sexImageView.frame.origin.y, 12, 18);
        self.sexImageView.hidden = NO;
        
    }
    
    [self.messageButton setTitle:[NSString stringWithFormat:@"%d条",[controller getMessageUnReadNumber]] forState:UIControlStateNormal];
    [self.messageButton setTitle:[NSString stringWithFormat:@"%d条",[controller getMessageUnReadNumber]] forState:UIControlStateHighlighted];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentTableView.tableFooterView = [self getFooterView];
    [self reloadContent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContent) name:UserInfoChangeNotification object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)getFooterView
{
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(0,15 , 78, 29);
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"chaoxun_btn.png"] forState:UIControlStateNormal];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"chanxun_btn_press.png"] forState:UIControlStateHighlighted];
    [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
    [logoutButton setTitle:@"退出" forState:UIControlStateHighlighted];
    [logoutButton setTitleColor:[UIColor colorWithRed:(118/255.0) green:(40/255.0) blue:(24.0/255) alpha:1.0] forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor colorWithRed:(118/255.0) green:(40/255.0) blue:(24.0/255) alpha:1.0] forState:UIControlStateHighlighted];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [logoutButton addTarget:self action:@selector(logoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2);
    [footerView addSubview:logoutButton];
    return  footerView;
}

#pragma mark - UITableView DataSource && Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[Util sharedUtil] hasLogin])
    {
        return 6;
    }
    else
    {
        CustomLog(@"error happen here");
    }
    
    return 0;
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
    
    if ([[Util sharedUtil] hasLogin])
    {
        
        if (indexPath.row == 0)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_top.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_top_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"我的资料";
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"membercenter_profile.png"];
                icon.frame = CGRectMake(10, 13, 16, 15);
            }
            
        }
        else if (indexPath.row == 1)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"修改密码";
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"membercenter_password.png"];
                icon.frame = CGRectMake(10, 13, 15, 16);
            }
            
        }
        else if (indexPath.row == 2)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"我的消息";
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"membercenter_message.png"];
                icon.frame = CGRectMake(10, 13, 16, 12);
            }
            
        }
        else if (indexPath.row == 3)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"我的消费纪录";
            
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"membercenter_my_record.png"];
                icon.frame = CGRectMake(10, 13, 17, 18);
            }
            
        }
        else if (indexPath.row == 4)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"车辆跟踪";
            
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"membercenter_car_trac.png"];
                icon.frame = CGRectMake(10, 13, 16, 15);
            }
            
        }
        else if (indexPath.row == 5)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_bottom.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_bottom_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"我要点评";
            
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
            if (nil != icon)
            {
                icon.image = [UIImage imageNamed:@"membercenter_rate.png"];
                icon.frame = CGRectMake(10, 13, 15, 16);
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

- (IBAction)messageButtonPressed:(id)sender
{
    CSMessageViewController* controller = [[CSMessageViewController alloc] initWithNibName:nil bundle:nil];
    [self.parentController.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)changePasswordButtonPressed:(id)sender
{
    
    //test
    CSHeartServiceViewController *controller = [[CSHeartServiceViewController alloc] initWithNibName:@"CSHeartServiceViewController" bundle:nil];
    [self.parentController.navigationController pushViewController:controller animated:YES];
    [controller release];
    /*
    ChangePasswordController *controller = [[ChangePasswordController alloc] initWithNibName:@"ChangePasswordController" bundle:nil];
    [self.parentController.navigationController pushViewController:controller animated:YES];
    [controller release];*/
}
- (IBAction)woDeDaiWeiButtonPressed:(id)sender
{
    CSDaiWeiViewController *controller = [[CSDaiWeiViewController alloc] initWithNibName:@"CSDaiWeiViewController" bundle:nil];
    [self.parentController.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)myResumeRecordButtonPressed:(id)sender
{
    CSMyConsumeRecordViewController *controller = [[CSMyConsumeRecordViewController alloc] initWithNibName:@"CSMyConsumeRecordViewController" bundle:nil];
    [self.parentController.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller;
    if ([[Util sharedUtil] hasLogin])
    {
        switch (indexPath.row)
        {
            case 0:
                CustomLog(@"我的资料");
                controller = [[CSMyProfileViewController alloc] initWithNibName:@"CSMyProfileViewController" bundle:nil];
                [self.parentController.navigationController pushViewController:controller animated:YES];
                [controller release];
                break;
            case 1:
                CustomLog(@"修改密码");
                controller = [[ChangePasswordController alloc] initWithNibName:@"ChangePasswordController" bundle:nil];
                [self.parentController.navigationController pushViewController:controller animated:YES];
                [controller release];
                break;
            case 2:
                CustomLog(@"我的消息");
                controller = [[CSMessageViewController alloc] initWithNibName:nil bundle:nil];
                [self.parentController.navigationController pushViewController:controller animated:YES];
                [controller release];
                break;
            case 3:
                CustomLog(@"我的消费纪录");
                controller = [[CSMyConsumeRecordViewController alloc] initWithNibName:@"CSMyConsumeRecordViewController" bundle:nil];
                [self.parentController.navigationController pushViewController:controller animated:YES];
                [controller release];
                break;
            case 4:
                CustomLog(@"车辆跟踪");
                controller = [[CSCarTracViewController alloc] initWithNibName:@"CSCarTracViewController" bundle:nil];
                [self.parentController.navigationController pushViewController:controller animated:YES];
                [controller release];
                break;
            case 5:
                CustomLog(@"我要点评");
                controller = [[CSOrderListViewController alloc] initWithNibName:@"CSOrderListViewController" bundle:nil];
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

- (IBAction)profileButtonPressed:(id)sender
{
    CSMyProfileViewController *controller = [[CSMyProfileViewController alloc] initWithNibName:@"CSMyProfileViewController" bundle:nil];
    [self.parentController.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)logoutUser
{
    [[Util sharedUtil] logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:nil];
    //向服务器发logout请求
    self.logoutRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_logout]];
    self.logoutRequest.delegate = nil;
    [self.logoutRequest startAsynchronous];
}

- (IBAction)logoutButtonPressed:(id)sender
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:nil message:@"确定要退出帐户?"];
    [alert setCancelButtonWithTitle:@"取消" block:nil];
    [alert setDestructiveButtonWithTitle:@"确认" block:^{
        [self logoutUser];
    }];
    [alert show];
}

@end
