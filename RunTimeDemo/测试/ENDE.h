//
//  ENDE.h
//  XSF
//
//  Created by duck on 15/7/15.
//  Copyright (c) 2015年 dom.duck. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *加密解密
 */
@interface ENDE : NSObject


/**
 *md5加密
 */
+ (NSString *)md5:(NSString *) inPutText;

/**
 *创建加密的token
 */
+ (NSString *)createToken:(NSString *) tempSign key20:(NSString *) tempKey value:(NSDictionary *) tempValue;


/**
 *解密
 */
+ (NSString *)decrypt:(NSString *) cipherString key:(NSString *) tempKey;


/**
 *加密
 */
+ (NSString *)encryption:(NSString *) clearText key:(NSString *) temoKey;

/**
 *将传入的参数排序
 *传入将要给到后端的参数
 *返回排序后的参数
 */
+ (NSString *)sortParam:(NSDictionary *) param;


@end
