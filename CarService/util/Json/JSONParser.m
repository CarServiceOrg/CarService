//
//  JSONParser.m
//  HZiPadReader
//
//  Created by starinno-005 on 11-3-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSONParser.h"
#import "JSON.h"

@implementation JSONParser


+(NSArray *)parserUrlData:(NSString *)URLString isAllValues:(BOOL)isAllValues  valueForKey:(NSString *)valueForKey
{
	NSData *ndMain = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:URLString]];
	NSString *strData = [[NSString alloc] initWithData:ndMain encoding:NSUTF8StringEncoding]; 	
	
	//这里是返回的数据
	NSArray *arrInfo=[NSArray array];
	if ([strData length] != 0) {		
		//直接用json库的[NSString JSONValue]方法
		if (isAllValues) {
			arrInfo =[[strData JSONValue] allValues];
		}else {
			arrInfo =[[strData JSONValue] valueForKey:valueForKey];
		}
	}
	[ndMain release];
	[strData release]; 
	
	return arrInfo;
}

+(id)parserData:(NSData *)ndMain isAllValues:(BOOL)isAllValues  valueForKey:(NSString *)valueForKey
{
	if (ndMain==nil || [ndMain isEqual:[NSNull null]]) {
		return nil;
	}
	NSString *strData = [[NSString alloc] initWithData:ndMain encoding:NSUTF8StringEncoding]; 		
	//这里是返回的数据
	//NSLog(@"<<JSONParser.m-->parserData-->strData:%@",strData);
	id value = nil;
	if ([strData length]!=0) {
		if (isAllValues) {
			value = [strData JSONValue];
		}
		else {
			value = [[strData JSONValue] valueForKey:valueForKey];
		}
	}
	[strData release];
	return value;
}

@end
