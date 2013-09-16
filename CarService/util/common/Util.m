//
//  Util.m
//  iGuanZhong
//
//  Created by  on 13-8-4.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "Util.h"
#import "URLConfig.h"

@implementation Util

+ (Util *)sharedUtil
{
    static Util *util = nil;
    if (nil == util) 
    {
        util = [[Util alloc] init];
    }
    return util;
}

+(NSComparisonResult) compareOSVersion:(CGFloat) osVersion
{
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
	CGFloat deviceOSVersion = [version floatValue];
    
    
    if (deviceOSVersion == osVersion) {
        return NSOrderedSame;
    }
    else if (deviceOSVersion > osVersion){
        return NSOrderedAscending;
    }
    return NSOrderedDescending;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release]; 
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)theDel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:theDel cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)showConfirmAlertWithTitle:(NSString *)title message:(NSString *) message tag:(NSUInteger)alertTag delegate:(id<UIAlertViewDelegate>)theDel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:theDel cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil, nil];
    alert.tag = alertTag;
    [alert show];
    [alert release];
}

- (int)countStarNum:(NSString *)rateStr base:(int)baseNum
{
    if ([rateStr floatValue] == 0.0)
    {
        return 0;
    }
    
    int starNum = (int)([rateStr floatValue] / (baseNum / 5));
    if (starNum <= 0)
    {
        starNum = 1;
    }
    if (starNum > 5)
    {
        starNum = 5;
    }
    return starNum;
}

- (void)showCookieInfo
{
    //打印cookie
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray)
    {
        CustomLog(@"cookie:%@",obj);
    }
}

- (void)clearCookieInfo
{
    //清空cookie
    CustomLog(@"clear cookie info");
    /*NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray)
    {
        if ([obj isKindOfClass:[NSHTTPCookie class]] && [[(NSHTTPCookie *)obj domain] isEqualToString:CookieDomain])
        {
            [cookieJar deleteCookie:obj];
        }
        else
        {
            CustomLog(@"other cookie ,do nothing");
        }
    }*/
}

-(NSString *)get_appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
