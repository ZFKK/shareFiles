//
//  Person.h
//  BuildTest
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic)NSInteger age;

+(instancetype)personWithDic:(NSDictionary *)dic;

//异步加载个人记录
+(void)loadPersonAsync:(void(^)(Person *))completion;

@end
