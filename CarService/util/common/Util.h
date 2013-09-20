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
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)theDel;
- (void)showConfirmAlertWithTitle:(NSString *)title message:(NSString *) message tag:(NSUInteger)alertTag delegate:(id<UIAlertViewDelegate>)theDel;
- (int)countStarNum:(NSString *)rateStr base:(int)baseNum;
- (void)showCookieInfo;
- (void)clearCookieInfo;
-(NSString *)get_appVersion;

- (BOOL)hasLogin;
- (void)logout;
- (NSDictionary *)getUserInfo;
- (void)setLoginUserInfo:(NSDictionary *)userDic;

@end
