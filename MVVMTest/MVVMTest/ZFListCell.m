//
//  ZFListCell.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFListCell.h"

@implementation ZFListCell

#pragma mark --构造方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ZF_setupViews];
        [self ZF_bindViewModel];
    }
    return self;
}

#pragma mark --代理方法
-(void)ZF_bindViewModel{
    
}

-(void)ZF_setupViews{
    
}

@end
