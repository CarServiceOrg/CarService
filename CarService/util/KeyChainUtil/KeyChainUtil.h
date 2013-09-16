//
//  KeyChainUtil.h
//  iGuanZhong
//
//  Created by zhouochengyu on 13-8-23.
//  Copyright (c) 2013年 zhouochengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainUtil : NSObject

+(void)save:(NSString *)service data:(id)data;
+(id)load:(NSString *)service;
+(void)delete:(NSString *)service;

@end
