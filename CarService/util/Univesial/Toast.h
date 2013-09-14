//
//  Toast.h
//  iToastDemo
//  
//  Created by amao on 12/12/11.
//  Copyright (c) 2011 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kToastPositionTop,
    kToastPositionCenter,
    kToastPositionBottom,
} ToastPosition;  //设置位置

typedef enum { 
    kToastDurationShort = 1000,	
    kToastDurationNormal= 3000,
    kToastDurationLong  =10000,
} ToastDuration; //显示时间

@interface Toast : NSObject{
    ToastPosition   toastPosition;
    ToastDuration   toastDuration;
    NSString* toastText;
    UIView* toastView;
}

@property (assign,nonatomic)ToastPosition toastPosition;
@property (assign,nonatomic)ToastDuration toastDuration;
@property (retain,nonatomic)NSString* toastText;
@property (retain,nonatomic)UIView* toastView;

- (id)initWithText: (NSString *)text;
- (void)showToast;
- (void)onHideToast: (NSTimer *)timer;
- (void)doHideToast;

@end
