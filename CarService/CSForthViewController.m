//
//  CSForthViewController.m
//  CarService
//
//  Created by baidu on 13-9-14.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSForthViewController.h"
#import "CSLoginViewController.h"
#import "MemberCenterViewController.h"

#define ContentViewTag 1000

@interface CSForthViewController ()

- (void)resetContentView;

@end

@implementation CSForthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)receiviLoginNotification:(NSNotification *)notify
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self resetContentView];
}

- (void)receiviLogoutNotification:(NSNotification *)notify
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self resetContentView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiviLoginNotification:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiviLogoutNotification:) name:LogoutSuccessNotification object:nil];
    
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    
    [self resetContentView];
}

- (void)resetContentView
{
    UIView *tempView = [self.view viewWithTag:ContentViewTag];
    if (nil != tempView)
    {
        [tempView removeFromSuperview];
    }
    
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:100];
    if ([[Util sharedUtil] hasLogin])
    {
        MemberCenterViewController *controller = [[MemberCenterViewController alloc] initWithNibName:@"MemberCenterViewController" bundle:nil];
        controller.parentController = self;
        
        [self.view addSubview:controller.view];
        
        titleLabel.text = @"会员中心";
    }
    else
    {
        CSLogInViewController *controller = [[CSLogInViewController alloc] initWithNibName:@"CSLogInViewController" bundle:nil];
        controller.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        controller.parentController = self;
        [self.view addSubview:controller.view];
        titleLabel.text = @"登陆";
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
