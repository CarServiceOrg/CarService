//
//  CSOrderListCell.h
//  CarService
//
//  Created by baidu on 13-9-24.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSOrderListCell : UITableViewCell

+ (CSOrderListCell *)createCell;
- (void)reloadConetent:(NSDictionary *)dic;
- (void)setBackgroundImage:(UIImage *)newImage;

@end
