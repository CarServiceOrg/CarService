//
//  CommonViewController.m
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@property (nonatomic,retain) UIActivityIndicatorView *actView;
@property (nonatomic,retain) UIView *fullActView;

@end

@implementation CommonViewController
@synthesize actView;
@synthesize fullActView;

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
}

- (IBAction)backButtonPressed:(id)sender
{
    
}

- (IBAction)rightButtonItemPressed:(id)sender
{
    
}

- (UIBarButtonItem *)getBackItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 41, 21)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_back_press.png"] forState:UIControlStateSelected];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithCustomView:button]autorelease];
    [button release];
    return item;
}

- (UIBarButtonItem *)getRithtItem:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 41, 21)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_back_press.png"] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithCustomView:button]autorelease];
    [button release];
    return item;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showActView:(UIActivityIndicatorViewStyle)style
{
    if (nil != self.actView)
    {
        [self.actView stopAnimating];
        [self.actView removeFromSuperview];
    }
    
    self.actView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style] autorelease];
    self.actView.hidesWhenStopped = YES;
    self.actView.center = self.view.center;
    [self.view addSubview:self.actView];
    [self.view bringSubviewToFront:self.actView];

    [self.actView startAnimating];
}

- (void)hideActView
{
    [self.actView stopAnimating];
}

- (void)showFullActView:(UIActivityIndicatorViewStyle)style
{
    if (nil != self.fullActView)
    {
        [self.fullActView removeFromSuperview];
    }
    
    UIView *tempView = [[UIView alloc] initWithFrame:self.view.bounds];
    tempView.backgroundColor = [UIColor blackColor];
    tempView.alpha = 0.4;
    self.fullActView = tempView;
    [tempView release];
    UIActivityIndicatorView *tempActView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style] autorelease];
    tempActView.hidesWhenStopped = YES;
    tempActView.center = self.view.center;
    [tempActView startAnimating];
    [fullActView addSubview:tempActView];
    [self.view addSubview:fullActView];
    [self.view bringSubviewToFront:self.fullActView];
    
}

- (void)hideFullActView
{
    [self.fullActView removeFromSuperview];
}
/*

- (void)showDetailController:(NSDictionary *)actInfo
{
    ActivityDetailViewController *controller = [[ActivityDetailViewController alloc] initWithActivityInfo:actInfo];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
*/

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [actView release];
    [fullActView release];
    [super dealloc];
}

@end
