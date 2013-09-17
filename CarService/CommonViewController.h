//
//  CommonViewController.h
//  iGuanZhong
//
//  Created by zhouochengyu on 13-7-22.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "URLConfig.h"
#import "NSString+SBJSON.h"
#import "Util.h"

@interface CommonViewController : UIViewController

- (void)showActView:(UIActivityIndicatorViewStyle)style;
- (void)hideActView;
//- (void)addImageDownOperation:(ImageDownloadOperation *)operation;
//- (void)showDetailController:(NSDictionary *)actInfo;
- (void)showFullActView:(UIActivityIndicatorViewStyle)style;
- (void)hideFullActView;
- (UIBarButtonItem *)getBackItem;

@end
