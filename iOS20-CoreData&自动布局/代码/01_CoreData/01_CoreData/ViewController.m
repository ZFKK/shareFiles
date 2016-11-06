//
//  ViewController.m
//  01_CoreData
//
//  Created by qianfeng on 15/11/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()
{
    NSManagedObjectContext      *_context; // 管理数据库的上下文.
    
    NSArray                     *_persons;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 四：创建管理对象模型:指定管理的文件为Model.xcdatamodeled
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"]];
    
    // 三:创建一个持久化存储调度器(相当于sqlite数据库与Model.xcdatamodeld的连接者)
    NSPersistentStoreCoordinator *persinstentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    // 1.Type:指定要连接的数据库类型 NSSQLiteStoreType
    // 2.URL:数据库的路径
    NSString *dbPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/person.db"];
    
    NSError *error;
    // 五:设置持久化存储调度器的存储类型和数据库路径
    [persinstentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:nil error:&error];
    
    if (error) {
        NSLog(@"数据库连接失败");
    } else {
        NSLog(@"数据库连接成功");
    }
  
    // 一.初始化管理数据库的上下文
    _context = [[NSManagedObjectContext alloc] init];
    
    // 二:设置持久化存储调度器
    [_context setPersistentStoreCoordinator:persinstentStoreCoordinator];
    
    // 插入数据
    //[self insertData];
    
    // 删除数据
    // [self deleteData];
    
    // 修改数据
    //[self updateData];
    
    // 执行查询
    [self fetchAllData];
    
    // 执行条件查询
    [self fetchByRequirement];
}

#pragma mark 插入数据
- (void)insertData {
    
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:_context];
    person.name = @"Xiaohua";
    person.age = @(27);
    
    //[_context insertObject:person];
    
    // 如果我们没有调用save方法,数据并不会真正写入数据库.
    NSError *error;
    [_context save:&error];
    
    if (error) {
        NSLog(@"插入失败:%@", error);
    } else {
        NSLog(@"插入成功");
    }
}

#pragma mark 删除数据
- (void)deleteData {
    
    Person *p = _persons[0];
    
    [_context deleteObject:p];
    
    NSError *error;
    [_context save:&error];
    
    if (error) {
        NSLog(@"删除失败:%@", error);
    } else {
        NSLog(@"删除成功");
    }
}

#pragma mark 修改数据
- (void)updateData {
    Person *p = _persons[2];
    p.age = @(48);
    
    NSError *error;
    
    [_context save:&error];
    
    if (error) {
        NSLog(@"修改失败:%@", error);
    } else {
        NSLog(@"修改成功");
    }
}

#pragma mark 查询数据
- (void)fetchAllData {
    
    // 查询请求对象
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    // 执行查询
    NSArray *fetchRsults = [_context executeFetchRequest:fetchRequest error:nil];
    
    _persons = fetchRsults;
    
    for (Person *p in fetchRsults) {
        NSLog(@"姓名:%@, 年龄:%@", p.name, p.age);
    }
}

#pragma mark 条件查询
- (void)fetchByRequirement {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    // 创建查询条件对象
    // 查询年龄为27的人 age = 27
    // 查询年龄大于27的人 age > 27
    // 查询姓名为Xiaoming的人  @"name = %@", @"Xiaoming"
    // 查询姓名为Xiaoming且年龄为18的人 @"name = %@ and age = 18", @"Xiaoming"
    // 查询姓为Xiao的人 @"name like %@", @"Xiao*"
    // 查询名为ming的人 @"name like %@", @"*ming"
    // 查询名包含h的人 @"name like %@", @"*h*"
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*h*"];
    
    // 设置查询条件对象
    //[fetchRequest setPredicate:predicate];
    
    // 设置排序条件
    // 1. Key 根据哪个字段排序
    // 2. Ascending : Yes升序， No，降序
    
    // 年龄降序
    NSSortDescriptor *descriptor1 = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:NO];
    
    // 名字升序
    NSSortDescriptor *descriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[descriptor1, descriptor2]];
    
    NSArray *fetchArr = [_context executeFetchRequest:fetchRequest error:nil];

    for (Person *p in fetchArr) {
        NSLog(@"条件查询---姓名:%@, 年龄:%@", p.name, p.age);
    }
}

/** 使用CoreData封装一个DBManager.对FMDB的课堂案例做一个修改.
    检查.
 */

@end
