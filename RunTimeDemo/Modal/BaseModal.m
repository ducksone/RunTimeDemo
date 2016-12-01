//
//  BaseModal.m
//  RunTimeDemo
//
//  Created by duck on 2016/11/30.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import "BaseModal.h"
#import <objc/runtime.h>

@implementation BaseModal

- (void)setModalValue:(id) result
{
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([self class], &propsCount);//获得属性列表
    
    for(int i = 0 ; i < propsCount ; i ++){
        objc_property_t prop = props[i];
        
        //对象中属性的名字
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        NSString *baseName = [NSString stringWithUTF8String:property_getName(prop)];
        
        id value = [result valueForKey:propName];
        
        //获取类名
        NSString *className = [self getClassName:prop];
        
        if(className.length == 0){
            //非oc类型 int float 之类
            //触发断言 表示 解析数据字段与实际字段类型不符
            assert(baseName != nil && baseName.length != 0);
            if (value){
                [self setValue:value forKey:baseName];
            }else{
                [self setValue:0 forKey:baseName];
            }
        }else{
            //自定义处理 字典 数组 其他类
            value = [BaseModal decodeJson:value];
            
            //值不存在的时候 各个类型一一赋值
            if(!value){
                if([className isEqualToString:@"NSString"]){
                    [self setValue:@"" forKey:baseName];
                }else if([className isEqualToString:@"NSArray"] ||
                         [className isEqualToString:@"NSMutableArray"]){
                    Ivar ivar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@",baseName] UTF8String]);
                    object_setIvar(self, ivar, [[NSMutableArray alloc] initWithArray:@[]]);
                }else if([className isEqualToString:@"NSDictionary"] ||
                         [className isEqualToString:@"NSMutableDictionary"]){
                    Ivar ivar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@",baseName] UTF8String]);
                    object_setIvar(self, ivar, [[NSMutableDictionary alloc] initWithDictionary:@{}]);
                }else{
                    [self setValue:0 forKey:baseName];
                }
                
                continue;
            }
            
            
            if(![value isKindOfClass:NSClassFromString(className)]){
                assert([value isKindOfClass:[NSNumber class]]);
            }
            
            [self setValue:value forKey:baseName];
        }
    }
}


/*!
 *
 *  @brief  解析Json数据包里面的各层数据
 *
 *  @param obj Json原始数据
 *
 *  @return 解析完成的结构体
 *
 *  @since 1.1.1
 */
+ (id)decodeJson:(id) obj
{
    if(obj == nil)
        return nil;
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        if ([obj isKindOfClass:[NSString class]]) {
            /*!
             *
             *  @brief  判断解析出来的nsstring类型是否是nsarry数据
             *
             *  如果是nsarry则继续递归调用本函数继续解析nsarry中的数据，一直到解析到最后的字符串为止
             *
             *  arrayWithJsonString函数用于将字符串转换为nsarry类型，如果失败，则证明是nsstring返回为nil
             */
            return [self arrayWithJsonString:obj]==nil?obj:[self decodeJson:[self arrayWithJsonString:obj]];
        }
        return obj;
    }
    
    /*!
     *
     *  @brief  解析nsarry数据结果集
     *
     *  @since 递归调用本函数进行每个值的根节点解析
     */
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int iLoop = 0;iLoop < objarr.count; iLoop++)
        {
            [arr setObject:[self decodeJson:[objarr objectAtIndex:iLoop]] atIndexedSubscript:iLoop];
        }
        return arr;
    }
    
    /*!
     *
     *  @brief  字典类型数据解析，递归调用至最底层字符串
     *
     *  @since
     */
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self decodeJson:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return nil;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回数组 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    // android端数据组包有问题，故此加上此异常符号替换功能
    NSString *tempString1 = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *tempString2 = [tempString1 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSString *tempString3 = [tempString2 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSData *jsonData = [tempString3 dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
    if(err)
        return nil;
    
    return array;
}

/**
 *解析出prop正确的类型字符串
 */
- (NSString*)getClassName:(objc_property_t) prop
{
    const char* cClassName   = property_getAttributes(prop);
    char szClassName[256]={0};
    // T@\"NSString\",&,N,V_action Object类型
    // 基本类型
    // "Tq,N,V_datetime" NSIntger
    // "Td,N,V_datetime" double
    // "Tf,N,V_datetime" float
    // "Td,N,V_datetime" CGfloat
    // "Ti,N,V_datetime" int
    // "Tq,N,V_datetime" long
    // "Tq,N,V_datetime" long long
    for (int iIndex = 3; iIndex < strlen(cClassName); iIndex++) {
        if (cClassName[iIndex] == ',')
            break;
        
        szClassName[iIndex - 3] = cClassName[iIndex];
    }
    szClassName[strlen(szClassName) - 1] = 0;
    return [NSString stringWithUTF8String:szClassName];
}


@end
