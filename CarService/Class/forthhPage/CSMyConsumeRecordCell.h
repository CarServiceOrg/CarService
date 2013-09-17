//
//  CSMyConsumeRecordCell.h
//  CarService
//
//  Created by baidu on 13-9-16.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMyConsumeRecordCell : UITableViewCell

+ (CSMyConsumeRecordCell *)createCell;
- (void)reloadConetent:(NSDictionary *)dic;
- (void)setBackgroundImage:(UIImage *)image;

@end
