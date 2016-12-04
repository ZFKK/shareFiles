//
//  HomePageController.m
//  Music
//
//  Created by sunkai on 16/11/4.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "HomePageController.h"
#import "LeftView.h"
//左侧视图
#import "PlayMusicManager.h"
#import "HomePageCell.h"

#import "ContentViewModel.h"
//请求数据来填充
#import "TrackViewModel.h"
//专辑VM

#import "PlayMusicManager.h"
//播放

#import "sys/utsname.h"
#include <sys/sysctl.h>
#include <sys/types.h>
//上边的三个都是用于检测平台的

#import "WebViewController.h"
//跳转的网页
#import "MyProfileViewController.h"
//用于收藏和播放记录


@interface HomePageController ()<leftDelegate,HomeTableViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
     CGPoint initialPosition;
     //初始位置,暂时不知道是谁的位置？？？
}

@property(nonatomic,strong)LeftView *leftView;
@property(nonatomic,strong)UIView *backView;//蒙版
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic) NSInteger tableInteger;
//TODO:-1.这个是用来做什么的？？？用来保存上一个播放的cell的tag
@property (nonatomic) NSInteger playInteger;
//播放的tag,应该是当前的
@property(nonatomic)UIScreenEdgePanGestureRecognizer *pan;
//之前看的资料中，显示这个类型，实质上和Uinavigation中的手势一样，也就是左侧滑动的手势
//导航视图中存在一个手势交互属性interactivePopGestureRecognizer
@property (nonatomic,strong) ContentViewModel *contentVM;
//请求数据，给cell填充

@property (nonatomic,strong)MyProfileViewController *dataVC;
@property (nonatomic,assign)Mode mode;
//用于区分是收藏还是记录

@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    [self initNav];
    [self initMainTableView];
    [self addGestureRecognizer];
    //通过VM来获取数据，并把数据绑定给model，接着再交给VC
    [self.contentVM getDataCompletionHandle:^(NSError *error) {
        //请求数据完成
        NSLog(@"主页的VC请求数据完成");
        [self.mainTableView reloadData];
    }];
    [self.mainTableView reloadData];
    
    //测试一下检测平台
//    NSString *jiance = [[PlayMusicManager sharedInstance] iPhoneSysctlOne];
//    NSLog(@"当前平台是%@",jiance);
}

//导航初始化
-(void)initNav{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    //自定义view来添加title
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 40)];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2-40, 0, 100, 44)];
    navTitle.text = @"希亚Music";
    navTitle.font = [UIFont fontWithName:@".SFUIText-Semibold" size:18];
    [view addSubview:navTitle];
    self.navigationItem.titleView = view;
    
    //设置左侧的返回按键
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    self.navigationController.navigationBar.translucent = NO;//是否为半透明
}

//表格和上下刷新
-(void)initMainTableView{
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 29) style:UITableViewStyleGrouped];
    
    [self.mainTableView pm_RefreshHeaderWithBlock:^{
        [self.contentVM getDataCompletionHandle:^(NSError *error) {
            [self.mainTableView reloadData];
            [self.mainTableView endRefresh];
        }];
    }];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.mainTableView registerClass:[HomePageCell class] forCellReuseIdentifier:@"Homepagecell"];
    [self.view addSubview:self.mainTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delTableInteger:) name:kNotificationOfMusicTableInteger object:nil];

}

//TODO:-0.暂时不知道做什么用的
-(void)delTableInteger:(NSNotification *)notification{
    
    _tableInteger = 0;
    
    if (_playInteger > 0) {
        NSIndexSet *tableIndexSet=[[NSIndexSet alloc]initWithIndex:_playInteger - 1];
        [self.mainTableView reloadSections:tableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        //局部刷新
    }
    _playInteger = 0;
    //根据点击的某个cell，只是进行刷新这个单元
}

#pragma mark tableview 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.contentVM rowNumber];
    //返回VM的总行数
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
    //按照这种写法，一个音乐就是一个section
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenWidth * 1.2;
}

