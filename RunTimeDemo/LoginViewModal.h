//
//  LoginViewModal.h
//  RunTimeDemo
//
//  Created by duck on 2016/11/14.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface LoginViewModal : NSObject

+ (LoginViewModal *)shareLoginModal;


- (void)loginAction;

@end
