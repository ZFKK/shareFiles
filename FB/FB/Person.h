//
//  Person.h
//  FB
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

-(void)run;
-(void)eat;

-(Person *)run1;
-(Person *)eat1;

//函数式编程
-(Person *(^)())run2;
-(Person *(^)())eat2;

//带参数的函数式
-(Person *(^)(NSString *food))eat3;
-(Person *(^)(double rows))run3;

//关于链式编程和函数式编程
//1.用于自己封装框架
//2.阅读其他人写的代码
@end
