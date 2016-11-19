//
//  ViewController.m
//  FB
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //习惯写法，传统写法，run 和 eat 需要单独调用
    //不能随意进行组合
    Person *person = [Person new];
    [person run];
    [person eat];
     NSLog(@"上边是传统");
    
    //类似的链式编程，只是需要返回值是这个对象本身即可
    Person *ceshi = [Person new];
    [[ceshi run1] eat1];
    [[ceshi eat1] run1];
    NSLog(@"上边是链式");

    //函数式，一般来说进行block的时候，需要小括号，所以，方法的返回值就是一个block
    ceshi.run2().run2().eat2().run2();
    ceshi.eat3(@"一坨坨的").run3(10.0);
    NSLog(@"上边是函数式和链式");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
