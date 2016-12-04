//
//  ZFListSectionView.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFListSectionView.h"
#import "ZFListSectionHeaderViewModel.h"

@interface ZFListSectionView()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic, strong) ZFListSectionHeaderViewModel *viewModel;

@end

@implementation ZFListSectionView


#pragma mark ----重写构造方法
-(instancetype)initWithViewModel:(id<ViewModelDelegate>)viewModel{
    self.viewModel = (ZFListSectionHeaderViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

#pragma mark --约束更新方法
-(void)updateConstraints{
    WS(weakSelf)
    CGFloat paddingEdge = 10;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(@(paddingEdge));
        make.right.equalTo(@(-paddingEdge));
        make.height.equalTo(@(20));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo(@(1.0));
    }];
    
    [super updateConstraints];
    
}

#pragma mark --子类的实现代理方法
-(void)ZF_bindViewModel{
    //这里的该怎么搞？？？
    RAC(self.titleLabel, text) = [[RACObserve(self, viewModel.title) distinctUntilChanged] takeUntil:self.rac_willDeallocSignal];
}

-(void)ZF_setupViews{
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineImageView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    
}

#pragma mark - UI 元素的懒加载方法
- (UIImageView *)bgImageView {

if (!_bgImageView) {

_bgImageView = [[UIImageView alloc] init];
_bgImageView.backgroundColor = white_color;
}
    
    return _bgImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = SYSTEMFONT(17);
        _titleLabel.textColor = MAIN_BLACK_TEXT_COLOR;
    }
    
    return _titleLabel;
}

- (UIImageView *)lineImageView {
    
    if (!_lineImageView) {
        
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = MAIN_LINE_COLOR;
    }
    
    return _lineImageView;
}


@end
