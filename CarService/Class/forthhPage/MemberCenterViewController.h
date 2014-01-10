//
//  MemberCenterViewController.h
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@class CSForthViewController;

@interface MemberCenterViewController : CommonViewController

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)profileButtonPressed:(id)sender;

@property (nonatomic,assign) CSForthViewController *parentController;

@end
