//
//  ZFListViewModel.h
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFVIewModel.h"
#import "ZFListHeaderViewModel.h"
#import "ZFListSectionHeaderViewModel.h"


@interface ZFListViewModel : ZFVIewModel

//RACSubject
//一个 signal 的子类，是一个可以手动发送 Next、Failed 等事件的 signal。通常用来将 non-RAC 的代码 bridge 成 RAC 的代码,并且是替换代理
//RACCommand
//通常用来执行一个 UI 事件发生后要处理的任务。

@property (nonatomic, strong) RACSubject *refreshEndSubject; //刷新结束之后的信号

@property (nonatomic, strong) RACSubject *refreshUI;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) ZFListHeaderViewModel *listHeaderViewModel;

@property (nonatomic, strong) ZFListSectionHeaderViewModel *sectionHeaderViewModel;

@property (nonatomic, strong) NSArray *dataArray;//tableview 的数据，而不是包括横向滚动的视图

@property (nonatomic, strong) RACSubject *cellClickSubject;


@end
