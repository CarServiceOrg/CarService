//
//  ApplicationPublic.h
//  CarService
//
//  Created by baidu on 13-9-15.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationPublic : NSObject{
    
}

+(void)selfDefineNaviBar:(UINavigationBar*)naviBar;
+(void)setUp_UITextField:(UIView*)superView with_frame:(CGRect)frame with_tag:(int)tag with_placeHolder:(NSString*)placeHolderStr with_delegate:(id)delegate;
+(void)setUp_BackBtn:(UINavigationItem*)navigationItem withTarget:(id)target with_action:(SEL)action;

@end
