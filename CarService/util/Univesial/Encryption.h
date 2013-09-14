//
//  Encryption.h
//  MtsApi
//
//  Created by jiangfayou on 12-9-17.
//  Copyright (c) 2012年 jiangfayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
//- (NSString*)base64encode:(NSString*)str;           //同上64编码
- (NSData*)base64Decode:(NSString*)str;

@end