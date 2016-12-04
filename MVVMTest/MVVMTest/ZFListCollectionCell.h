//
//  ZFListCollectionCell.h
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFCollectionViewCell.h"
#import "ZFCollectionViewModel.h"


@interface ZFListCollectionCell : ZFCollectionViewCell

/**
 *  加入新圈子
 */
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) ZFCollectionViewModel *viewModel;


@end
