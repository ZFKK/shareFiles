//
//  ZFNavigationController.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFNavigationController.h"

@interface ZFNavigationController ()

@end

@implementation ZFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --这里不允许自动旋转
-(BOOL)shouldAutorotate{
    return NO;
}

#pragma mark --返回所有支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

#pragma mark --返回present出一个VC的时候，所支持的屏幕方向
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}
#pragma mark --返回一个控制器，根据这个控制器来使用状态栏的style，如果是nil，使用系统的
-(UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
