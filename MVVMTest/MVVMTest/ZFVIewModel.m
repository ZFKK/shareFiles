//
//  ZFVIewModel.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFVIewModel.h"

@implementation ZFVIewModel

@synthesize request = _request;

#pragma mark --初始化方法,这里是个协议方法，实际上后续的子类都会重写
-(instancetype)initWithModel:(id)model{
    if (self = [super init]){
        
    }
    return self;
}


+(instancetype)allocWithZone:(struct _NSZone *)zone{
    ZFVIewModel *vm = [super allocWithZone:zone];
    if (vm){
        [vm ZF_initialize];
    }
    return  vm;
}

#pragma mark --代理方法
-(ZFRequest *)request{
    if(!_request){
        _request = [ZFRequest shareRequest];
    }
    return  _request;
}

#pragma mark --需要后续进行重写
-(void)ZF_initialize{
    
}


@end
