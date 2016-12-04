//
//  ZFTableviewCell.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFTableviewCell.h"

@interface ZFTableviewCell()

@property (nonatomic, strong) UIImageView *headerImageView; //头像

@property (nonatomic, strong) UILabel *nameLabel; //标题

@property (nonatomic, strong) UIImageView *articleImageView; //文章图片

@property (nonatomic, strong) UILabel *articleLabel;  //文章

@property (nonatomic, strong) UIImageView *peopleImageView; //访问头像

@property (nonatomic, strong) UILabel *peopleNumLabel;//访问量

@property (nonatomic, strong) UILabel *contentLabel; //内容

@property (nonatomic, strong) UIImageView *lineImageView; //cell边线

@end

@implementation ZFTableviewCell

#pragma mark --协议方法,父类的
-(void)ZF_setupViews{
    
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.articleImageView];
    [self.contentView addSubview:self.articleLabel];
    [self.contentView addSubview:self.peopleImageView];
    [self.contentView addSubview:self.peopleNumLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.lineImageView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}

#pragma mark --更新约束
-(void)updateConstraints{
    WS(weakSelf)
    
    CGFloat paddingEdge = 10;
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(paddingEdge));
        make.centerY.equalTo(weakSelf.contentView);
        NSValue *value = [NSValue valueWithCGSize:CGSizeMake(80, 80)];
        make.size.equalTo(value);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.headerImageView.mas_right).offset(paddingEdge);
        make.top.equalTo(weakSelf.headerImageView);
        make.right.equalTo(@(-paddingEdge));
        make.height.equalTo(@(15));
    }];
    
    [self.articleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.nameLabel);
        NSValue *value = [NSValue valueWithCGSize:CGSizeMake(15, 15)];
        make.size.equalTo(value);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(paddingEdge);
    }];
    
    [self.articleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.articleImageView.mas_right).offset(3);
        NSValue *value = [NSValue valueWithCGSize:CGSizeMake(50, 15)];
        make.size.equalTo(value);
        make.centerY.equalTo(weakSelf.articleImageView);
    }];
    
    [self.peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.articleLabel.mas_right).offset(paddingEdge);
        NSValue *value = [NSValue valueWithCGSize:CGSizeMake(15, 15)];
        make.size.equalTo(value);
        make.centerY.equalTo(weakSelf.articleImageView);
    }];
    
    [self.peopleNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.peopleImageView.mas_right).offset(3);
        make.centerY.equalTo(weakSelf.peopleImageView);
        NSValue *value = [NSValue valueWithCGSize:CGSizeMake(50, 15)];
        make.size.equalTo(value);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.articleImageView.mas_bottom).offset(paddingEdge);
        make.left.equalTo(weakSelf.articleImageView);
        make.right.equalTo(@(-paddingEdge));
        make.height.equalTo(@(15));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@(1.0));
    }];
    [super updateConstraints];
}

#pragma mark --setter方法,赋值
- (void)setViewModel:(ZFCollectionViewModel *)viewModel {
    
    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    
    [self.headerImageView sd_setImageWithURL:URL(viewModel.headerImageStr) placeholderImage:ImageNamed(@"yc_circle_placeHolder.png")];
    self.nameLabel.text = viewModel.name;
    self.articleLabel.text = viewModel.articleNum;
    self.peopleNumLabel.text = viewModel.peopleNum;
    self.contentLabel.text = viewModel.content;
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
        _nameLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _nameLabel.font = SYSTEMFONT(14);
    }
    
    return _nameLabel;
}

- (UIImageView *)articleImageView {
    
    if (!_articleImageView) {
        
        _articleImageView = [[UIImageView alloc] init];
        _articleImageView.backgroundColor = red_color;
    }
    
    return _articleImageView;
}

- (UILabel *)articleLabel {
    
    if (!_articleLabel) {
        
        _articleLabel = [[UILabel alloc] init];
        _articleLabel.textColor = MAIN_LINE_COLOR;
        _articleLabel.font = SYSTEMFONT(12);
    }
    
    return _articleLabel;
}

- (UIImageView *)peopleImageView {
    
    if (!_peopleImageView) {
        
        _peopleImageView = [[UIImageView alloc] init];
        _peopleImageView.backgroundColor = red_color;
    }
    
    return _peopleImageView;
}

- (UILabel *)peopleNumLabel {
    
    if (!_peopleNumLabel) {
        
        _peopleNumLabel = [[UILabel alloc] init];
        _peopleNumLabel.textColor = MAIN_LINE_COLOR;
        _peopleNumLabel.font = SYSTEMFONT(12);
    }
    
    return _peopleNumLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _contentLabel.font = SYSTEMFONT(14);
    }
    
    return _contentLabel;
}

- (UIImageView *)lineImageView {
    
    if (!_lineImageView) {
        
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = MAIN_LINE_COLOR;
    }
    
    return _lineImageView;
}


@end
