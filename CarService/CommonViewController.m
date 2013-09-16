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
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
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
