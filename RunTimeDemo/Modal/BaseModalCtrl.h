//
//  BaseModalCtrl.h
//  RunTimeDemo
//
//  Created by duck on 2016/11/30.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *所有实体控制类的父类
 *将josn中的数据放入实体类中
 */
@interface BaseModalCtrl : NSObject

- (NSDictionary *)resolveData:(id) result;

@end
