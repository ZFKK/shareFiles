//
//  ZFCollectionViewCell.h
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFCollerctionViewCellDelegate <NSObject>

@optional

- (void)ZF_setupViews;
//这里为何不用进行绑定VM

@end

@interface ZFCollectionViewCell : UICollectionViewCell <ZFCollerctionViewCellDelegate>

@end
