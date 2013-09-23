//
//  CSMessageTableViewCell.h
//  CarService
//
//  Created by baidu on 13-9-23.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMessageTableViewCell : UITableViewCell

+ (CSMessageTableViewCell *)createCell;
- (void)reloadConetent:(NSDictionary *)dic;

@end
