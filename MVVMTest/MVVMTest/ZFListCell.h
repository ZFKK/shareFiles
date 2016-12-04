//
//  ZFListCell.h
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ListCellDelegate <NSObject>

@optional
-(void)ZF_bindViewModel;
-(void)ZF_setupViews;

@end

@interface ZFListCell : UITableViewCell<ListCellDelegate>

@end
