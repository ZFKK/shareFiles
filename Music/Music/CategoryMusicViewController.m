//
//  CategoryMusicViewController.m
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "CategoryMusicViewController.h"
#import "SongAlbumViewController.h"
//点击一个cell之后进行跳转的VC

#import "MoreCategoryViewModel.h"
//这个是请求参数不同的VM，主要和推荐页面的比较

#import "MoreCategoryCell.h"
//这个cell和推荐页面的cell一样

#import "BounceView.h"
//用于快速滑动到顶部的view

@interface CategoryMusicViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MoreCategoryViewModel *categoryVM;
@property (nonatomic,strong) BounceView *up;

@end

@implementation CategoryMusicViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 启动开启上拉刷新,并且用自带的MJ
    [self.tableView.mj_header beginRefreshing];
    
    self.hidesBottomBarWhenPushed = YES;
    //隐藏 tabBar 在navigationController结构中
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden == YES){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [self setupNav];
    
}

-(void)setupNav{
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = self.keyName;
    //注意 :这里的keyname是从推荐页面的跳转传递过来的
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    if (_up){
        [_up removeFromSuperview];
    }
}
#pragma mark - VM懒加载
- (MoreCategoryViewModel *)categoryVM {
    if (!_categoryVM) {
        // 通过categoryID name创建网络解析
        _categoryVM = [[MoreCategoryViewModel alloc] initWithCategoryId:2 tagName:self.keyName];
    }
    return _categoryVM;
    //MARK:-1.注意着里的categoryID，可以是2,也可以是3，和AD视图那里的一致
}

#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.categoryVM.rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCategoryIdetify];
    
    [cell.coverBtn setImageForState:UIControlStateNormal withURL:[self.categoryVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"find_albumcell_cover_bg"]];
    
    cell.titleLb.text = [self.categoryVM titleForRow:indexPath.row];
    cell.introLb.text = [self.categoryVM introForRow:indexPath.row];
    cell.playsLb.text = [self.categoryVM playsForRow:indexPath.row];
    cell.tracksLb.text = [self.categoryVM tracksForRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_up){
        [_up removeFromSuperview];
    }
    // 从本控制器VM获取头标题, 以及分类ID回初始化
    SongAlbumViewController *vc = [[SongAlbumViewController alloc] initWithAlbumId:[self.categoryVM albumIdForRow:indexPath.row] title:[self.categoryVM titleForRow:indexPath.row]];
    
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -scrollView滚动
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (targetContentOffset->y > 0){
        UIView *view = [UIApplication sharedApplication].keyWindow;
        [view addSubview:self.up];
        [view bringSubviewToFront:self.up];
        [self.up mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-70);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }else{
        if (_up){
            [_up removeFromSuperview];
        }
    }
}




#pragma mark -upview的懒加载
-(BounceView *)up{
    if (!_up){
        _up = [[BounceView alloc] initWithFrame:CGRectZero WithImage:[UIImage imageNamed:@"blackArrowUP"]];
        [_up WhentapView:^{
            //跳转到最顶部
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [_up removeFromSuperview];
        }];
    }
    
    return _up;
}

#pragma mark -tableview懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[MoreCategoryCell class] forCellReuseIdentifier:MoreCategoryIdetify];
        
        // 上拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //在上啦刷新中，重新请求数据
            [self.categoryVM refreshDataCompletionHandle:^(NSError *error) {
                NSLog(@"乐库点击之后请求数据完成");
                [self setFooter];
                [_tableView.mj_header endRefreshing];
                [_tableView reloadData];
            }];
        }];
        
        _tableView.rowHeight = 70;
    }
    return _tableView;
}

#pragma mark -设置下拉
/** 设置下拉 */
- (void)setFooter{
    
    if (self.categoryVM.rowNumber < 20) {
        //这个按照这种写法永远都不会执行了都
    }else{
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.categoryVM getMoreDataCompletionHandle:^(NSError *error) {
                [_tableView.mj_footer endRefreshing];
                [self changeFooter];
                [_tableView reloadData];
            }];
        }];
    }
}
#pragma mark -取消下拉,对10取余？？？
/** 到底取消下拉刷新 */
- (void)changeFooter{
    
    if (self.categoryVM.rowNumber % 10) {
        _tableView.mj_footer = nil;
    }
}
@end
