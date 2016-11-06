//
//  Person.m
//  01_CoreData
//
//  Created by qianfeng on 15/11/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Person.h"


@implementation Person

// 属性的getter和setter方法,coredata会在运行时自动生成
// @dynamic 修饰属性,告诉编译器属性是可以没有setter和getter方法
@dynamic name;
@dynamic age;

@end
