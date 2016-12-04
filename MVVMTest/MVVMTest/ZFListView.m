//
//  ZFListView.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFListView.h"

#import "ZFListViewModel.h"
#import "ZFListHeaderView.h"
#import "ZFListSectionView.h"
#import "ZFTableviewCell.h"


@interface ZFListView() <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZFListViewModel *viewModel;//用来存放两种VM，一个是head，一个是section

@property (strong, nonatomic) UITableView *mainTableView;

@property (strong, nonatomic) ZFListHeaderView *listHeaderView;

@property (strong, nonatomic) ZFListSectionView *sectionHeaderView;

@end

@implementation ZFListView

#pragma mark --构造器
-(instancetype)initWithViewModel:(id<ViewModelDelegate>)viewModel{
    self.viewModel = (ZFListViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

#pragma mark --更新约束，本身就是UIView的方法
- (void)updateConstraints {
    
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark --协议方法
-(void)ZF_setupViews{
    [self addSubview:self.mainTableView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark --这里的refreshEndSubject，没怎么懂？？？
-(void)ZF_bindViewModel{
    [self.viewModel.refreshDataCommand execute:nil];
    //这里表示不用进行数据请求
    @weakify(self);
    [self.viewModel.refreshUI subscribeNext:^(id x) {
        
        @strongify(self);
        [self.mainTableView reloadData];
    }];
    
    //下边是刷新结束后的操作
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);
        
        [self.mainTableView reloadData];
        
        switch ([x integerValue]) {
            case ZFHeaderRefresh_HasMoreData: {
                
                [self.mainTableView.mj_header endRefreshing];
                
                if (self.mainTableView.mj_footer == nil) {
                    
                    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        @strongify(self);
                        [self.viewModel.nextPageCommand execute:nil];
                    }];
                }
            }
                break;
            case ZFHeaderRefresh_HasNoMoreData: {
                
                [self.mainTableView.mj_header endRefreshing];
                self.mainTableView.mj_footer = nil;
            }
                break;
            case ZFFooterRefresh_HasMoreData: {
                
                [self.mainTableView.mj_header endRefreshing];
                [self.mainTableView.mj_footer resetNoMoreData];
                [self.mainTableView.mj_footer endRefreshing];
            }
                break;
            case ZFFooterRefresh_HasNoMoreData: {
                [self.mainTableView.mj_header endRefreshing];
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
                break;
            case ZFRefreshError: {
                
                [self.mainTableView.mj_footer endRefreshing];
                [self.mainTableView.mj_header endRefreshing];
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark --下边的都是懒加载
-(ZFListViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [[ZFListViewModel alloc] init];
    }
    return _viewModel;
}
#pragma mark --tableview的懒加载
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = GX_BGCOLOR;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableHeaderView = self.listHeaderView;
        [_mainTableView registerClass:[ZFTableviewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZFTableviewCell class])]];
        
        WS(weakSelf)
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.refreshDataCommand execute:nil];
        }];
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.nextPageCommand execute:nil];
        }];
    }
    
    return _mainTableView;
}

#pragma mark --表格视图的头视图
-(ZFListHeaderView *)listHeaderView{
    if (!_listHeaderView){
        _listHeaderView = [[ZFListHeaderView alloc] initWithViewModel:self.viewModel.listHeaderViewModel];
        _listHeaderView.frame = CGRectMake(0, 0, SCREENWIDTH, 160);
    }
    return _listHeaderView;
}

#pragma mark --表格视图的section视图
-(ZFListSectionView *)sectionHeaderView{
    if (!_sectionHeaderView){
        _sectionHeaderView = [[ZFListSectionView alloc] initWithViewModel:self.viewModel.sectionHeaderViewModel];
    }
    return _sectionHeaderView;
}

#pragma mark --表格视图的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count;
    //注意：这种数据都是从VM中拿取的
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZFTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([ZFTableviewCell class])] forIndexPath:indexPath];
    if (indexPath.row < self.viewModel.dataArray.count){
        cell.viewModel = self.viewModel.dataArray[indexPath.row];
        //每个cell里也是显示的VM
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel.cellClickSubject sendNext:nil];
    NSLog(@"tabelview点击了%ld",indexPath.row);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

@end
