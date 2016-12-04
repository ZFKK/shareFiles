
//
//  ZFView.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFView.h"

@implementation ZFView


#pragma mark  --重写初始化方法
-(instancetype)init{
    if (self = [super init]){
        [self ZF_setupViews];
        [self ZF_bindViewModel];
    }
    return self;
}

#pragma mark --根据VM来定义的构造器方法，不过这个方法是协议中定义的
-(instancetype)initWithViewModel:(id<ViewModelDelegate>)viewModel{
    if (self = [super init]){
        [self ZF_setupViews];
        [self ZF_bindViewModel];
    }
    return self;
}

#pragma mark --代理方法
-(void)ZF_bindViewModel
{
    //需要在VC中重写？？？
}

-(void)ZF_setupViews{
    
}

#pragma mark --触控返回键盘
-(void)ZF_addReturnKeyBoard{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;

    [tap.rac_gestureSignal subscribeNext:^(id x) {
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdelegate.window endEditing:YES];
    }];
    [self addGestureRecognizer:tap];
}

@end
