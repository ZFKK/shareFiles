//
//  MoreClickViewController.m
//  
//
//  Created by sunkai on 16/11/12.
//
//

#import "MoreClickViewController.h"
#import "MoreCategoryCell.h"
#import "SongAlbumViewController.h"
//点击一个cell之后进行跳转的VC

#import "MoreClickViewModel.h"
//小编推荐等的VM

@interface MoreClickViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) MoreClickViewModel *moreClickVM;
@property (nonatomic,assign)NSInteger pagesize;
@property (nonatomic,strong) UITableView *tableView;
//用于点击更多之后的初始初始设定
@end


@implementation MoreClickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pagesize = 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -出入设置
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden == YES){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
   self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}

#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.moreClickVM.rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCategoryIdetify];
    
    [cell.coverBtn setImageForState:UIControlStateNormal withURL:[self.moreClickVM coverURLForTag:indexPath.row] placeholderImage:[UIImage imageNamed:@"find_albumcell_cover_bg"]];
    
    cell.titleLb.text = [self.moreClickVM titleForTag:indexPath.row];
    cell.introLb.text = [self.moreClickVM subTitleForTag:indexPath.row];
    cell.playsLb.text = [self.moreClickVM playsForTag:indexPath.row];
    cell.tracksLb.text = [self.moreClickVM tracksForTag:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 从本控制器VM获取头标题, 以及分类ID回初始化
    SongAlbumViewController *vc = [[SongAlbumViewController alloc] initWithAlbumId:[self.moreClickVM albumIdForTag:indexPath.row] title:[self.moreClickVM titleForTag:indexPath.row]];
    
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:vc animated:YES];
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
            [self.moreClickVM refreshDataCompletionHandle:^(NSError *error) {
                NSLog(@"点击更多之后请求数据完成");
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
    
    if (self.moreClickVM.rowNumber < 20) {
        //这个按照这种写法永远都不会执行了都
    }else{
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.moreClickVM getMoreDataCompletionHandle:^(NSError *error) {
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
    
    if (self.moreClickVM.rowNumber % 10) {
        _tableView.mj_footer = nil;
    }
}

#pragma mark - 懒加载方法VM
-(MoreClickViewModel *)moreClickVM{
    if(!_moreClickVM){
        _moreClickVM = [[MoreClickViewModel alloc] initWithPagesize:self.pagesize];
    }
    return _moreClickVM;
}


@end
