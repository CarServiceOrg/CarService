//
//  AboutViewController.m
//  iGuanZhong
//
//  Created by zhouochengyu on 13-8-21.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic,retain) IBOutlet UILabel *contentLabel;
@property (nonatomic,retain) IBOutlet UILabel *versionLabel;

@end

@implementation AboutViewController
@synthesize contentLabel;
@synthesize versionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"关于";
    
    self.versionLabel.text = [NSString stringWithFormat:@"版本号:%@",[[Util sharedUtil] get_appVersion]];
    if (Is_iPhone5)
    {
        self.contentLabel.center = CGPointMake(160, 320);
    }
}

- (void)dealloc
{
    [contentLabel release];
    [versionLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
