//
//  BuildTestTests.m
//  BuildTestTests
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"

@interface BuildTestTests : XCTestCase

@end

@implementation BuildTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//检查新建的person模型
-(void)testNewPerson{
    [self checkPersonWithDic:@{@"name":@"张三",@"age":@20}];
    [self checkPersonWithDic:@{@"name":@"张三"}];
    [self checkPersonWithDic:@{}];
    [self checkPersonWithDic:@{@"name":@"张三",@"age":@20,@"title" : @"boss"}];
    [self checkPersonWithDic:@{@"name":@"张三",@"age":@200,@"title" : @"boss"}];

}


-(void)checkPersonWithDic:(NSDictionary *)dic{
    Person *person = [Person personWithDic:dic];
    NSLog(@"%@",person);
    
    //获取字典信息
    NSString *name = dic[@"name"];
    NSInteger age = [dic[@"age"] integerValue];
    
    //检查名称
    XCTAssert([name isEqualToString:person.name] || person.name == nil,@"姓名不对");
    //检测年龄
    if (person.age > 0 && person.age < 130){
        XCTAssert(age == person.age,@"年龄不对");
    }else{
        XCTAssert(person.age == 0,@"年龄不对");
    }
   }

//苹果的单元测试方法 是串行的！！！
- (void)testLoadPersonAsync{
    
    //Xcode 6开始解决异步测试的问题
    XCTestExpectation *exception = [self expectationWithDescription:@"异步加载检测"];
    [Person loadPersonAsync:^(Person *per) {
        NSLog(@"获取到结果啦");
        //标注预期达成
        [exception fulfill];
    }];
    
    //等待预期的达成，这里是等待10s，如果超时，就会出现错误
    [self waitForExpectationsWithTimeout:10 handler:nil];
}


- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//性能测试,相同的代码重复执行10次，统计计算时间，平均时间
//一旦写好，可以随时测试
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{

        //把需要测量执行时间的代码放在这里
        NSTimeInterval start = CACurrentMediaTime();
        
        for (int i = 0; i < 10000; i++){
            [Person personWithDic:@{@"name":@"zhangsan",@"age":@20}];
        }
    
        NSLog(@"%f",CACurrentMediaTime() - start);
    }];
}

@end
