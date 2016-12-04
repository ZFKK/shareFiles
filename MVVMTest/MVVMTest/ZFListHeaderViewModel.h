//
//  ZFListHeaderViewModel.h
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFVIewModel.h"

@interface ZFListHeaderViewModel : ZFVIewModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *refreshUISubject;//这里是针对单个cell的刷新么？？？是一个信号

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end
