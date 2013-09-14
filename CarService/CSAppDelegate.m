//
//  CSAppDelegate.m
//  CarService
//
//  Created by Chao on 13-9-12.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSAppDelegate.h"

@implementation CSAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定 generalDelegate参数
    BOOL ret = [_mapManager start:@"394bd9ecb346c4564c08d3ec4375041d"  generalDelegate:self];
    if (!ret) {
        NSLog(@"<<Chao-->CSAppDelegate-->didFinishLaunchingWithOptions-->manager start failed!");
    }
    
    // Override point for customization after application launch.
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError
{
    NSLog(@"<<Chao-->CSAppDelegate-->BMKGeneralDelegate-->onGetNetworkState %d",iError);
}

- (void)onGetPermissionState:(int)iError
{
    NSLog(@"<<Chao-->CSAppDelegate-->BMKGeneralDelegate-->onGetPermissionState %d",iError);
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

@end
