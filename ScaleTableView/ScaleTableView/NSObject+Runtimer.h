//
//  NSObject+Runtimer.h
//  ScaleTableView
//
//  Created by sunkai on 16/11/21.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtimer)

//给定一个字典，创建self对应的对象
+(instancetype)objcWithDic:(NSDictionary *)dic;

//返回类的列表属性数组
+(NSArray *)objProperties;

@end
