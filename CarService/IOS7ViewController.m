//
//  IOS7ViewController.m
//  CarService
//
//  Created by baidu on 14-1-8.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import "IOS7ViewController.h"

@interface IOS7ViewController ()

@end

@implementation IOS7ViewController

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
    
    // 强制VC为全屏坐标，其实点为0.0，让iOS6和iOS7保持一致
    // 尽量不要使用系统的NavigationBar,否则跨版本不好控制工具栏
    [self setWantsFullScreenLayout:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
