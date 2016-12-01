//
//  ENDE.m
//  XSF
//
//  Created by duck on 15/7/15.
//  Copyright (c) 2015年 dom.duck. All rights reserved.
//

#import "ENDE.h"
#import "CommonCrypto/CommonDigest.h"
#import "GTMBase64.h"

#include <CommonCrypto/CommonCryptor.h>

//公用key
#define APP_KEY8_PUBLIC @"bx#x@iwH"
#define APP_KEY20_PUBLIC @"me-S%F$xYq(2d%5l9mHY"

//登录 加密解密key
#define APP_KEY8_LOGIN @""
#define APP_KEY20_LOGIN @""



@implementation ENDE

+ (NSString *)md5:(NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}


#pragma mark -- 得到key 8位
+ (NSString *)getEightKey:(NSString *) temp
{
    NSString *key = @"";
    
    if ([temp isEqualToString:@"APP_KEY8_PUBLIC"]) {
        key = APP_KEY8_PUBLIC;
    }else if([temp isEqualToString:@"APP_KEY8_LOGIN"]){
        key = APP_KEY8_LOGIN;
    }else{
        key = APP_KEY8_PUBLIC;
        NSLog(@"未找到key:%@,将使用公用8位key",temp);
    }
    
    return key;
}


+ (NSString *)getTwentyKey:(NSString *) temp
{
    NSString *key = @"";
    
    if ([temp isEqualToString:@"APP_KEY20_PUBLIC"]) {
        key = APP_KEY20_PUBLIC;
    }else if([temp isEqualToString:@"APP_KEY20_LOGIN"]){
        key = APP_KEY20_LOGIN;
    }else{
        key = APP_KEY20_PUBLIC;
        NSLog(@"未找到key:%@,将使用公用20位key",temp);
    }
    
    return key;
}

#pragma mark -- 创建token
+ (NSString *)createToken:(NSString *)tempSign key20:(NSString *)tempKey value:(NSDictionary *)tempValue
{
    
    tempKey = [self getTwentyKey:tempKey];
    
    NSString *parmString = [self sortParam:tempValue];
    NSLog(@"排序:%@  sign:%@  tempkey:%@",parmString,tempSign,tempKey);
    NSString *tokenString = [NSString stringWithFormat:@"%@%@%@",parmString,tempSign,tempKey];
    NSLog(@"token:%@",tokenString);
    tokenString = [self md5:tokenString];
//    NSLog(@"tokenString:%@ length:%d",tokenString,(int)[tokenString length]);
//    unichar string1=[tokenString characterAtIndex:30-1];
//    unichar string2=[tokenString characterAtIndex:4-1];
//    unichar string3=[tokenString characterAtIndex:19-1];
//    unichar string4=[tokenString characterAtIndex:24-1];
//    unichar string5=[tokenString characterAtIndex:12-1];
//    unichar string6=[tokenString characterAtIndex:9-1];
//    unichar string7=[tokenString characterAtIndex:26-1];
//    unichar string8=[tokenString characterAtIndex:18-1];
//    NSString *real_token = [NSString stringWithFormat:@"%c%c%c%c%c%c%c%c",string1,string2,string3,string4,string5,string6,string7,string8];
//    NSLog(@"realToken:%@",tokenString);
    return tokenString;
}


#pragma mark -- 解密
+ (NSString *)decrypt:(NSString *)cipherString key:(NSString *)tempKey
{
    
    tempKey = [self getEightKey:tempKey];
    
 
    NSData *cipherData = [GTMBase64 decodeString:cipherString];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;

    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [tempKey UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);

    NSString *plainText = nil;
    
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSInteger)numBytesDecrypted];
        
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return plainText;
}


#pragma mark -- 加密
+ (NSString *)encryption:(NSString *)clearText key:(NSString *)temoKey
{

    temoKey = [self getEightKey:temoKey];
    
    NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [temoKey UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        plainText = [GTMBase64 stringByEncodingData:dataTemp];
    }else{
        NSLog(@"DES加密失败");
    }
    
    return plainText;
}

#pragma mark -- 将参数排序
+ (NSString *)sortParam:(NSDictionary *)param
{
    if ([[param allKeys] count] == 1) {
        return param[param.allKeys[0]];
    }else{
        NSMutableDictionary *oldParam = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[param allKeys]];
        NSArray *unChangeKeys = [param allKeys];
        
        //第一步 将所有key转成大写
        for (int i = 0 ; i < [keys count]; i ++) {
            
            NSString *key = keys[i];
            
            NSString *value = param[key];
            
            key = [key uppercaseString];
            
            [keys replaceObjectAtIndex:i withObject:key];
            
            [oldParam setObject:value forKey:key];
            
        }
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES]];
        NSArray *sortArray = [keys sortedArrayUsingDescriptors:sortDescriptors];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        for (int i = 0 ; i < [sortArray count]; i ++) {
            NSString *sortKeyString = sortArray[i];
            
            NSString *getOldKey;
            
            for (int j = 0; j < [unChangeKeys count]; j++) {
                if ([sortKeyString isEqualToString:[unChangeKeys[j] uppercaseString]]) {
                    getOldKey = unChangeKeys[j];
                    break;
                }
                
                
            }
            
            [dic setObject:oldParam[sortKeyString] forKey:getOldKey];
            
        }
        
        
        NSString *paramString = @"";
        
        for (int i = 0; i < [dic count]; i ++) {
            NSString *kString = [sortArray[i] lowercaseString];
            //        NSLog(@"kString:%@",kString);
            if ([paramString isEqualToString:@""]) {
                paramString = dic[kString];
            }else{
                paramString = [NSString stringWithFormat:@"%@,%@",paramString,dic[kString]];
            }
            
        }
        return paramString;
    }
}

@end
