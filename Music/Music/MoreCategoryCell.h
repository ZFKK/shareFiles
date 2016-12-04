//
//  MoreCategoryCell.h
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCategoryCell : UITableViewCell

//头像
@property (nonatomic,strong) UIButton *coverBtn;
//专辑名称
@property (nonatomic,strong) UILabel *titleLb;
// 作者信息
@property (nonatomic,strong) UILabel *introLb;
// 播放次数
@property (nonatomic,strong) UILabel *playsLb;
// 集数
@property (nonatomic,strong) UILabel *tracksLb;

@end
