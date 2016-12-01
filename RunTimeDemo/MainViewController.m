//
//  MainViewController.m
//  RunTimeDemo
//
//  Created by duck on 2016/11/14.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import "MainViewController.h"
#import <objc/runtime.h>
#import "UserModal.h"
#import "NetWorkHandle.h"
#import "ENDE.h"

typedef struct objc_method *Method;
/// 实例变量
typedef struct objc_ivar *Ivar;

@interface MainViewController ()
{
    
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationItem setTitle:@"测试RunTime"];
    
    
    NSLog(@"______rect:%@",NSStringFromCGRect([[UIScreen mainScreen] bounds]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)reloadShowLabel//:(NSString *)showInfo
{
    self.showLabel.text = [NSString stringWithFormat:@"回调信息:%@",@"222"];
}


- (IBAction)testRuntimeAction:(id)sender {
    
//    unsigned int count;
//    
//    Method *methodList = class_copyMethodList([self class], &count);
//    for (unsigned int i; i<count; i++) {
//        Method method = methodList[i];
//        NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
//    }
//    
//    //获取成员变量列表
//    Ivar *ivarList = class_copyIvarList([self class], &count);
//    for (unsigned int i; i<count; i++) {
//        Ivar myIvar = ivarList[i];
//        const char *ivarName = ivar_getName(myIvar);
//        NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
//    }
    
//    [[LoginViewModal shareLoginModal] loginAction];
    
    
//    NSString *resultString = @"{data={userName=\"邓松\",userSex=\"男\",userAge=\"24\"},returnCode=0,msg=\"SUCCESS\"}";
    
//    NSDictionary *dic = @{@"data":@[@{@"userName":@"邓松",@"userSex":@"男",@"userAge":@"24"}],@"returnCode":@"0",@"msg":@"SUCCESS"};
//    
////    [self setModalValue:dic[@"data"]];
//    
//    @try
//    {
//        Class classU = NSClassFromString(@"UserModalCtrl");
//        if (classU != nil)
//        {
//            SEL opreationSelector = NSSelectorFromString(@"resolveData:");
//            if (opreationSelector != nil)
//                [classU performSelector:opreationSelector withObject:dic];
//            else
//                @throw [NSException exceptionWithName:NSInternalInconsistencyException
//                                               reason:[NSString stringWithFormat:@"runtime类方法查找失败"]
//                                             userInfo:nil];
//        }
//        else
//        {
//            @throw [NSException exceptionWithName:NSInternalInconsistencyException
//                                           reason:[NSString stringWithFormat:@"runtime对象类创建失败"]
//                                         userInfo:nil];
//        }
//    }@catch (NSException * e) {
//        NSLog(@"Exception: %@", e);
//        UIAlertView * alert =
//        [[UIAlertView alloc]
//         initWithTitle:@"runtime参数解析出错"
//         message: [[NSString alloc] initWithFormat:@"%@",e]
//         delegate:nil
//         cancelButtonTitle:nil
//         otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
    
//    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"kkk",@"company",@"llll",@"userNo",@"12345",@"pwd", nil];
    NSLog(@"______开始");
    [[NetWorkHandle shareNetWorkHandle] starPostNetWork:@"UserModalCtrl" method:@"test" param:nil success:^(id response) {
        NSLog(@"____response:%@",response);
    } faild:^(NSError *error) {
        NSLog(@"____error:%@",error);
    }];
    
    
}




@end
