//
//  CSAppDelegate.m
//  CarService
//
//  Created by Chao on 13-9-12.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSAppDelegate.h"
#import "BMapKit.h"
#import "CSFirstViewController.h"
#import "CSSecondViewController.h"
#import "CSThirdViewController.h"
#import "CSForthViewController.h"
#import "CSFifthViewController.h"
#import "LBSDataUtil.h"
#import "WeiboSDK.h"
#import "Util.h"

@interface CSAppDelegate ()<BMKGeneralDelegate, UITabBarControllerDelegate,WeiboSDKDelegate>{
    BMKMapManager* _mapManager;
    UITabBarController *_tabBarController;
    NSMutableArray* _imgViewArray;
}

@end

@implementation CSAppDelegate
#define baidu_AccessKey @"2400bd68cfae9cf2577f56760546145c"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{        
    //此为storyboard的局限，在Interface Builder时，在MainWindow.xib中可以链接view controllers到App Delegate的outlets，但是现在不可以，只能写代码设置第一个controller是什么，或者谁知道有什么办法请告知，谢谢。
    //_tabBarController = (UITabBarController *)self.window.rootViewController;
    //_tabBarController.delegate=self;
    //_tabBarController.tabBar.tintColor=[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    //初始化建立图片点击视图
    //[self init_imgViewArray];
    //默认先选中首页
    //[self updateSelectIndex:0];
    /*
    //share sdk
    [ShareSDK registerApp:@"1111d881143f"];
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"3201194191"
                               appSecret:@"0334252914651e8f76bad63337b3b78f"
                             redirectUri:@"http://www.baidu.com"];
    
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:@"801468113"
                                  appSecret:@"d56601877183db32015499e0ff9082a1"
                                redirectUri:@"http://www.baidu.com"];
    //添加豆瓣应用
    [ShareSDK connectDoubanWithAppKey:@"09e3405fc26bdca81da9c11f474395f8"
                            appSecret:@"ec4a3fc66073e6b4"
                          redirectUri:@"http://www.baidu.com"];
    
    //添加人人网应用
    [ShareSDK connectRenRenWithAppKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                            appSecret:@"f29df781abdd4f49beca5a2194676ca4"];
    */
    //在无网情况下启动 会耽误应用启动时间
    [LBSDataUtil shareUtil]; //开启定位
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = [[BMKMapManager alloc] init];
        // 如果要关注网络及授权验证事件，请设定 generalDelegate参数
        BOOL ret = [_mapManager start:baidu_AccessKey  generalDelegate:nil];
        if (!ret) {
            CustomLog(@"<<Chao-->CSAppDelegate-->didFinishLaunchingWithOptions-->manager start failed!");
        }
    });
    
    
    //新浪微博
    [WeiboSDK registerApp:@"3912808798"];
    [WeiboSDK enableDebugMode:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [WeiboSDK cancelPreviousPerformRequestsWithTarget:self];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 本地函数

-(UIImageView*)setUpImgView:(CGRect)frame withImgStr:(NSString*)imgPath withText:(NSString*)text
{
    UIImageView* imgView=[[UIImageView alloc] initWithFrame:frame];
    [imgView setBackgroundColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0]];
    //[imgView setImage:[[UIImage imageNamed:@"black_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    {
        UIImageView* indexView=[[UIImageView alloc] initWithFrame:imgView.bounds];
        [indexView setTag:10];
        [indexView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imgPath]]];
        [indexView setHighlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press.png",imgPath]]];
        [imgView addSubview:indexView];
        [indexView release];
    
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-25, frame.size.width, 25)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:12]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:text];
        [imgView addSubview:titleLabel];
        [titleLabel release];
    }
    return [imgView autorelease];
}

