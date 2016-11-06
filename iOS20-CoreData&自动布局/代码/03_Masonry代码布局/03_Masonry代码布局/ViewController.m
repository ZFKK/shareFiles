//
//  ViewController.m
//  03_Masonry代码布局
//
//  Created by qianfeng on 15/11/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()
{
    UIView          *_middleView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:topView];
    
    // 先添加到父视图,再添加约束.
    // 添加约束
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 离父视图左边距离为0
        make.left.equalTo(self.view.mas_left).with.offset(0);
        
        // 离父视图上边距离为0
        make.top.equalTo(self.view.mas_top).with.offset(0);
        
        // 离父视图右边为0
        make.right.equalTo(self.view.mas_right).with.offset(0);
        
        // 高度为64
        make.height.equalTo(@(64));
    }];
    
    // 添加顶部视图按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor purpleColor];
    [topView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).with.offset(10);
        
        make.right.equalTo(topView.mas_right).with.offset(-10);
        
        make.width.equalTo(@100);
        
        make.height.equalTo(@35);
    }];
    
    // 添加底部视图
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        
        // .with是为了增强代码的可读性而设计.
        // .with返回self
        
        // @property (nonatomic, assign, getter=isHidden) Bool hidden;
        make.right.equalTo(self.view.mas_right).offset(0);
        
        make.height.equalTo(@64);
    }];
    
    // 添加底部视图的三个按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor purpleColor];
    [bottomView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor purpleColor];
    [bottomView addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.backgroundColor = [UIColor purpleColor];
    [bottomView addSubview:btn3];
    
    
    // 1.设置第一个按钮的约束
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(10);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-10);
        make.left.equalTo(bottomView.mas_left).offset(20);
    }];
    
    // 2.设置第二按钮的约束
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(10);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-10);
        
        make.left.equalTo(btn1.mas_right).offset(20);
        
        // 设置按钮二和按钮一等宽
        make.width.equalTo(btn1.mas_width);
    }];
    
    // 3.设置第三个按钮的约束
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(10);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-10);
        
        make.left.equalTo(btn2.mas_right).offset(20);
        make.right.equalTo(bottomView.mas_right).offset(-20);
        
        // 设置按钮三和按钮二等宽
        make.width.equalTo(btn2.mas_width);
    }];
    
    // 添加中间视图
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:middleView];
    
//    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        /*
//        make.top.equalTo(self.view.mas_top).offset(64);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-64);
//         */
//        
//        make.top.equalTo(topView.mas_bottom).offset(0);
//        make.bottom.equalTo(bottomView.mas_top).offset(0);
//        
//        make.width.equalTo(self.view.mas_width);
//    }];
    
    middleView.frame = CGRectMake(0, 0, self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    middleView.center = self.view.center;
    _middleView = middleView;
}

// 确定控制器是否可以自动旋转
- (BOOL)shouldAutorotate {
    NSLog(@"切换屏幕");
    _middleView.frame = CGRectMake(0, 0, self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    _middleView.center = self.view.center;
    return NO;
}

@end
