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
#define SinaWeiboShareResultNotification  @"SinaWeiboShareResultNotification"

#define DeviceDiffHeight 88 //(568 - 480)
#define kRedirectURI @"http://www.sina.com.cn"
#define kAppKey @"3912808798"

typedef enum
{
    LocationErrorCode_UserDenied = 0,
    LocationErrorCode_OtherReason,
    LocationErrorCode_NoError
}LocationErrorCode;

#endif
