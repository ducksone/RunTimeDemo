//
//  BaseModalCtrl.m
//  RunTimeDemo
//
//  Created by duck on 2016/11/30.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import "BaseModalCtrl.h"

#define ResponseCode @"responseCode" //响应状态
#define ResponseMsg @"responseMsg" // 响应状态说明

@implementation BaseModalCtrl

- (NSDictionary *)resolveData:(id)result
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    if ([[result allKeys] containsObject:ResponseCode]) {
        [retDic setObject:result[ResponseCode] forKey:@"status"];
    }
    
    if ([[result allKeys] containsObject:ResponseMsg]) {
        [retDic setObject:result[ResponseMsg] forKey:@"Msg"];
    }
    
    return retDic;
    
}

@end
