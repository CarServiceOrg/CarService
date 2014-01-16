//
//  MyPicker.m
//  PickerSkinTest
//
//  Created by Wang WenHui on 10-5-3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyPicker.h"
#import <QuartzCore/QuartzCore.h> //layer you need this import

@implementation MyPicker


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
    }
    return self;
}

//子视图中
//4-选择区域的背景颜色; 0-大背景的颜色; 1-选择框左边的颜色; 2-? ;3-?; 5-滚动区域的颜色 回覆盖数据
//6-选择框的背景颜色 7-选择框左边的颜色 8-整个View的颜色 会覆盖所有的图片
- (void)drawRect:(CGRect)rect {
//    //图片覆盖边界
//	UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    NSLog(@"<<Chao-->MyPicker-->drawRect-->self.frame:%@",NSStringFromCGRect(self.frame));
//	//img.image = [UIImage imageNamed:@"yejichaxun_beijingkuang1.png"];
//    [img setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.8]];
//	[self addSubview:img];
//	[img release];

//    //图片替换选择框
//	UIView *subViewInPicker = [[self subviews] objectAtIndex:6];
//	[subViewInPicker setBackgroundColor:[UIColor colorWithRed:136/255.0 green:177/255.0 blue:213/255.0 alpha:0.5]];
//	UIImageView *bgimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhengjianxinxiluru_katuo.png"]];
//	bgimg.frame = CGRectMake(-5, -3, 320, 55);
//	[subViewInPicker addSubview:bgimg];
//	[bgimg release];
	
	//4-选择区域的背景颜色; 0-大背景的颜色; 1-选择框左边的颜色; 2-? ;3-?; 5-滚动区域的颜色 回覆盖数据
	//6-选择框的背景颜色 7-选择框左边的颜色 8-整个View的颜色 会覆盖所有的图片
    if (IsIOS6OrLower) {
        UIView *subViewInPicker = [[self subviews] objectAtIndex:4];
        [subViewInPicker setBackgroundColor:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]];
    }else{
        
    }
    
    //layer覆盖选择框
    CGFloat color[4] = {203/255.0, 203/255.0, 203/255.0, 1};
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGColorRef layerBounderColor = CGColorCreate(rgb, color);
    CGColorSpaceRelease(rgb);
    CALayer *viewLayer = self.layer;
    [viewLayer setBounds:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [viewLayer setBackgroundColor:layerBounderColor];
    [viewLayer setContentsRect:CGRectMake(0, 0, 1.0, 1.0)];
    [viewLayer setBorderWidth:15];
    [viewLayer setBorderColor:layerBounderColor];
    CGColorRelease(layerBounderColor);
	
	[self setNeedsDisplay];
}


- (void)dealloc {
    [super dealloc];
}


@end
