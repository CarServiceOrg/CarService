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
#import "CSCommentViewController.h"

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
    self.contentTableView.tableFooterView = [self getFooterView];
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
                controller = [[CSCommentViewController alloc] initWithNibName:@"CSCommentViewController" bundle:nil];
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

- (void)logoutUser
{
    [[Util sharedUtil] logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:nil];
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
