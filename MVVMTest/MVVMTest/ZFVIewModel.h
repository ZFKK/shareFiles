//
//  ZFVIewModel.h
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import <Foundation/Foundation.h>

//刷新的枚举
typedef enum : NSUInteger {
    ZFHeaderRefresh_HasMoreData = 1,
    ZFHeaderRefresh_HasNoMoreData,
    ZFFooterRefresh_HasMoreData,
    ZFFooterRefresh_HasNoMoreData,
    ZFRefreshError,
    ZFRefreshUI,
} ZFRefreshDataStatus;

@protocol ViewModelDelegate <NSObject>

@optional
-(instancetype)initWithModel:(id )model;
@property (strong, nonatomic)ZFRequest *request;
//用于网络请求
//初始化
- (void)ZF_initialize;

@end


@interface ZFVIewModel : NSObject<ViewModelDelegate>

@end
