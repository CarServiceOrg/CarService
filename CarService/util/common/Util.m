//
//  Util.m
//  iGuanZhong
//
//  Created by  on 13-8-4.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import "Util.h"
#import "URLConfig.h"

@interface Util ()

@property (nonatomic,retain) NSDictionary *userInfo;

@end

@implementation Util
@synthesize userInfo;

+ (Util *)sharedUtil
{
    static Util *util = nil;
    if (nil == util) 
    {
        util = [[Util alloc] init];
        util.userInfo = nil;
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

- (void)dealloc
{
    self.userInfo = nil;
    [super dealloc];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{

    BlockAlertView *alert = [BlockAlertView alertWithTitle:title message:message];
    [alert setCancelButtonWithTitle:@"确定" block:nil];
    [alert show];
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

- (NSHTTPCookie *)getCookie:(NSString *)cookieName
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray)
    {
        CustomLog(@"cookie:%@",obj);
        if ([obj isKindOfClass:[NSHTTPCookie class]])
        {
            NSHTTPCookie *tempCookie = (NSHTTPCookie *)obj;
            if ([[[tempCookie properties] objectForKey:@"name"] isEqualToString:cookieName])
            {
                return tempCookie;
            }
        }
    }
    return nil;
}

- (void)setCookie:(NSHTTPCookie *)theCookie
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:theCookie];
}

-(NSString *)get_appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (BOOL)hasLogin
{
    return (nil != self.userInfo);
}

- (void)logout
{
    self.userInfo = nil;
}

- (NSDictionary *)getUserInfo
{
    return self.userInfo;
}

- (void)setLoginUserInfo:(NSDictionary *)userDic
{
    self.userInfo = userDic;
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
/**
  * 手机号码
  * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
  * 联通：130,131,132,152,155,156,185,186
  * 电信：133,1349,153,180,189
  */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        ||([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
