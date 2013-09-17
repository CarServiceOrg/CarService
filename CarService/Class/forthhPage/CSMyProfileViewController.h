//
//  CSMyProfileViewController.h
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface CSMyProfileViewController : CommonViewController


- (id)initWithInfo:(NSMutableDictionary *)info;
- (IBAction)showDetailButtonPressed:(id)sender;
- (IBAction)comfirmActionPressed:(id)sender;
- (IBAction)cancelActionPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end
