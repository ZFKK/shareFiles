//
//  MyProfileCell.m
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MyProfileCell.h"

@interface MyProfileCell()

@property(nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) UILabel *titleLb;


@end

@implementation MyProfileCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

#pragma mark - data数据的set方法
-(void)setAct:(NSDictionary *)act{
    _act = act;
    self.coverIV.image = [UIImage imageNamed:_act[@"image"]];
    self.titleLb.text = _act[@"title"];
}


#pragma mark - 尽量用懒加载
-(UIImageView *)coverIV{
    if (!_coverIV){
          _coverIV = [[UIImageView alloc] init];
         [self.contentView addSubview:_coverIV];
        [_coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(20);
        }];
    }
    return _coverIV;
}


-(UILabel *)titleLb{
    if (!_titleLb){
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:17];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
        _titleLb.numberOfLines = 0;
    }
    return  _titleLb;
}
@end
