//
//  Toast.m
//  iToastDemo
//
//  Created by amao on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Toast.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kToastTextPadding     = 15;
const CGFloat kToastButtonPaddding  = 20;
const CGFloat kToastLabelWidth      = 280;
const CGFloat kToastLabelHeight     = 60;
const CGFloat kToastMargin          = 45;
const CGFloat kToastXOffset         = 95;

@implementation Toast

@synthesize toastPosition;
@synthesize toastDuration;
@synthesize toastText;
@synthesize toastView;

- (id)init{
    if (self = [super init]){
        toastPosition = kToastPositionCenter;
        toastDuration = kToastDurationShort;
    }
    return self;
}

- (id)initWithText:(NSString *)text{
    if (self = [super init]){
        toastPosition = kToastPositionCenter;
        toastDuration = kToastDurationShort;
        self.toastText= text;
    }
    return self;
}

//设置显示文字的toastView 这里是button 显示文字的label的tag为1；
-(void)setSelfView{
	//根据字体和文字计算大小
	UIFont *font   = [UIFont systemFontOfSize:16];
    CGSize textSize= [toastText sizeWithFont:font constrainedToSize:CGSizeMake(kToastLabelWidth, kToastLabelHeight)];

    UIButton *button = [[UIButton alloc] init];
	button.bounds = CGRectMake(0, 0, textSize.width+2*kToastButtonPaddding, textSize.height+2*kToastButtonPaddding);
	button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	button.layer.cornerRadius = 5;
	
	//添加显示文字的label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width+2*kToastTextPadding, textSize.height+2*kToastTextPadding)];
	label.tag=1;
	label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = toastText;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
	label.shadowOffset = CGSizeMake(1, 1);
    label.textAlignment = UITextAlignmentCenter;	
	label.center = CGPointMake(button.bounds.size.width / 2, button.bounds.size.height / 2);
	[button addSubview:label];
    [label release];

	//设置button的位置
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    CGPoint point = window.center;
    CGPoint center = window.center;
    CGFloat dx = 0;
    if (toastPosition == kToastPositionTop) {
        point = CGPointMake(point.x, kToastMargin + button.bounds.size.height);
        dx    = center.x - kToastXOffset;
    }else if(toastPosition == kToastPositionBottom){
        point = CGPointMake(point.x, window.bounds.size.height - kToastMargin - button.bounds.size.height);
        dx    = kToastXOffset - center.x ;
    }
    button.center = point;
    //根据横竖屏进行控制
    UIInterfaceOrientation currentOrient= [UIApplication sharedApplication].statusBarOrientation;
    if(currentOrient == UIDeviceOrientationLandscapeRight){
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation((M_PI/2) * -1);
        CGAffineTransform translateTransform= CGAffineTransformMakeTranslation(-dx,center.y - point.y);
        CGAffineTransform t = CGAffineTransformConcat(rotateTransform,translateTransform);
        button.transform = CGAffineTransformConcat(button.transform, t);
    }else if(currentOrient == UIDeviceOrientationLandscapeLeft){
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation((M_PI/2));
        CGAffineTransform translateTransform= CGAffineTransformMakeTranslation(dx,center.y - point.y);
        CGAffineTransform t = CGAffineTransformConcat(rotateTransform,translateTransform);
        button.transform = CGAffineTransformConcat(button.transform, t);
    }else if(currentOrient == UIDeviceOrientationPortraitUpsideDown){
        button.transform = CGAffineTransformRotate(button.transform, M_PI);
    }
	[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:button];
	self.toastView = button;
	[button release];
}

//点击事件
- (void)buttonClicked:(id)sender{
    [self doHideToast];
}

//显示toast
- (void)showToast{
	if (self.toastView==nil) {
		[self setSelfView];
	}else {
		UIFont *font = [UIFont systemFontOfSize:16];
		CGSize textSize= [toastText sizeWithFont:font constrainedToSize:CGSizeMake(kToastLabelWidth, kToastLabelHeight)];
		self.toastView.bounds = CGRectMake(0, 0, textSize.width + 2 * kToastButtonPaddding, textSize.height + 2 * kToastButtonPaddding);
		UILabel* textLabel=(UILabel*)[self.toastView viewWithTag:1];
		if (textLabel) {
			textLabel.frame=CGRectMake(0, 0, textSize.width + 2 * kToastTextPadding, textSize.height + 2 * kToastTextPadding);
			textLabel.center = CGPointMake(self.toastView.bounds.size.width / 2, self.toastView.bounds.size.height / 2);
			textLabel.text=self.toastText;
		}
		[UIView beginAnimations:nil context:nil];
		toastView.alpha = 1.0;
		[UIView commitAnimations];
	}
    
	//启动定时器进行隐藏
    NSTimer *timer = [NSTimer timerWithTimeInterval:(CGFloat)toastDuration / 1000.0 
                                              target:self selector:@selector(onHideToast:) 
                                            userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

//定时器调用函数
- (void)onHideToast:(NSTimer *)timer{
    [self doHideToast];
}

//动画隐藏视图
- (void)doHideToast{
    [UIView beginAnimations:nil context:nil];
	toastView.alpha = 0;
	[UIView commitAnimations];
}

- (void)dealloc{
	//NSLog(@"<<Chao-->Toast-->dealloc-->开始释放内存");
	if (toastView) {
		//NSLog(@"<<Chao-->Toast-->dealloc-->[toastView retainCount]:%d",[toastView retainCount]);
		if ([toastView retainCount]>1) {
			[toastView removeFromSuperview];
		}
		self.toastView=nil;
	}
	if (toastText) {
		[toastText release];
	}
    [super dealloc];
}

@end
