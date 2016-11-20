//
//  Person.m
//  BuildTest
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "Person.h"

@implementation Person

+(instancetype)personWithDic:(NSDictionary *)dic{
    
    Person *obj = [[self alloc] init];
    [obj setValuesForKeysWithDictionary:dic];
    if (obj.age <= 0 || obj.age >= 130){
        obj.age = 0;
    }
    return obj;
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

+(void)loadPersonAsync:(void (^)(Person *))completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1];
    });
    
    Person *per = [Person personWithDic:@{@"name":@"zhangsa",@"age":@5}];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion){
            completion(per);
        }
    });
}

@end
