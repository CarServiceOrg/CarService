//
//  CSFifthViewController.m
//  CarService
//
//  Created by baidu on 13-9-14.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSFifthViewController.h"

@interface CSFifthViewController ()

@end

@implementation CSFifthViewController

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
    self.navigationItem.title=@"更多";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
