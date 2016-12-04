//
//  AppStart.m
//  MVVMTest
//
//  Created by sunkai on 16/12/3.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "AppStart.h"

@implementation AppStart

#pragma mark --启动app的时候，进行初始化数据加载
+ (void)load{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [[self class] initPersonalData];
    });
    
}

#pragma mark --初始化个人数据
+(void)initPersonalData{
    
}

@end
