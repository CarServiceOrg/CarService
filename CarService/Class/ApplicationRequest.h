//
//  ApplicationRequest.h
//  CarService
//
//  Created by baidu on 13-9-21.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationRequest : NSObject
{
    
}

//获取代维服务地址列表
+(void)startHttpRequest_delegateAddress:(NSMutableArray*)dataAry;

@end
