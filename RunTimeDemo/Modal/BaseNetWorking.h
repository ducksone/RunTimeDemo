//
//  BaseNetWorking.h
//  RunTimeDemo
//
//  Created by duck on 2016/11/30.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 *请求成功的回调block
 *response 返回参数
 */
typedef void (^successBlock) (id response);

/**
 *请求失败的回调block
 *error 错误信息
 */
typedef void (^faildBlock) (NSError *error);

@interface BaseNetWorking : NSObject

/**
 *所有POST请求
 */
- (void)DDPost:(NSDictionary *) param
          path:(NSString *) postUrl
       success:(successBlock) success
         faild:(faildBlock) faild;

@end