-(void)init_imgViewArray
{
    _imgViewArray=[[NSMutableArray alloc] initWithCapacity:5];
    {
        UIImageView* imgView=[self setUpImgView:CGRectMake(0, _tabBarController.tabBar.frame.size.height-110/2.0, 128/2.0, 110/2.0) withImgStr:@"tab_shouye" withText:@"首页"];
        [_imgViewArray addObject:imgView];
        [_tabBarController.tabBar addSubview:imgView];
    }
    {
        UIImageView* imgView=[self setUpImgView:CGRectMake(128/2.0*1, _tabBarController.tabBar.frame.size.height-110/2.0, 128/2.0, 110/2.0) withImgStr:@"tab_peccancy" withText:@"违章查询"];
        [_imgViewArray addObject:imgView];
        [_tabBarController.tabBar addSubview:imgView];
    }
    {
        UIImageView* imgView=[self setUpImgView:CGRectMake(128/2.0*2, _tabBarController.tabBar.frame.size.height-110/2.0, 128/2.0, 110/2.0) withImgStr:@"tab_servicecenter" withText:@"服务中心"];
        [_imgViewArray addObject:imgView];
        [_tabBarController.tabBar addSubview:imgView];
    }
    {
        UIImageView* imgView=[self setUpImgView:CGRectMake(128/2.0*3, _tabBarController.tabBar.frame.size.height-110/2.0, 128/2.0, 110/2.0) withImgStr:@"tab_membercenter" withText:@"会员中心"];
        [_imgViewArray addObject:imgView];
        [_tabBarController.tabBar addSubview:imgView];
    }
    {
        UIImageView* imgView=[self setUpImgView:CGRectMake(128/2.0*4, _tabBarController.tabBar.frame.size.height-110/2.0, 128/2.0, 110/2.0) withImgStr:@"tab_more" withText:@"更多"];
        [_imgViewArray addObject:imgView];
        [_tabBarController.tabBar addSubview:imgView];
    }
}

-(void)updateSelectIndex:(int)index
{
    for (UIImageView* imgView in _imgViewArray) {
        UIImageView* indexView=(UIImageView*)[imgView viewWithTag:10];
        if (indexView) {
            [indexView setHighlighted:NO];
        }
    }
    
    if (index<[_imgViewArray count]) {
        UIImageView* imageView=[_imgViewArray objectAtIndex:index];
        UIImageView* indexView=(UIImageView*)[imageView viewWithTag:10];
        if (indexView) {
            [indexView setHighlighted:YES];
        }
    }
}

#pragma mark UITabBarControllerDelegate
// called when a new view is selected by the user (but not programatically)
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //CustomLog(@"<<Chao-->CSAppDelegate-->BMKGeneralDelegate-->item %@",viewController);
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController* curCtrler=[[(UINavigationController*)viewController viewControllers] objectAtIndex:0];
        if ([curCtrler isKindOfClass:[CSFirstViewController class]]) {
            [self updateSelectIndex:0];
        }else if ([curCtrler isKindOfClass:[CSSecondViewController class]]) {
            [self updateSelectIndex:1];
        }else if ([curCtrler isKindOfClass:[CSThirdViewController class]]) {
            [self updateSelectIndex:2];
        }else if ([curCtrler isKindOfClass:[CSForthViewController class]]) {
            [self updateSelectIndex:3];
        }else if ([curCtrler isKindOfClass:[CSFifthViewController class]]) {
            [self updateSelectIndex:4];
        }
    }
}

#pragma mark BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError
{
    CustomLog(@"<<Chao-->CSAppDelegate-->BMKGeneralDelegate-->onGetNetworkState %d",iError);
}

- (void)onGetPermissionState:(int)iError
{
    CustomLog(@"<<Chao-->CSAppDelegate-->BMKGeneralDelegate-->onGetPermissionState %d",iError);
}

- (void)dealloc
{
    [_window release];
    [_mapManager release]; _mapManager=nil;
    [_imgViewArray release]; _imgViewArray=nil;
    [super dealloc];
}

