//
//  main.m
//  CarService
//
//  Created by Chao on 13-9-12.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [[NSUserDefaults standardUserDefaults] setObject: [NSArray arrayWithObjects:@"zh_CN", nil] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([CSAppDelegate class]));
    }
}
