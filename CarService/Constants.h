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

#define DeviceDiffHeight 88 //(568 - 480)


typedef enum
{
    LocationErrorCode_UserDenied = 0,
    LocationErrorCode_OtherReason,
    LocationErrorCode_NoError
}LocationErrorCode;

#endif
