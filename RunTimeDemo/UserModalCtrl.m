//
//  UserModalCtrl.m
//  RunTimeDemo
//
//  Created by duck on 2016/11/30.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import "UserModalCtrl.h"
#import <objc/runtime.h>
#import "UserModal.h"

@implementation UserModalCtrl


+ (NSDictionary *)resolveData:(id)result
{
    NSLog(@"______:data:%@",result);
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    
    if ([[result allKeys] containsObject:@"obj"]) {
        NSArray *dataArray = result[@"obj"];
        NSMutableArray *retArray = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < [dataArray count]; i ++) {
            UserModal *um = [[UserModal alloc] init];
            [um setModalValue:dataArray[i]];
            [retArray addObject:um];
        }
        
        [retDic setObject:retArray forKey:@"data"];
        [retDic setObject:result[@"code"] forKey:@"returnCode"];
//        [retDic setObject:result[@"msg"] forKey:@"msg"];
        
    }
    
    return retDic;
}





@end
