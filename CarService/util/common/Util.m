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

@interface ToDoItem : NSObject

@property (nonatomic,assign) NSInteger day;
@property (nonatomic,assign) NSInteger month;
@property (nonatomic,assign) NSInteger year;
@property (nonatomic,assign) NSInteger hour;
@property (nonatomic,assign) NSInteger minute;
@property (nonatomic,assign) NSInteger second;
@property (nonatomic,retain) NSString *action;
@property (nonatomic,retain) NSString *body;

@end

@implementation ToDoItem
@synthesize day;
@synthesize month;
@synthesize year;
@synthesize minute;
@synthesize hour;
@synthesize second;
@synthesize action;
@synthesize body;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.day = 0;
        self.month = 0;
        self.year = 0;
        self.minute = 0;
        self.hour = 0;
        self.second = 0;
        self.action = nil;
        self.body = nil;
    }
    return self;
}

- (void)dealloc
{
    [action release];
    [body release];
    [super dealloc];
}

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

- (void)scheduleLocalNotification
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    //test
    NSTimeInterval testinterval = [[NSDate date] timeIntervalSince1970] + 20 ;
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:testinterval];
    NSDateComponents *comps11  = [calendar components:unitFlags fromDate:testDate];
    ToDoItem *item = [[[ToDoItem alloc] init] autorelease];
    item.year = [comps11 year];
    item.month = [comps11 month];
    item.day = [comps11 day];
    item.hour = [comps11 hour];
    item.minute = [comps11 minute];
    item.second = [comps11 second];
    item.body = @"测试local通知^_^";
    [self scheduleNotificationWithItem:item];
    return;
    
    NSString *birthday = [self.userInfo objectForKey:@"birthday"];
    if (birthday.length > 0)
    {
        //NSDate *birthDay = [formatter dateFromString:birthday];
        NSTimeInterval timeInterval = [birthday intValue];
        NSDate *birthDay = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        if (nil != birthDay)
        {
            NSDateComponents *comps  = [calendar components:unitFlags fromDate:birthDay];
            ToDoItem *item = [[[ToDoItem alloc] init] autorelease];
            item.year = [comps year];
            item.month = [comps month];
            item.day = [comps day];
            item.body = @"尊敬的用户，这个月您就要生日了^_^";
            [self scheduleNotificationWithItem:item];
            
            ToDoItem *item1 = [[[ToDoItem alloc] init] autorelease];
            item1.year = [comps year];
            item1.month = [comps month];
            item1.day = [comps day];
            item1.body = @"尊敬的用户，今天是您的生日，祝您生日快乐";
            [self scheduleNotificationWithItem:item1];
        }
        
    }
    
    NSString *dateString = [self.userInfo objectForKey:@"drivecard_exp"];
    NSDate *theDate;
    NSDateComponents *comps;
    if (dateString.length > 0)
    {
        NSTimeInterval timeInterval = [dateString intValue];
        theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        //theDate = [formatter dateFromString:dateString];
        if (nil != theDate)
        {
            comps  = [calendar components:unitFlags fromDate:theDate];
            ToDoItem *item = [[[ToDoItem alloc] init] autorelease];
            item.year = [comps year];
            item.month = [comps month] - 1;
            item.day = [comps day];
            item.body = @"尊敬的用户，这个月您的驾驶证马上要到期，记得审本";
            [self scheduleNotificationWithItem:item];
        }
        
    }
    
    dateString = [self.userInfo objectForKey:@"secure_exp"];
    if (dateString.length > 0)
    {
        NSTimeInterval timeInterval = [dateString intValue];
        theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        //theDate = [formatter dateFromString:dateString];
        if (nil != theDate)
        {
            NSTimeInterval newInterval = [theDate timeIntervalSince1970] - 45 * 24 * 60 *60;
            theDate = [NSDate dateWithTimeIntervalSince1970:newInterval];
            comps  = [calendar components:unitFlags fromDate:theDate];
            ToDoItem *item = [[[ToDoItem alloc] init] autorelease];
            item.year = [comps year];
            item.month = [comps month] - 1;
            item.day = [comps day];
            item.body = @"尊敬的用户，这个保险即将到期";
            [self scheduleNotificationWithItem:item];
        }
        
    }
    
    dateString = [self.userInfo objectForKey:@"last_repair_time"];
    if (dateString.length > 0)
    {
        //theDate = [formatter dateFromString:dateString];
        NSTimeInterval timeInterval = [dateString intValue];
        theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        if (nil != theDate)
        {
            NSTimeInterval newInterval = [theDate timeIntervalSince1970] + 75 * 24 * 60 *60;
            theDate = [NSDate dateWithTimeIntervalSince1970:newInterval];
            comps  = [calendar components:unitFlags fromDate:theDate];
            ToDoItem *item = [[[ToDoItem alloc] init] autorelease];
            item.year = [comps year];
            item.month = [comps month] - 1;
            item.day = [comps day];
            item.body = @"尊敬的用户，您距离上次保养车辆已经很长时间了";
            [self scheduleNotificationWithItem:item];
        }
        
    }
    
    dateString = [self.userInfo objectForKey:@"next_repair_time"];
    if (dateString.length > 0)
    {
        //theDate = [formatter dateFromString:dateString];
        NSTimeInterval timeInterval = [dateString intValue];
        theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        if (nil != theDate)
        {
            NSTimeInterval newInterval = [theDate timeIntervalSince1970] - 45 * 24 * 60 *60;
            theDate = [NSDate dateWithTimeIntervalSince1970:newInterval];
            comps  = [calendar components:unitFlags fromDate:theDate];
            ToDoItem *item = [[[ToDoItem alloc] init] autorelease];
            item.year = [comps year];
            item.month = [comps month] - 1;
            item.day = [comps day];
            item.body = @"尊敬的用户，您的验车期限即将到期";
            [self scheduleNotificationWithItem:item];
        }
        
    }
    [formatter release];
}

- (void)unscheduleLoaclNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)scheduleNotificationWithItem:(ToDoItem *)item
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:item.day];
    [dateComps setMonth:item.month];
    [dateComps setYear:item.year];
    [dateComps setHour:item.hour];
    [dateComps setMinute:item.minute];
    [dateComps setSecond:item.second];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = item.body;
    localNotif.alertAction = item.action;
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

- (void)logout
{
    self.userInfo = nil;
    [self unscheduleLoaclNotification];
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

-(BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
