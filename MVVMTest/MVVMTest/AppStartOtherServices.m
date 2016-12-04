//
//  AppStartOtherServices.m
//  MVVMTest
//
//  Created by sunkai on 16/12/3.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "AppStartOtherServices.h"

@implementation AppStartOtherServices

#pragma mark --启动app的时候，对使用的第三方数据进行初始化
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] initCoreData];
        [[self class] initKeyboard];
        [[self class] initReachibilty];
    });
}

#pragma mark --coreData的初始化
+(void)initCoreData{
    
}

#pragma mark --键盘的回收相关
+(void)initKeyboard{
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;

}
#pragma mark --网络请求相关
+(void)initReachibilty{
    
}

@end
