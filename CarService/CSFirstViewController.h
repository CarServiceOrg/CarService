//
//  CSFirstViewController.h
//  CarService
//
//  Created by Chao on 13-9-12.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSFirstViewController : IOS7ViewController
{
    
}

//天气 weather
//温度 temp1~temp2
@property(nonatomic,retain)NSDictionary* m_weatherDict; //天气
@property(nonatomic,retain)NSMutableArray* m_msgArray; //消息数组

+ (CSFirstViewController *)getCommonFirstController;

@end
