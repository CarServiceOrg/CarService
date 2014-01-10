//
//  CSDaiWeiListViewCell.h
//  CarService
//
//  Created by baidu on 14-1-10.
//  Copyright (c) 2014年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSDaiWeiListViewCell : UITableViewCell

+ (CSDaiWeiListViewCell *)createCell;
- (void)reloadConetent:(NSDictionary *)dic;

@property (nonatomic,assign) UIViewController *parentViewController;

@end
