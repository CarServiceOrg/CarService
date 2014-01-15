//
//  Constants.h
//  CarService
//
//  Created by baidu on 13-9-15.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#ifndef CarService_Constants_h
#define CarService_Constants_h

#define UserDefaultUserInfo @"UserDefaultUserInfo"
#define LoginSuccessNotification @"LoginSuccessNotification"
#define LogoutSuccessNotification @"LogoutSuccessNotification"
#define LocationSuccessNotification @"LocationSuccessNotification"

#define SinaWeiboShareResultNotification  @"SinaWeiboShareResultNotification"
#define RateOrderNotification @"RateOrderNotification"

#define DeviceDiffHeight 88 //(568 - 480)
#define kRedirectURI @"http://www.sina.com.cn"
#define kAppKey @"3912808798"

//车辆管理相关
#define CSAddCarViewController_carList  @"Carservice_CarList"  //存储文件中 存储车辆列表对应的键
#define CSAddCarViewController_carSign  @"carSign"  //存储文件中 车牌号对应的键
#define CSAddCarViewController_carStand @"carStand"  //存储文件中 车架号对应的键
#define CSAddCarViewController_carDate  @"carDate"  //存储文件中 车辆初次登记日期 对应的键

typedef enum
{
    LocationErrorCode_UserDenied = 0,
    LocationErrorCode_OtherReason,
    LocationErrorCode_NoError
}LocationErrorCode;

#endif
