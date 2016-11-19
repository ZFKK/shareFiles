//
//  PersonListViewModel.m
//  RAC
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "PersonListViewModel.h"



@implementation PersonListViewModel

-(RACSignal *)loadLists{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"这是信号");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //模拟延时
            [NSThread sleepForTimeInterval:2];
            
            _personList = [NSMutableArray array];
            //创建数组
            for (NSInteger i = 0; i < 20; i++) {
                Person *person = [[Person alloc] init];
                person.name = [NSString stringWithFormat:@"我的%li",(long)i];
                person.age = 15 + arc4random() % 20;
                [_personList addObject:person];
            }
//            NSLog(@"%@",_personList);
            dispatch_async(dispatch_get_main_queue(), ^{
                [subscriber sendNext:_personList];
//                [subscriber sendError:nil];
                [subscriber sendCompleted];
            });
        });

        
        return  nil;
    }];
    
//    NSLog(@"%s",__FUNCTION__);
    }

@end
