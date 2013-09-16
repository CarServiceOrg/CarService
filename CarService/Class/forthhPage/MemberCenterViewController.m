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

@interface MemberCenterViewController ()

@property (nonatomic,retain) IBOutlet UITableView *contentTableView;
@property (nonatomic,retain) ASIHTTPRequest *logoutRequest;

@end

@implementation MemberCenterViewController
@synthesize contentTableView;
@synthesize logoutRequest;
@synthesize parentController;

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
    self.contentTableView = nil;
    [logoutRequest clearDelegatesAndCancel];
    [logoutRequest release];
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

- (UIView *)getFooterView
{
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(0,0 , 123, 30);
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"personpage_logout_button.png"] forState:UIControlStateNormal];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"personpage_logout_button_click.png"] forState:UIControlStateHighlighted];
    [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
    [logoutButton setTitle:@"退出" forState:UIControlStateHighlighted];
    [logoutButton setTitleColor:[UIColor colorWithRed:(118/255.0) green:(40/255.0) blue:(24.0/255) alpha:1.0] forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor colorWithRed:(118/255.0) green:(40/255.0) blue:(24.0/255) alpha:1.0] forState:UIControlStateHighlighted];
    [logoutButton addTarget:self action:@selector(logoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2);
    [footerView addSubview:logoutButton];
    return  footerView;
}

#pragma mark - UITableView DataSource && Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo])
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
        iconView.image = [[UIImage imageNamed:@"gengduo_share.png"]autorelease];
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
    
    if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo])
    {
        
        if (indexPath.row == 0)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_top.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_top_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"我的资料";
            
        }
        else if (indexPath.row == 1)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"修改密码";
            
        }
        else if (indexPath.row == 2)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"我的消息";
            
        }
        else if (indexPath.row == 3)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"我的消费纪录";
            
        }
        else if (indexPath.row == 4)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_center_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"车辆跟踪";
            
        }
        else if (indexPath.row == 5)
        {
            normalImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_bottom.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            selectImage = [[UIImage imageWithCGImage:[UIImage imageNamed:@"membercenter_bottom_click.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
            title.text = @"我要评分";
            
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
        switch (indexPath.row)
        {
            case 0:
                CustomLog(@"我的资料");
            case 1:
                CustomLog(@"修改密码");
                break;
            case 2:
                CustomLog(@"我的消息");
                break;
            case 3:
                CustomLog(@"我的消费纪录");
                break;
            case 4:
                CustomLog(@"车辆跟踪");
                break;
            case 5:
                CustomLog(@"我要评分");
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

- (void)logoutUser
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserDefaultUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /*AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate cleanPushTag];
    
    [[Util sharedUtil] clearCookieInfo];
    */
    [self.contentTableView reloadData];
    self.contentTableView.tableFooterView = nil;
    
    //向服务器发logout请求
    self.logoutRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_logout]];
    self.logoutRequest.delegate = nil;
    [self.logoutRequest startAsynchronous];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)
    {
        
        [self logoutUser];
    }
}

- (IBAction)logoutButtonPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要退出帐户?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    [alert release];
}

@end
