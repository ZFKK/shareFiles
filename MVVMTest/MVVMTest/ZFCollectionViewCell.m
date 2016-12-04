//
//  ZFCollectionViewCell.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFCollectionViewCell.h"

@implementation ZFCollectionViewCell

#pragma mark --构造器
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self){
        [self ZF_setupViews];
    }
    return self;
}

#pragma mark --代理方法，需要子类重写
-(void)ZF_setupViews{
    
}


@end
