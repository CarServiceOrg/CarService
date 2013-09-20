#import <Foundation/Foundation.h>

//************************************************************电话号码************************************************************

#define TELEPHONE_BaoFeiYuSuan @"100086"  //电话：服务中心--车辆保险--保费预算
#define TELEPHONE_BaoXianZiXun @"100086"  //电话：服务中心--车辆保险--保险咨询

//*******************************************************************************************************************************

#define ORIGIN_URL @"124.207.24.90:2012"
#define DEFAULT_URL_Login @"https://61.50.159.196:2543" //登录前无密钥协商，登录接口采用HTTPS调用，保证数据安全,其他功能接口使用HTTP
#define DEFAULT_URL @"http://61.50.159.196:2501"
#define PICTURE_URL [NSString stringWithFormat:@"%@/Data/Images/IPhone/User/",DEFAULT_URL]
#define ServerAddress @"http://ceshi.idcdns.cn/car/interface/interface.php"
//************************************************************1.用户功能接口************************************************************
//1.1	用户登录  
#define URL_login [NSString stringWithFormat:@"http://sslk.bjjtgl.gov.cn/jgjwwcx/wzcx/wzcx_preview.jsp"]
#define URL_logout [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL_Login]
#define URL_changepassword [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL_Login]
#define URL_myconsumerecord [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL_Login]
#define URL_changeprofile [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL_Login]
#define URL_comment [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL_Login]
#define URL_feedback [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL_Login]
#define URL_checknewversion [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL_Login]
#define URL_rateurl @"pinglun"

//1.1.0 获取用户角色
#define URL_login_roles [NSString stringWithFormat:@"%@/service/Authenticate.json?",DEFAULT_URL]

//1.2	位置服务接口
//1.2.0
#define URL_Location [NSString stringWithFormat:@"%@/service/Location.json?",DEFAULT_URL]

//我的信息
#define URL_Message [NSString stringWithFormat:@"%@/service/Messages.json?",DEFAULT_URL]
////角色获取
//#define URL_Message [NSString stringWithFormat:@"%@/service/Messages.json?",DEFAULT_URL]


//************************************************************2.接口************************************************************
//今日限行
#define URL_TrafficControls [NSString stringWithFormat:@"%@?json={\"action\":\"raffic\"}",ServerAddress]