//
//  NSObject+Runtimer.m
//  ScaleTableView
//
//  Created by sunkai on 16/11/21.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "NSObject+Runtimer.h"
#import <objc/runtime.h>

@implementation NSObject (Runtimer)


+(instancetype)objcWithDic:(NSDictionary *)dic{
    id person = [[self alloc] init];
    
    //使用字典，设置对象信息
    //获得self的属性列表
    NSArray *list = [self objProperties];
    
    //遍历字典
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([list containsObject:key]){
            //说明属性存在，可以使用KVC来进行设置
            [person setValue:obj forKey:key];
        }
    }];
    
    return person;
}

const char * propertylistkey = "key1";
//设置key

+(NSArray *)objProperties{

    //从关联对象中获取对象属性，如果有的话，直接返回，不会再去遍历属性，毕竟一个类的属性在运行时是不会发生变化的！！！，这样的话，可以很大的提高效率
    NSArray  *result = objc_getAssociatedObject(self, propertylistkey);
    if (result){
        //表示存在这样的数组
        return result;
        
    }
    
    //调用运行时方法，获得类的属性列表
    //Ivar 变量
    //Method 方法
    //Property 属性
    //Protocol 协议
    
    //创建数组
    NSMutableArray *arr = [NSMutableArray array];
    
    unsigned int count = 0;
    objc_property_t *proList = class_copyPropertyList([self class], &count);
    
    //遍历所有属性
    for (unsigned int i = 0; i < count; i++) {
          //从数组中获取属性,并且是一个C类型额结构体形式
        objc_property_t pty = proList[i];
        //获取属性名称
        const char *name = property_getName(pty);
        NSString *na = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        //添加到数组
        [arr addObject:na];
//        NSLog(@"%s",name);
    }
    
    
    //释放数组
    free(proList);
    
    //对象的属性数组获取完毕，这时可以利用关联，进行动态添加属性
    //OC 中Class是一个特殊的对象
    objc_setAssociatedObject(self, propertylistkey, arr.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [arr copy];
}


@end
