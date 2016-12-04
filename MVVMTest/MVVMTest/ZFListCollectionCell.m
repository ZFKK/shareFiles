//
//  ZFListCollectionCell.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFListCollectionCell.h"

@interface ZFListCollectionCell()

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ZFListCollectionCell

#pragma mark --父类的协议方法
-(void)ZF_setupViews{
    
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.nameLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}



#pragma mark --更新约束
- (void)updateConstraints {
    
    WS(weakSelf)
    CGFloat paddingEdge = 10;
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@(80));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.headerImageView.mas_bottom).offset(paddingEdge);
        make.height.equalTo(@(15));
        make.left.right.equalTo(weakSelf.headerImageView);
    }];
    
    [super updateConstraints];
}

#pragma mark --setter方法，然后赋值
-(void)setViewModel:(ZFCollectionViewModel *)viewModel{
    if (!viewModel) {
        
        return;
    }
    
    _viewModel = viewModel;
    
    [self.headerImageView sd_setImageWithURL:URL(viewModel.headerImageStr) placeholderImage:ImageNamed(@"yc_circle_placeHolder.png")];
    self.nameLabel.text = viewModel.name;
}


- (void)setType:(NSString *)type {
    
    self.headerImageView.image = ImageNamed(@"circle_plus.png");
    self.nameLabel.text = @"加入新圈子";
}

#pragma mark --UI的懒加载
- (UIImageView *)headerImageView {
    
    if (!_headerImageView) {
        
        _headerImageView = [[UIImageView alloc] init];
    }
    
    return _headerImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = SYSTEMFONT(12);
        _nameLabel.textColor = MAIN_LINE_COLOR;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _nameLabel;
}


@end
