//
//  NetWorkHandle.h
//  RunTimeDemo
//
//  Created by duck on 2016/11/30.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetWorking.h"

@interface NetWorkHandle : BaseNetWorking

+ (NetWorkHandle *)shareNetWorkHandle;

/**
 *开始一个POST请求 
 *modalName 实体类名
 *methodName 方法名
 *dic 传入参数
 *success 成功回调
 *faild 失败回调
 */
- (void)starPostNetWork:(NSString *) modalName
                 method:(NSString *) methodName
                  param:(NSDictionary *) dic
                success:(successBlock) success
                  faild:(faildBlock) faild;

@end
