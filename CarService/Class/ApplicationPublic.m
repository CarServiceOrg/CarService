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
    [superView addSubview:aTextField];
    [aTextField release];
}


@end
