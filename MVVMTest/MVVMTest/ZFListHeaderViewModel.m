//
//  ZFListHeaderViewModel.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFListHeaderViewModel.h"

@implementation ZFListHeaderViewModel

#pragma mark --getter方法
-(RACSubject *)refreshUISubject{
    if(!_refreshUISubject){
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}

-(RACSubject *)cellClickSubject{
    if (!_cellClickSubject){
        _cellClickSubject = [RACSubject subject];
    }
    return  _cellClickSubject;
}

-(NSArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}
@end
