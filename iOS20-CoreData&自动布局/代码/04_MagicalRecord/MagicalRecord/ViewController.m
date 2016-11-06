//
//  ViewController.m
//  MagicalRecord
//
//  Created by qianfeng on 15/11/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "CoreData+MagicalRecord.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据库:指定数据库的名字
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"person.db"];
    
    /// 添加数据
    // [self insertData];
    
    
    // 查询数据
    [self fetchData];
    
    // 修改数据
    [self deleteData];
    
    // 查询数据
    [self fetchData];
    
}

- (void)insertData {
    // 初始化要插入的对象
    Person *p = [Person MR_createEntity];
    
    p.name = @"xiaoming";
    
    p.age = @(18);
    
    // 保存到数据库
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark 查询数据
- (void)fetchData {
    // 查询所有数据
    NSArray *persons = [Person MR_findAll];
    for (Person *p in persons) {
        NSLog(@"p.name:%@ , p.age:%@", p.name, p.age);
    }
}

#pragma mark 修改数据
- (void)updateData {
    NSArray *persons = [Person MR_findAll];
    
    // 修改所有person的年龄.
    for (Person *p in persons) {
        p.age = @28;
    }
    
    // 添加
    
    // 保存到数据库
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark 删除数据
- (void)deleteData {
    NSArray *persons = [Person MR_findAll];
    
    for (Person *p in persons) {
        if ([p.name isEqualToString:@"xiaoming"]) {
            [p MR_deleteEntity];
        }
    }
    
    // 保存到数据库
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
