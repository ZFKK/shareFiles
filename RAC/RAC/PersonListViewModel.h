//
//  PersonListViewModel.h
//  RAC
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

//包含网络数据和本地缓存数据
@interface PersonListViewModel : NSObject

//联系人
@property (nonatomic) NSMutableArray <Person *> *personList;

//加载联系人数组,返回的是一个信号 
-(RACSignal *)loadLists;



@end
