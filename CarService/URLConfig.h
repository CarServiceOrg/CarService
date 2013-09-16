#import <Foundation/Foundation.h>

#define ORIGIN_URL @"124.207.24.90:2012"
#define DEFAULT_URL_Login @"https://61.50.159.196:2543" //登录前无密钥协商，登录接口采用HTTPS调用，保证数据安全,其他功能接口使用HTTP
#define DEFAULT_URL @"http://61.50.159.196:2501"
#define PICTURE_URL [NSString stringWithFormat:@"%@/Data/Images/IPhone/User/",DEFAULT_URL]

//************************************************************1.用户功能接口************************************************************
//1.1	用户登录  
#define URL_login [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL_Login]
#define URL_register [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL_Login]

//1.1.0 获取用户角色
#define URL_login_roles [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL]

//1.2	位置服务接口
//1.2.0
#define URL_Location [NSString stringWithFormat:@"%@/service/Location.json?",DEFAULT_URL]

//我的信息
#define URL_Message [NSString stringWithFormat:@"%@/service/Messages.json?",DEFAULT_URL]
////角色获取
//#define URL_Message [NSString stringWithFormat:@"%@/service/Messages.json?",DEFAULT_URL]


