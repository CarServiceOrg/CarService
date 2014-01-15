//
//  CSAddConsumeRecordViewController.h
//  CarService
//
//  Created by baidu on 14-1-15.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

#define ConsumeRecordChangeNotification @"ConsumeRecordChangeNotification"

@interface CSAddConsumeRecordViewController : CommonViewController<UITextFieldDelegate>

- (id)initWithTypeDic:(NSArray *)typeDicArray;

@end
