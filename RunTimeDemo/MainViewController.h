//
//  MainViewController.h
//  RunTimeDemo
//
//  Created by duck on 2016/11/14.
//  Copyright © 2016年 Duck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "LoginViewModal.h"

@interface MainViewController : UIViewController
{
    NSString *helloString;
}
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

- (IBAction)testRuntimeAction:(id)sender;
- (void)reloadShowLabel;//:(NSString *) showInfo;

@end
