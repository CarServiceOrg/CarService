//
//  CSForthViewController.m
//  CarService
//
//  Created by baidu on 13-9-14.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSForthViewController.h"
#import "CSLoginViewController.h"

@interface CSForthViewController ()

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
    CSLogInViewController *controller = [[CSLogInViewController alloc] initWithNibName:@"CSLogInViewController" bundle:nil];
    controller.parentController = self;
    //CSLogInViewController *controller = [[CSLogInViewController alloc] init];
    [self.view addSubview:controller.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