//组头高，也就是相邻两个专辑之间的间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0.00001;
    }else{
        return 10;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Homepagecell"];
    [cell.coverIV sd_setImageWithURL:[self.contentVM coverURLForRow:indexPath.section] placeholderImage:[UIImage imageNamed:@"album_cover_bg"]];
    //TODO:-2.这里暂且设置固定的字符串
    cell.titleLb.text =  [self.contentVM trackTitleForRow:indexPath.section];
    cell.tagInt = indexPath.section;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //TODO:-6.没看懂,这里的tableInteger，不过是在主VC的代理方法中进行变换，也就是下边的方法
    if (indexPath.section == _tableInteger-1) {
        cell.isPlay = YES;
    }else{
        cell.isPlay = NO;
    }
    return cell;
}

#pragma mark cell的代理方法，这里取消了本身tableview的点击方法,但是还是灭有看明白？？？
-(void)HomeTableViewDidClick:(NSInteger)tag{
    if (tag >= 2000){ //表明点击的是按钮，而不是cell本身
        NSInteger tableTag = tag - 2000; //获取当前的Button
        NSInteger oldtableTag = _tableInteger;//获取前一个cell，也就是之前点击的那个cell
        if (_tableInteger == tableTag + 1) {
            _tableInteger = 0;
            [[PlayMusicManager sharedInstance] pauseMusic];
            //表明点击的是同一个？
        }else{
            _tableInteger = tableTag + 1;
            if (_playInteger == tableTag + 1) {
                [[PlayMusicManager sharedInstance] pauseMusic];
            }else{
                TrackViewModel *model = [[TrackViewModel alloc] initWithAlbumId:[self.contentVM albumIdForRow:tableTag] title:[self.contentVM titleForRow:tableTag] isAsc:YES];
                [model getDataCompletionHandle:^(NSError *error) {
                    //获取开始播放的必要参数
                    // 当前播放信息
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[@"coverURL"] = [model coverURLForRow:tableTag];
                    userInfo[@"musicURL"] = [model playURLForRow:tableTag];
                    
                    NSInteger indexPathRow = tableTag;
                    NSNumber *indexPathRown = [[NSNumber alloc]initWithInteger:indexPathRow];
                    userInfo[@"indexPathRow"] = indexPathRown;
                    //专辑
                    userInfo[@"theSong"] = model;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMusicStartPlay object:nil userInfo:[userInfo copy]];
                }];
            }
            _playInteger = tableTag + 1;
        }
        NSIndexSet *tableIndexSet=[[NSIndexSet alloc]initWithIndex:tableTag];
        [self.mainTableView reloadSections:tableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];//局部刷新
        if (oldtableTag > 0) {
            NSIndexSet *tableIndexSet=[[NSIndexSet alloc]initWithIndex:oldtableTag - 1];
            [self.mainTableView reloadSections:tableIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];//局部刷新
        }
//        NSLog(@"当前的tabletag是%ld",tableTag);

    }else{
        //这里的话，感觉没有必要再取出来tag，因为跳转的weburl都是一样的
//        self.hidesBottomBarWhenPushed = YES;
        NSInteger tableTag = tag - 1000;
        WebViewController *web = [[WebViewController alloc] init];
        NSURL *url = [self.contentVM urlForRow:tableTag];
        web.URL = url;
        [self.navigationController pushViewController:web animated:YES];
        
    }
}

#pragma mark 重写手势
-(void)addGestureRecognizer{
    //TODO:-3.这里暂且不管这个手势方法
    self.pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    self.pan.delegate = self;
    self.pan.edges = UIRectEdgeLeft;//左侧
    [self.view addGestureRecognizer:self.pan];
}

#pragma mark 懒加载初始化视图
-(LeftView *)leftView{
    if (!_leftView) {
        _leftView = [[LeftView alloc]initWithFrame:CGRectMake(-HomePagemaxWidth, 0, HomePagemaxWidth, kScreenHeight)];
        _leftView.delegate = self;//设置代理
    }
    return _leftView;
}

