//
//  NetWorkHandle.m
//  RunTimeDemo
//
//  Created by duck on 2016/11/30.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import "NetWorkHandle.h"

@implementation NetWorkHandle

+ (NetWorkHandle *)shareNetWorkHandle
{
    static NetWorkHandle *nwHandle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nwHandle = [[NetWorkHandle alloc] init];
    });
    
    return nwHandle;
}

// TODO 请求开始和结束 加上HUD
- (void)starPostNetWork:(NSString *)modalName
                 method:(NSString *)methodName
                  param:(NSDictionary *)dic
                success:(successBlock)success
                  faild:(faildBlock)faild
{
    
    if ([modalName isEqualToString:@""] ||
        !modalName) {
        modalName = @"BaseModalCtrl";
    }
    @try {
        //开始请求
        [self DDPost:dic path:methodName success:^(id response) {
            NSLog(@"____response:%@",response);
            @try {
                Class TempClass = NSClassFromString(modalName);
                
                if(!TempClass){
                    SEL TempSelector = NSSelectorFromString(@"resolveData:");
                    if(!TempSelector){
                        //将得到的数据 丢给实体类的控制类 进行复制
                        success([TempClass performSelector:TempSelector withObject:response]);
                    }else{
                        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                                       reason:[NSString stringWithFormat:@"runtime类方法查找失败"]
                                                     userInfo:nil];
                    }
                }else{
                    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                                   reason:[NSString stringWithFormat:@"runtime对象类创建失败"]
                                                 userInfo:nil];
                }
                
            } @catch (NSException *exception) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"runtime参数解析出错" message: [[NSString alloc] initWithFormat:@"%@",exception] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        } faild:^(NSError *error) {
            faild(error);
        }];
        
    } @catch (NSException *exception) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"runtime参数解析出错" message: [[NSString alloc] initWithFormat:@"%@",exception] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    
    
    
}

@end
