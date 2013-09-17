//
//  CSSettingsViewController.m
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSSettingsViewController.h"
#import "Util.h"

@interface CSSettingsViewController ()

@property (nonatomic,retain) IBOutlet UILabel *tipLabel;

@end

@implementation CSSettingsViewController
@synthesize tipLabel;

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
    [tipLabel release];
    [super dealloc];
}

- (IBAction)clearButtonPressed:(id)sender
{
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"清空图片缓存成功"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.title = @"设置";
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
