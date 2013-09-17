//
//  CSMoreViewController.h
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@class CSFifthViewController;

@interface CSMoreViewController : CommonViewController

@property (nonatomic,assign) CSFifthViewController *parentController;

- (IBAction)backButtonPressed:(id)sender;

@end
