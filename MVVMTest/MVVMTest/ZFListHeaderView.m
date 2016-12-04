//
//  ZFListHeaderView.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFListHeaderView.h"
#import "ZFListHeaderViewModel.h"
#import "ZFListCollectionCell.h"

@interface ZFListHeaderView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
//作为整个视图的头视图

@property (nonatomic, strong) ZFListHeaderViewModel *viewModel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@end

@implementation ZFListHeaderView

#pragma mark  --重写父类的构造器方法
-(instancetype)initWithViewModel:(id<ViewModelDelegate>)viewModel{
    self.viewModel = (ZFListHeaderViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

#pragma mark --代理犯法的view方法
-(void)ZF_setupViews{
    
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark --代理方法的绑定方法
-(void)ZF_bindViewModel{
    @weakify(self);
    [[self.viewModel.refreshUISubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    RAC(self.titleLabel, text) = [[RACObserve(self, viewModel.title) distinctUntilChanged] takeUntil:self.rac_willDeallocSignal];
}
#pragma mark --每次都要进行更新约束,实际上就是同意设置布局
- (void)updateConstraints {
    
    WS(weakSelf)
    CGFloat paddingEdge = 10;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(weakSelf);
        make.bottom.equalTo(@(-paddingEdge));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(paddingEdge));
        make.top.equalTo(@(paddingEdge));
        make.right.equalTo(@(-paddingEdge));
        make.height.equalTo(@(20));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-paddingEdge);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(paddingEdge);
    }];
    
    [super updateConstraints];
}

#pragma mark - UI的懒加载方法
- (ZFListHeaderViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZFListHeaderViewModel alloc] init];
    }
    
    return _viewModel;
}

- (UIView *)bgView {
    
    if (!_bgView) {
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = white_color;
    }
    
    return _bgView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = MAIN_BLACK_TEXT_COLOR;
        _titleLabel.font = SYSTEMFONT(15);
    }
    
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.collectionViewLayout = self.flowLayout;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = white_color;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        //注册cell
        [_collectionView registerClass:[ZFListCollectionCell class] forCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZFListCollectionCell class])]];
        
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //水平方向的
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.minimumLineSpacing = 10;
    }
    
    return _flowLayout;
}

#pragma mark --collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZFListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZFListCollectionCell class])] forIndexPath:indexPath];
    if (self.viewModel.dataArray.count > indexPath.row) {
        
        cell.viewModel = self.viewModel.dataArray[indexPath.row];
    }
    
    if (self.viewModel.dataArray.count == indexPath.row) {
        
        cell.type = @"加入新圈子";
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 105);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel.cellClickSubject sendNext:nil];
    //点击了某一个item
    NSLog(@"点击了头%ld",(long)indexPath.row);
}

@end
