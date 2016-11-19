//
//  Person.m
//  FB
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "Person.h"

@implementation Person

-(void)run{
    NSLog(@"%s",__FUNCTION__);
}

-(void)eat{
    NSLog(@"%s",__FUNCTION__);

}

-(Person *)run1{
    NSLog(@"%s",__FUNCTION__);

    return  self;
}

-(Person *)eat1{
    NSLog(@"%s",__FUNCTION__);

    return self;
}

-(Person * (^)())run2{
    NSLog(@"%s",__FUNCTION__);
    //这里定义一个block
    Person * (^ceshiBlock)() =  ^{
        NSLog(@"又要跑了");
        return  self;
    };
    return ceshiBlock;
}

-(Person *(^)())eat2{
    return ^ {
        NSLog(@"又要吃了");
        return self;
    };
}


-(Person *(^)(NSString *))eat3{
    return ^(NSString *food){
        NSLog(@"你吃的是什么玩意%@",food);
        return  self;
    };
    
}

-(Person *(^)(double))run3{
    return ^(double rows){
        NSLog(@"我都跑了这么多%f",rows);
        return  self;
    };
    
}

@end
