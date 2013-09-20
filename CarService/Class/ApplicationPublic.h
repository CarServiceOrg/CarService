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
+(void)setUp_UITextField:(UIView*)superView with_frame:(CGRect)frame with_tag:(int)tag with_placeHolder:(NSString*)placeHolderStr with_delegate:(id)delegate;
+(void)setUp_BackBtn:(UINavigationItem*)navigationItem withTarget:(id)target with_action:(SEL)action;
+(void)showMessage:(UIViewController *)viewController with_title:(NSString*)titleStr with_detail:(NSString*)detailStr with_type:(TSMessageNotificationType)type with_Duration:(float)sec;

@end
