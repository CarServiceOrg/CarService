//
//  ApplicationPublic.m
//  CarService
//
//  Created by baidu on 13-9-15.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "ApplicationPublic.h"

@implementation ApplicationPublic

+(void)selfDefineNaviBar:(UINavigationBar*)naviBar
{
    [naviBar setBackgroundImage:[ApplicationPublic changeImageToCGImage:[UIImage imageNamed:@"navi_bg.png"]] forBarMetrics:UIBarMetricsDefault];
}

+(UIImage*)changeImageToCGImage:(UIImage*)image
{
    CGImageRef imageRef = image.CGImage;
    CGFloat targetWidth = 320*2;
    CGFloat targetHeight = 44*2;
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo =CGColorSpaceCreateDeviceRGB();
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little;
    }
    CGContextRef bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), (4 * targetWidth), colorSpaceInfo, bitmapInfo);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref scale:2.0 orientation:UIImageOrientationUp];
    CGColorSpaceRelease(colorSpaceInfo);
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return  newImage;
}


+(void)setUp_UITextField:(UIView*)superView with_frame:(CGRect)frame with_tag:(int)tag with_placeHolder:(NSString*)placeHolderStr with_delegate:(id)delegate
{
    UITextField* aTextField=[[UITextField alloc] initWithFrame:frame];
    if (tag>0) {
        aTextField.tag=tag;
    }
    [aTextField setTextAlignment:NSTextAlignmentLeft];
    [aTextField setBackground:[[UIImage imageNamed:@"black_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [aTextField setBackgroundColor:[UIColor clearColor]];
    [aTextField setTextColor:[UIColor whiteColor]];
    [aTextField setFont:[UIFont systemFontOfSize:14.0]];
    [aTextField setPlaceholder:placeHolderStr];
    {
        aTextField.delegate = delegate;//设置delegate为自己,不然按下Done键键盘消失不了
        aTextField.returnKeyType = UIReturnKeyDone; //设置键盘返回形式
        aTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //输入内容后会显示个X
        aTextField.keyboardType = UIKeyboardTypeDefault; //键盘显示类型
        aTextField.autocorrectionType = UITextAutocorrectionTypeNo; //是否自动提醒功能
        aTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; //设置输入方式
        aTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;  //自适应宽度
    }
    {
        aTextField.leftViewMode=UITextFieldViewModeAlways;
        aTextField.leftView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, frame.size.height)] autorelease];
    }
    
    [superView addSubview:aTextField];
    [aTextField release];
}

+(void)setUp_BackBtn:(UINavigationItem*)navigationItem withTarget:(id)target with_action:(SEL)action
{
    float x, y, width, height;
    //隐藏返回键
    navigationItem.hidesBackButton=YES;
    //返回按钮
    x=10; y=8; width=82/2.0+4; height=26;
    UIButton* backBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [backBtn setTitleColor:[UIColor colorWithRed:13/255.0 green:43/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"btn_back_press.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    [backBtn release];
}

//提示信息
+(void)showMessage:(UIViewController *)viewController with_title:(NSString*)titleStr with_detail:(NSString*)detailStr with_type:(TSMessageNotificationType)type with_Duration:(float)sec
{
    [TSMessage showNotificationInViewController:viewController
                                          title:titleStr
                                       subtitle:detailStr
                                          image:nil
                                           type:type
                                       duration:sec 
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                            canBeDismisedByUser:YES];
}


@end
