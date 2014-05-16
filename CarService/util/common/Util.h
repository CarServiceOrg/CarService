//
//  Util.h
//  iGuanZhong
//
//  Created by  on 13-8-4.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (Util *)sharedUtil;
+(NSComparisonResult) compareOSVersion:(CGFloat) osVersion;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (int)countStarNum:(NSString *)rateStr base:(int)baseNum;

- (void)showCookieInfo;
- (void)clearCookieInfo;
- (NSHTTPCookie *)getCookie:(NSString *)cookieName;
- (void)setCookie:(NSHTTPCookie *)theCookie;

-(NSString *)get_appVersion;

- (void)scheduleLocalNotification;
- (void)unscheduleLoaclNotification;
- (BOOL)hasLogin;
- (void)autoLogin;
- (void)logout;
- (NSDictionary *)getUserInfo;
- (void)setLoginUserInfo:(NSDictionary *)userDic shouldUseDiskCache:(BOOL)useCache;
- (void)updateUserInfo:(NSDictionary *)userDic;
- (BOOL)isMobileNumber:(NSString *)mobileNum;
- (BOOL)isValidEmail:(NSString *)email;

@end
