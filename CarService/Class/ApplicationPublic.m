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
    naviBar.hidden = YES;
    [naviBar setBackgroundImage:[ApplicationPublic changeImageToCGImage:[UIImage imageNamed:@"navi_bg.png"]] forBarMetrics:UIBarMetricsDefault];
}

+(void)selfDefineBg:(UIView*)superView
{
    //背景
    UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, DiffY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (Is_iPhone5) {
        [bgImageView setImage:[UIImage imageNamed:@"new_shouye_bg.png"]]; // shouye_iphone5.png
    }else{
        [bgImageView setImage:[UIImage imageNamed:@"new_shouye_bg.png"]];
    }
    bgImageView.backgroundColor=[UIColor clearColor];
    [superView addSubview:bgImageView];
    [superView sendSubviewToBack:bgImageView];
    [bgImageView release];
}

+(void)selfDefineNavigationBar:(UIView*)superView title:(NSString*)titleStr withTarget:(id)target with_action:(SEL)action
{
    CGRect frame=CGRectMake(0, DiffY, [UIScreen mainScreen].bounds.size.width, 44);
    UIImageView* naviImgView=[[UIImageView alloc] initWithFrame:frame];
    naviImgView.backgroundColor =[UIColor clearColor];
    [superView addSubview:naviImgView];
    naviImgView.userInteractionEnabled=YES;
    [naviImgView release];
    
    //返回按钮
    UIButton* backBtn=[[UIButton alloc] initWithFrame:CGRectMake(8, (frame.size.height-34)/2.0, 34, 34)];
    backBtn.backgroundColor=[UIColor clearColor];
    [backBtn  setBackgroundImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"new_xiaofeijilu_fanhui_anniu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
    [backBtn  setBackgroundImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"new_xiaofeijilu_fanhui_dianjianniu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [naviImgView addSubview:backBtn];
    [backBtn release];
    
    UILabel* textLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame)+10, 0, CGRectGetWidth(frame)-10-CGRectGetMaxX(backBtn.frame)*2-10, frame.size.height)];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [textLabel setText:titleStr];
    [naviImgView addSubview:textLabel];
    [textLabel release];
}

+(void)selfDefineNavigationBar:(UIView*)superView title:(NSString*)titleStr withTarget:(id)target with_action:(SEL)action rightBtn:(UIButton*)rightBtn
{
    CGRect frame=CGRectMake(0, DiffY, [UIScreen mainScreen].bounds.size.width, 44);
    UIImageView* naviImgView=[[UIImageView alloc] initWithFrame:frame];
    naviImgView.backgroundColor =[UIColor clearColor];
    [superView addSubview:naviImgView];
    naviImgView.userInteractionEnabled=YES;
    [naviImgView release];
    
    //返回按钮
    UIButton* backBtn=[[UIButton alloc] initWithFrame:CGRectMake(8, (frame.size.height-34)/2.0, 34, 34)];
    backBtn.backgroundColor=[UIColor clearColor];
    [backBtn  setBackgroundImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"new_xiaofeijilu_fanhui_anniu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateNormal];
    [backBtn  setBackgroundImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"new_xiaofeijilu_fanhui_dianjianniu.png"].CGImage scale:2.0 orientation:UIImageOrientationUp] forState:UIControlStateHighlighted];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [naviImgView addSubview:backBtn];
    [backBtn release];
    
    //right按钮
    rightBtn.frame=CGRectMake(frame.size.width-10-CGRectGetWidth(rightBtn.frame), (frame.size.height-CGRectGetHeight(rightBtn.frame))/2.0, CGRectGetWidth(rightBtn.frame), CGRectGetHeight(rightBtn.frame));
    [naviImgView addSubview:rightBtn];
    
    UILabel* textLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame)+10, 0, CGRectGetMinX(rightBtn.frame)-10-CGRectGetMaxX(backBtn.frame)-10, frame.size.height)];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [textLabel setText:titleStr];
    [naviImgView addSubview:textLabel];
    [textLabel release];
}

+(void)setLeftView:(UITextField*)aField text:(NSString*)text flag:(BOOL)isFlag fontSize:(float)fSize
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel* aLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, aField.frame.size.height/2.0, aField.frame.size.height)];
    [aLabel setBackgroundColor:[UIColor clearColor]];
    aLabel.textAlignment=NSTextAlignmentRight;
    aLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    aLabel.textColor=[UIColor blackColor];
    aLabel.font=[UIFont systemFontOfSize:30];
    aLabel.text=@"*";
    [view addSubview:aLabel];
    [aLabel release];
    if (isFlag==NO) {
        aLabel.frame=CGRectZero;
    }
    
    UIFont* textFont=[UIFont systemFontOfSize:fSize];
    CGSize textSize=[text sizeWithFont:textFont];
    UILabel* bLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(aLabel.frame), 0, textSize.width, aField.frame.size.height)];
    bLabel.backgroundColor=[UIColor clearColor];
    bLabel.textAlignment=NSTextAlignmentLeft;
    bLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    bLabel.textColor=[UIColor blackColor];
    bLabel.font=textFont;
    bLabel.text=text;
    [view addSubview:bLabel];
    [bLabel release];
    
    if (aField.tag==101) {
        UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bLabel.frame), (aField.frame.size.height-18)/2.0, 18, 18)];
        [imageView setImage:[UIImage imageNamed:@"new_weichangchaxun_jing.png"]];
        [view addSubview:imageView];
        [imageView release];
        
        view.frame=CGRectMake(0, 0, CGRectGetWidth(aLabel.frame)+CGRectGetWidth(bLabel.frame)+CGRectGetWidth(imageView.frame)+5, aField.frame.size.height);
    }else{
        view.frame=CGRectMake(0, 0, CGRectGetWidth(aLabel.frame)+CGRectGetWidth(bLabel.frame), aField.frame.size.height);
    }
    
    aField.leftView=view;
    [view release];
}

+(UIImage*)getOriginImage:(NSString*)imageStr withInset:(UIEdgeInsets)insets
{
    UIImage* orgImg=[UIImage imageWithCGImage:[UIImage imageNamed:imageStr].CGImage scale:2.0 orientation:UIImageOrientationUp];
    if (orgImg && !UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
        [orgImg resizableImageWithCapInsets:insets];
    }
    
    return orgImg;
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
    [aTextField setBackground:[ApplicationPublic getOriginImage:@"new_baoanzixun_xialakuang.png" withInset:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [aTextField setBackgroundColor:[UIColor clearColor]];
    [aTextField setTextColor:[UIColor blackColor]];
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
