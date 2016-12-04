//
//  ZFTableviewCell.h
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFListCell.h"
#import "ZFCollectionViewModel.h"

@interface ZFTableviewCell : ZFListCell

@property (nonatomic, strong) ZFCollectionViewModel *viewModel;


@end
