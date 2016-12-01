//
//  BaseNetWorking.m
//  RunTimeDemo
//
//  Created by duck on 2016/11/30.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import "BaseNetWorking.h"
#import <UIKit/UIKit.h>

static NSString *const kDZBaseURLString = @"http://192.168.36.244:8080/app/"; //正式服务器

@implementation BaseNetWorking

/**
 *添加公共参数
 */
- (NSMutableDictionary *)createCurrencyData:(NSDictionary *) param
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] initWithDictionary:param];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *deviceType = @"IOS";
    NSString *deviceWidth = [NSString stringWithFormat:@"%d",(int)[[UIScreen mainScreen] bounds].size.width];
    NSString *deviceHigh = [NSString stringWithFormat:@"%d",(int)[[UIScreen mainScreen] bounds].size.height];
    
    [retDic setObject:app_Version forKey:@"appVersion"];
    [retDic setObject:systemVersion forKey:@"systemVersion"];
    [retDic setObject:deviceType forKey:@"deviceType"];
    [retDic setObject:deviceWidth forKey:@"deviceWidth"];
    [retDic setObject:deviceHigh forKey:@"deviceHigh"];
    //...等等
    return retDic;
}


- (void)DDPost:(NSDictionary *)param path:(NSString *)postUrl success:(successBlock)success faild:(faildBlock)faild
{
//    NSMutableDictionary *dic = [self createCurrencyData:param];
    
    [[AFHTTPRequestOperationManager manager] POST:[self DDCreateServiceURL:postUrl] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        faild(error);
    }];
}

/**
 *拼接请求地址加方法
 */
- (NSString *)DDCreateServiceURL:(NSString *) urlString
{
//    NSLog(@"_____:%@",[NSString stringWithFormat:@"%@%@",kDZBaseURLString,urlString]);
    
    return [NSString stringWithFormat:@"%@%@",kDZBaseURLString,urlString];
}

@end
