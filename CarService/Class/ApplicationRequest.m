//
//  ApplicationRequest.m
//  CarService
//
//  Created by baidu on 13-9-21.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "ApplicationRequest.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"

@implementation ApplicationRequest
#define ApplicationRequest_delegateAddress @"delegateAddress"

//获取代维服务地址列表
+(void)startHttpRequest_delegateAddress:(NSMutableArray*)dataAry
{
    __block NSMutableArray* array=dataAry;
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"shop_address", @"action", nil];
    NSString *jsonArg = [[argDic JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr =[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg];
    CustomLog(@"<<Chao-->ApplicationRequest-->startHttpRequest_delegateAddress-->urlStr:%@",urlStr);
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *testResponseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding] autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        CustomLog(@"<<Chao-->ApplicationRequest-->startHttpRequest_delegateAddress-->testResponseString:%@",testResponseString);
        
        NSDictionary *requestDic =[[request responseString] JSONValue];
        CustomLog(@"<<Chao-->ApplicationRequest-->startHttpRequest_delegateAddress-->requestDic:%@",requestDic);
        if ([requestDic objectForKey:@"status"]) {
            if ([[requestDic objectForKey:@"status"] intValue]==1) {
                [array removeAllObjects];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:ApplicationRequest_delegateAddress]) {
                    [array addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:ApplicationRequest_delegateAddress]];
                }
            }else if ([[requestDic objectForKey:@"status"] intValue]==0){
                if ([requestDic objectForKey:@"list"]) {
                    [array removeAllObjects];
                    [array addObjectsFromArray:[requestDic objectForKey:@"list"]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:array forKey:ApplicationRequest_delegateAddress];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    CustomLog(@"<<Chao-->ApplicationRequest-->startHttpRequest_delegateAddress-->array:%@",array);
                }
            }
        }
    }];
    [request setFailedBlock:^{
        [array removeAllObjects];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:ApplicationRequest_delegateAddress]) {
            [array addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:ApplicationRequest_delegateAddress]];
        }
    }];
    [request startSynchronous];
}

@end
