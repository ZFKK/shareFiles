//
//  MyProfileViewController.m
//  Music
//
//  Created by sunkai on 16/11/8.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MusicDetailCell.h"
//cell
#import "PlayMusicManager.h"
//音乐播放
#import "TrackViewModel.h"
//专辑VM
#import "HistoryItem.h"
#import "FavoriteItem.h"
//coredata的数据模型


@interface MyProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic,strong) TrackViewModel *tracksVM;
@property (nonatomic,strong) NSArray *HistoryItems;
@property (nonatomic,strong) NSArray *FavoriteItems;


@end

@implementation MyProfileViewController{
    CGFloat _viewY;
}

-(instancetype)initWithMode:(Mode)mode{
    if (self == [super init]){
        _mymode = mode;
    }
    return  self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    [self initNav];
    [self initMainTableView];
}
#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (_mymode == 0) {
        _HistoryItems = [[PlayMusicManager sharedInstance] historyMusicItems];
    }else{
        _FavoriteItems = [[PlayMusicManager sharedInstance] favoriteMusicItems];
    }

    [self.tracksVM getItemModelData:^(NSError *error) {
        //这里就是请求获取所有之前已经添加到数组中的所有model
        [self.mainTableView reloadData];
    }];
    [self.mainTableView reloadData];
    //TODO:-1.这里还要进行刷新？？？
}



- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

#pragma mark -导航设置
- (void)initNav{
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if (_mymode == 0) {
        self.navigationItem.title = @"历史音乐";
    }else if(_mymode == 1){
        self.navigationItem.title = @"收藏音乐";
    }
    
    //设置右侧的清空Buttonitem
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];
    rightButton.title = @"清空";
    self.navigationItem.rightBarButtonItem = rightButton;
    rightButton.target = self;
    rightButton.action = @selector(delAll);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    
}

#pragma mark -清空数据
- (void)delAll{
    if (_mymode == 0) {
        
        [[PlayMusicManager sharedInstance] delAllHistoryMusic];
        [self.tracksVM getItemModelData:^(NSError *error) {
            [self.mainTableView reloadData];
        }];
        [self.mainTableView reloadData];
        
    }else if(_mymode == 1){
        [[PlayMusicManager sharedInstance] delAllFavoriteMusic];
        [self.tracksVM getItemModelData:^(NSError *error) {
            [self.mainTableView reloadData];
        }];
        [self.mainTableView reloadData];
    }
}
#pragma mark -表格视图
-(void)initMainTableView{
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [_mainTableView registerClass:[MusicDetailCell class] forCellReuseIdentifier:MusicDetailIdentify];
    _mainTableView.rowHeight = 80;
    [self.view addSubview:self.mainTableView];

}

#pragma mark - 懒加载
-(TrackViewModel *)tracksVM{
    if (!_tracksVM){
        _tracksVM = [[TrackViewModel alloc] initWithitemModel:self.mymode];
        //MARK:-1.这位兄弟想的还是蛮多的，根据模型的类型来创建实例
    }
    return _tracksVM;
}


//TODO:-1. 连带滚动方法，但是为何要写这个方法呢？？？
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _viewY = scrollView.contentOffset.y;
}

#pragma mark - UITableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracksVM.rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicDetailIdentify];
    
    [cell.coverIV sd_setImageWithURL:[self.tracksVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"dfxnnxf "]];
    
    cell.titleLb.text = [self.tracksVM titleForRow:indexPath.row];
    cell.sourceLb.text = [self.tracksVM nickNameForRow:indexPath.row];
    cell.updateTimeLb.text = [self.tracksVM updateTimeForRow:indexPath.row];
    cell.playCountLb.text = [self.tracksVM playsCountForRow:indexPath.row];
    cell.durationLb.text = [self.tracksVM playTimeForRow:indexPath.row];
    cell.favorCountLb.text = [self.tracksVM favorCountForRow:indexPath.row];
    cell.commentCountLb.text = [self.tracksVM commentCountForRow:indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果申请删除操作
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        if (_mymode == 0) {
            
            NSDictionary *track = [self.tracksVM trackForRow:indexPath.row];
            [[PlayMusicManager sharedInstance] delMyHistoryMusic:track];
            _HistoryItems = [[PlayMusicManager sharedInstance] historyMusicItems];
            [self.mainTableView reloadData];
            
        }else {
            NSDictionary *track = [self.tracksVM trackForRow:indexPath.row];
            [[PlayMusicManager sharedInstance] delMyFavoriteMusicDictionary:track];
        }
        
        [self.tracksVM getItemModelData:^(NSError *error) {
        }];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


//删除提示文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
    if(_mymode == 1){
        NSString *deltext = @"清除";
        return deltext;
    }
    NSString *deltext = @"删除";
    return deltext;
}

//设置禁止删除,每次设置时候调用
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 当前播放信息
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:indexPath.row];
    userInfo[@"musicURL"] = [self.tracksVM playURLForRow:indexPath.row];
    
    //位置
    CGFloat origin = indexPath.row*80 -_viewY-80;
    NSNumber *originy = [[NSNumber alloc]initWithFloat:origin];
    userInfo[@"originy"] = originy;
    
    //专辑
    if (_mymode == 0) {
        
        HistoryItem   *historyItem = _HistoryItems[indexPath.row];
        TrackViewModel *tracks = [[TrackViewModel alloc] initWithAlbumId:[_tracksVM albumIdForRow:indexPath.row] title:historyItem.albumTitle isAsc:YES];
        [tracks getDataCompletionHandle:^(NSError *error)  {
            userInfo[@"theSong"] = tracks;
            
            NSNumber *musicRow = [[NSNumber alloc]initWithInteger:historyItem.musicRow];
            userInfo[@"indexPathRow"] = musicRow;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMusicBeginPlay object:nil userInfo:[userInfo copy]];
        }];
        //表明这里点击之后，和专辑页面中的一样，都是可以正常播放的
        
    }
    if (_mymode == 1) {
        
        TrackViewModel *tracks = [[TrackViewModel alloc] initWithitemModel:FavoriteModel];
        [tracks getItemModelData:^(NSError *error) {}];
        userInfo[@"theSong"] = tracks;
        
        NSInteger indexPathRow = indexPath.row;
        NSNumber *indexPathRown = [[NSNumber alloc]initWithInteger:indexPathRow];
        userInfo[@"indexPathRow"] = indexPathRown;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMusicBeginPlay object:nil userInfo:[userInfo copy]];
    }
}


@end
