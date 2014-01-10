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


@property(nonatomic,retain)NSDictionary* m_weatherDict; //天气
//定位城市
//天气 weather1
//风力 wind1
//日期 date_y
//星期几 week
//天气图片 1008 weather1
//温度 1009 temp1
@property(nonatomic,retain)NSMutableArray* m_msgArray; //消息数组

@end
