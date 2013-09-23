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


@end
