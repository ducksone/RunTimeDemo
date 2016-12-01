//
//  LoginViewModal.m
//  RunTimeDemo
//
//  Created by duck on 2016/11/14.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import "LoginViewModal.h"

static LoginViewModal *lvModal = nil;

typedef struct objc_method *Method;

@implementation LoginViewModal

+(LoginViewModal *)shareLoginModal
{
    static dispatch_once_t once_Token;
    
    dispatch_once(&once_Token, ^{
        lvModal = [[LoginViewModal alloc] init];
        
    });
    
    return lvModal;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
//        NSLog(@"-----初始化登录请求类-----");
    }
    
    return self;
}


- (void)loginAction
{
    unsigned int count;
    
    id LenderClass = objc_getClass("MainViewController");
    
    Method *methodList = class_copyMethodList(NSClassFromString(@"MainViewController"), &count);
    for (unsigned int i; i<count; i++) {
        Method method = methodList[i];
        NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
        
        if ([NSStringFromSelector(method_getName(method)) isEqualToString:@"reloadShowLabel"]) {
//            objc_msg
            [LenderClass performSelector:method_getName(method)];
            
//            objc_msgSend(NSClassFromString(@"MainViewController"),method_getName(method),@"测试");
            NSLog(@"____找到了MainViewController中的ReloadShowLabel方法");
        }
        
    }
    
}


@end
