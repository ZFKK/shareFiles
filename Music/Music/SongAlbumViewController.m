//
//  SongAlbumViewController.m
//  Music
//
//  Created by sunkai on 16/11/8.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "SongAlbumViewController.h"
#import "MusicDetailCell.h"
//音乐详情cell

#import "AlbumHeadView.h"
//综合的头视图

#import "TrackViewModel.h"
//整个页面用到的VM模型

@interface SongAlbumViewController()<UITableViewDelegate,UITableViewDataSource,HeaderViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) AlbumHeadView  *infoView; //这个是用于最上边的header
@property (nonatomic,strong) TrackViewModel *tracksVM;

// 升序降序标签: 默认升序
@property (nonatomic,assign) BOOL isAsc;

@end

@implementation SongAlbumViewController{
     CGFloat _viewY;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    //注意：这里一定要把tableview的添加放在前边
    [self initHeaderView];
}

- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)oTitle {
    if (self = [super init]) {
        _albumId = albumId;
        _oTitle = oTitle;
        
    }
    return self;
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
    //这里隐藏，在前一个页面需要自己，判断，然后重新设置一下，是否需要显示
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

#pragma mark -最上header视图的创建
-(void)initHeaderView{
    _infoView = [[AlbumHeadView alloc] initWithFrame:CGRectMake(0, -kScreenWidth*0.6 - 20, kScreenWidth, kScreenWidth*0.6 )];
    _infoView.delegete = self;
    [self.tableView addSubview:_infoView];
    //MARK:-3.注意这里的设置frame，就是把infoview添加到了tableview的上部，不过不是headerview，但是上边的frame设定总是
      //很奇怪
    

    //关于在跳转到具体详情的时候，这个又算是重新进行了请求？？？
    [self.tracksVM getDataCompletionHandle:^(NSError *error) {
        [self.tableView reloadData];
        // 刷新成功时候才作的方法
        // 顶头标题
        _infoView.title.text = self.tracksVM.albumTitle;

        //背景图
        [_infoView sd_setImageWithURL:self.tracksVM.albumCoverLargeURL];

        [_infoView.picView.coverView sd_setImageWithURL:self.tracksVM.albumCoverURL];
        
        // cover上的播放次数
        if (![self.tracksVM.albumPlays isEqualToString:@"0"]) {
            [_infoView.picView.playCountBtn setTitle:self.tracksVM.albumPlays forState:UIControlStateNormal];
        } else {
            _infoView.picView.playCountBtn.hidden = YES;
        }
        
        // 昵称及头像
        _infoView.nameView.name.text = self.tracksVM.albumNickName;
        [_infoView.nameView.icon sd_setImageWithURL:self.tracksVM.albumIconURL];
        
        //判断?成功返回值:失败返回值
        _infoView.descView.descLb.text = self.tracksVM.albumDesc.length == 0 ? @"暂无简介": self.tracksVM.albumDesc  ;
        [_infoView setupTagsBtnWithTagNames:self.tracksVM.tagsName];
        
        NSLog(@"感觉这里就不应该在重新请求，因为之前的应该存在了model中，这里暂时这样，表示音乐详情数据请求完成");
    }];

}

#pragma mark - 基本的懒加载
- (TrackViewModel *)tracksVM {
    if (!_tracksVM) {
        _tracksVM = [[TrackViewModel alloc] initWithAlbumId:_albumId title:_oTitle isAsc:!_isAsc];
    }
    return _tracksVM;
}

-(UITableView *)tableView{
    if (!_tableView) {
        // iOS7的状态栏（status bar）不再占用单独的20px, 所以要设置往下20px
        CGRect frame = self.view.bounds;
        //frame.origin.y += 20;
        // 设置普通模式
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        //MARK:-2.实现了一个下拉刷新的时候顶部footer的停留,预留了0.6的屏幕宽的空间
        _tableView.contentInset = UIEdgeInsetsMake(kScreenWidth*0.6, 0, 0, 0);
        
        [self.view addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[MusicDetailCell class] forCellReuseIdentifier:MusicDetailIdentify];
        
        //行高是80
        _tableView.rowHeight = 80;
        
    }
    return _tableView;

}

#pragma mark -scrollView的代理方法,主要是为了服务上部的视图
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _viewY = scrollView.contentOffset.y;

    if (_viewY < - kScreenWidth*0.6 ){
        //表示是往下拉
        
        CGRect frame = _infoView.frame;
        frame.origin.y = _viewY;
        frame.size.height = -_viewY;
        //这里可以这样认为，就是在tableview的上边留出一段空间，也就是出现一个edge，此时添加的位置就是负数，越往下数值
        
        _infoView.frame = frame;
        _infoView.visualEffectFrame = frame;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        _tableView.frame = self.view.bounds;
    }else{
        //TODO:-3.这里是什么作用呢...???
        //表示是往上推，但是这个rownumber是计算出来的6？？？下边的20，指的是状态栏的高度，一旦行数大于6，表示一个屏幕显示不下，也就是不需要进行这种类似缩放的效果，另外，显示出状态栏的理由是。。。???,自己觉得不应该，所以暂时不要
        if (self.tracksVM.rowNumber > 6) {
//            CGRect frame = self.view.bounds;
//            frame.origin.y += 20;
//            _tableView.frame = frame;
            
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
//    NSLog(@"变化之后的viewY是%f",_viewY);

}

#pragma mark -上部视图的代理方法
- (void)topLeftButtonDidClick{
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)topRightButtonDidClick{
    [UIView showMiddleHint:@"点击了右侧按钮" toView:self.view];
}
#pragma mark -tableview的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"数据条数是%ld",(long)self.tracksVM.rowNumber);
    return self.tracksVM.rowNumber;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicDetailIdentify];
    [cell.coverIV sd_setImageWithURL:[self.tracksVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"album_cover_bg"]];
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

// 点击行数  实现听歌功能
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 当前播放信息
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:indexPath.row];
    userInfo[@"musicURL"] = [self.tracksVM playURLForRow:indexPath.row];
    //有些地址不能正确显示图片，搞不懂
    //NSLog(@"%@",[self.tracksVM coverURLForRow:indexPath.row]);
    
    //下边的位置主要是为了，点击之后，获取当前的位置，发送播放通知，然后接受之后，执行一个动画，需要初始位置的参数
    //位置
    //TODO:-1.但是这些位置还是要如何计算出来的？？？
    if (_viewY < -kScreenWidth*0.56) {
        CGFloat origin = 190 + indexPath.row*80 - (254 + _viewY);
        NSNumber *originy = [[NSNumber alloc]initWithFloat:origin];
        userInfo[@"originy"] = originy;
    }else{
        CGFloat origin = 190 + indexPath.row*80 - (234 + _viewY);
        NSNumber *originy = [[NSNumber alloc]initWithFloat:origin];
        userInfo[@"originy"] = originy;
    }
    
    
    NSInteger indexPathRow = indexPath.row;
    NSNumber *indexPathRown = [[NSNumber alloc]initWithInteger:indexPathRow];
    userInfo[@"indexPathRow"] = indexPathRown;
    
    //专辑
    userInfo[@"theSong"] = _tracksVM;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMusicBeginPlay object:nil userInfo:[userInfo copy]];
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"song dealloc");
}


@end
