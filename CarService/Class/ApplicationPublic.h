//
//  ApplicationPublic.h
//  CarService
//
//  Created by baidu on 13-9-15.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMessage.h"

@interface ApplicationPublic : NSObject{
    
}

+(void)selfDefineNaviBar:(UINavigationBar*)naviBar;
+(void)selfDefineBg:(UIView*)superView; //背景
+(void)selfDefineNavigationBar:(UIView*)superView title:(NSString*)titleStr withTarget:(id)target with_action:(SEL)action; //透明导航栏 返回按钮
+(void)selfDefineNavigationBar:(UIView*)superView title:(NSString*)titleStr withTarget:(id)target with_action:(SEL)action rightBtn:(id)targetR with_action:(SEL)actionR; //导航栏有右按钮
+(UIImage*)getOriginImage:(NSString*)imageStr withInset:(UIEdgeInsets)insets;   //双倍分辨率下的图片
+(void)setUp_UITextField:(UIView*)superView with_frame:(CGRect)frame with_tag:(int)tag with_placeHolder:(NSString*)placeHolderStr with_delegate:(id)delegate;
+(void)setUp_BackBtn:(UINavigationItem*)navigationItem withTarget:(id)target with_action:(SEL)action;
+(void)showMessage:(UIViewController *)viewController with_title:(NSString*)titleStr with_detail:(NSString*)detailStr with_type:(TSMessageNotificationType)type with_Duration:(float)sec;

@end