//TODO:-4.但是这里的具体作用还是有点问题，因为本身他的也没调用，相关的下边的方法也是没用到
-(UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        UIPanGestureRecognizer *backPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(backPanGes:)];
        [_backView addGestureRecognizer:backPan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapGes:)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

//TODO:-5.什么时候调用,暂时没有找到
-(void)panGesture:(UIScreenEdgePanGestureRecognizer *)ges{
    
    [self dragLeftView:ges];
}

-(void)dragLeftView:(UIPanGestureRecognizer *)panGes{
    
    [_leftView removeFromSuperview];
    [_backView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backView];
    [window addSubview:self.leftView];
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        
        initialPosition.x = self.leftView.center.x;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    }
    
    CGPoint point = [panGes translationInView:self.view];
    
    if (point.x >= 0 && point.x <= HomePagemaxWidth) {
        _leftView.center = CGPointMake(initialPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (HomePagemaxWidth + point.x) / (2* HomePagemaxWidth) - 0.5);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (panGes.state == UIGestureRecognizerStateEnded){
        if (point.x <= HomePageshowLeftViewMaxWidth) {
            //小于10，重新退回去
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-HomePagemaxWidth, 0, HomePagemaxWidth, kScreenHeight);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];
            
        }else if (point.x > HomePageshowLeftViewMaxWidth && point.x <= HomePagemaxWidth){
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, HomePagemaxWidth, kScreenHeight);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

//TODO:-7.自己的这个方法也是灭有用到
-(void)backPanGes:(UIPanGestureRecognizer *)ges{
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        
        initialPosition.x = self.leftView.center.x;
    }
    
    CGPoint point = [ges translationInView:self.view];
    
    if (point.x <= 0 && point.x <= HomePagemaxWidth) {
        _leftView.center = CGPointMake(initialPosition.x + point.x , _leftView.center.y);
        CGFloat alpha = MIN(0.5, (HomePagemaxWidth + point.x) / (2* HomePagemaxWidth));
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded){
        
        if ( -point.x <= 50) {
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(0, 0, HomePagemaxWidth, kScreenHeight);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            } completion:^(BOOL finished) {
                
            }];
            
        }else {
            
            [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _leftView.frame = CGRectMake(-HomePagemaxWidth, 0, HomePagemaxWidth, kScreenHeight);
                _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];
        }
    }
    
}

-(void)backViewTapGes:(UITapGestureRecognizer *)ges{
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _leftView.frame = CGRectMake(-HomePagemaxWidth, 0, HomePagemaxWidth, kScreenHeight);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        self.pan.enabled = YES;
        [_backView removeFromSuperview];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
    
}

#pragma mark --测试一下viewWillAppear 
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"视图将会出现");
}

#pragma mark  懒加载
-(ContentViewModel *)contentVM{
    if (_contentVM == nil){
        _contentVM = [[ContentViewModel alloc] init];
    }
    return _contentVM;
}

-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"主页销毁");
}

#pragma mark -左侧的代理方法
- (void)jumpWebVC:(NSURL *)url{
    WebViewController *web0 = [[WebViewController alloc]init];
    web0.URL = url;
    [self.navigationController pushViewController:web0 animated:YES];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _leftView.frame = CGRectMake(-HomePagemaxWidth, 0, HomePagemaxWidth, kScreenHeight);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        self.pan.enabled = YES;
        [_backView removeFromSuperview];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
}

-(void)jumpDataVC:(Mode)mode{
    //需要首先移除左侧视图
    [_leftView removeFromSuperview];
    [_backView removeFromSuperview];
     //这里要区分是收藏还是历史记录
    switch (mode) {
        case HistoryMode:
            //暂时这样来写
            self.mode = HistoryMode;
           [self.navigationController pushViewController:[[MyProfileViewController alloc] initWithMode:self.mode] animated:YES];
            break;
        case FavoriteMode:
            self.mode = FavoriteMode;
            [self.navigationController pushViewController:[[MyProfileViewController alloc] initWithMode:self.mode] animated:YES];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