//添加断点 输入：po [[UIWindow keyWindow] recursiveDescription]
#if TARGET_OS_IPHONE
#import <objc/runtime.h>
#import <objc/message.h>
#else
#import <objc/objc-class.h>
#endif

#ifdef DEBUG
void pspdf_swizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

static BOOL PSPDFIsVisibleView(UIView *view) {
    BOOL isViewHidden = view.isHidden || view.alpha == 0 || CGRectIsEmpty(view.frame);
    return !view || (PSPDFIsVisibleView(view.superview) && !isViewHidden);
}

// Following code patches UIView's description to show the classname of an an view controller, if one is attached.
// Will only get compiled for debugging. Use 'po [[UIWindow keyWindow] recursiveDescription]' to invoke.
__attribute__((constructor)) static void PSPDFKitImproveRecursiveDescription(void) {
    @autoreleasepool {
        SEL customViewDescriptionSEL = NSSelectorFromString(@"pspdf_customViewDescription");
        IMP customViewDescriptionIMP = imp_implementationWithBlock(^(id _self) {
            NSMutableString *description = [_self performSelector:customViewDescriptionSEL];
            SEL viewDelegateSEL = NSSelectorFromString([NSString stringWithFormat:@"%@ewDelegate", @"_vi"]); // pr. API
            if ([_self respondsToSelector:viewDelegateSEL]) {
                UIViewController *viewController = [_self performSelector:viewDelegateSEL];
                NSString *viewControllerClassName = NSStringFromClass([viewController class]);
                
                if ([viewControllerClassName length]) {
                    NSString *children = @""; // iterate over childViewControllers
                    
                    if ([viewController respondsToSelector:@selector(childViewControllers)] && [viewController.childViewControllers count]) {
                        NSString *origDescription = description;
                        description = [NSMutableString stringWithFormat:@"%d child[", [viewController.childViewControllers count]];
                        for (UIViewController *childViewController in viewController.childViewControllers) {
                            [description appendFormat:@"%@:%p ", NSStringFromClass([childViewController class]), childViewController];
                        }
                        [description appendFormat:@"] %@", origDescription];
                    }
                    
                    // check if the frame of a childViewController is bigger than the one of a parentViewController. (usually this is a bug)
                    NSString *warnString = @"";
                    if (viewController && viewController.parentViewController && [viewController isViewLoaded] && [viewController.parentViewController isViewLoaded]) {
                        CGRect parentRect = viewController.parentViewController.view.bounds;
                        CGRect childRect = viewController.view.frame;
                        
                        if (parentRect.size.width < childRect.origin.x + childRect.size.width ||
                            parentRect.size.height < childRect.origin.y + childRect.size.height) {
                            warnString = @"* OVERLAP! ";
                        }else if(CGRectIsEmpty(childRect)) {
                            warnString = @"* ZERORECT! " ;
                        }
                    }
                    description = [NSMutableString stringWithFormat:@"%@'%@:%p'%@ %@", warnString, viewControllerClassName, viewController, children, description];
                }
            }
            
            // add marker if view is hidden.
            if (!PSPDFIsVisibleView(_self)) {
                description = [NSMutableString stringWithFormat:@"XX (%@)", description];
            }
            
            return description;
        });
        class_addMethod([UIView class], customViewDescriptionSEL, customViewDescriptionIMP, "@@:");
        pspdf_swizzle([UIView class], @selector(description), customViewDescriptionSEL);
    }
}
#endif

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark -WeiboSdkDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ( [response isKindOfClass: [ WBSendMessageToWeiboResponse class ] ] )
    {
        NSString *strMsg = [ NSString stringWithFormat:@"发送结果代码:%d", response.statusCode];
        CustomLog(@"message:%@",strMsg);
        [[NSNotificationCenter defaultCenter] postNotificationName:SinaWeiboShareResultNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:response.statusCode],@"statusCode", nil]];
    }
}

@end
