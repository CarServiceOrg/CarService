//
//  MD5Degist.m
//  ZC
//
//  Created by yang yangfan on 10-8-2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>

#import "MD5Digest.h"


@implementation MD5Digest
+(NSString *)md5:(NSString *)str {
	const char *cStr = [str UTF8String];	
	unsigned char result[16];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",			
			result[0], result[1], result[2], result[3], 			
			result[4], result[5], result[6], result[7],			
			result[8], result[9], result[10], result[11],			
			result[12], result[13], result[14], result[15]			
			]; 
	
}


//	URL Encode NSString in Objective-C 
//	如果提交的URL中含有中文或空格之类的特殊字符，IOS不能正确识别，类似于以下例子：NSString *sUrl = @”http://www.baidu.com/s?wd=易网联信“; 
//最后的解决办法是使用kCFStringEncodingUTF8编码字符串,这个方法可以直接用来转换含有中文的字符串，然后作为url进行使用，问题解。
//sUrl = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)sUrl, nil, nil, kCFStringEncodingUTF8);
//最后打印的日志为：url = http://www.baidu.com/s?wd=%D2%D7%CD%F8%C1%AA%D0%C5
+(NSString *)urlencode:(NSString *)cStr {
	return [cStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
} 

//良子提供的URL加密方式 对于URL含有中文的情况加密后返回的数值不正确
//+(NSString *)urlencode:(NSString *)cStr withLen:(int)len {
//
//	const char *s = [cStr UTF8String];	
//	char const *from, *end;
//	char *start, *to; 
//	from = s; 
//	end = s + len; 
//	start = to = (char *) malloc(3 * len + 1); 	
//	char hexchars[] = "0123456789ABCDEF"; 
//	
//	while (from < end) { 
//		char c = *from++; 
//		
//		if (c == ' ') { 
//			*to++ = '+'; 
//		} else if ( isalnum(c) ) {
//			*to++ = c;
//		} else { 
//			to[0] = '%'; 
//			to[1] = hexchars[(c>>4)&15]; 
//			to[2] = hexchars[c&15]; 
//			to += 3; 
//		} 
//	} 
//	*to = 0; 
//	NSString* str = [[[NSString alloc] initWithFormat:@"%s",(char*)start] autorelease];
//	free(start);
//	return str;
//} 


@end
