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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"个人中心";
    
    [self resetContentView];
}

- (void)resetContentView
{
    UIView *tempView = [self.view viewWithTag:ContentViewTag];
    if (nil != tempView)
    {
        [tempView removeFromSuperview];
    }
    
    if (nil != [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo])
    {
        MemberCenterViewController *controller = [[MemberCenterViewController alloc] initWithNibName:@"MemberCenterViewController" bundle:nil];
        controller.parentController = self;
        [self.view addSubview:controller.view];
        
        self.navigationItem.title = @"会员中心";
    }
    else
    {
        CSLogInViewController *controller = [[CSLogInViewController alloc] initWithNibName:@"CSLogInViewController" bundle:nil];
        controller.parentController = self;
        [self.view addSubview:controller.view];
        self.navigationItem.title = @"登陆";

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
