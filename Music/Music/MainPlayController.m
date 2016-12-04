//
//  MainPlayController.m
//  Music
//
//  Created by sunkai on 16/11/4.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MainPlayController.h"
#import "PlayMusicManager.h"
#import "MenuView.h"
//这个用于下拉菜单

#import "MyProfileViewController.h"
#import "LeftView.h"
#import "MusicSlider.h"

@interface MainPlayController()<PlayManagerDelegate>

//背景
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

//最上边
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *multiTitleLable;
@property (weak, nonatomic) IBOutlet UIButton *rightMenuButton;

//中心专辑
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContraint;

//收藏部分
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLable;
@property (weak, nonatomic) IBOutlet UILabel *singerNameLable;

//进度条
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLable;
@property (weak, nonatomic) IBOutlet MusicSlider *musicSlider;

//最下边的
@property (weak, nonatomic) IBOutlet UIButton *musicCycleButton;
@property (weak, nonatomic) IBOutlet UIButton *previousMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *musicToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *nextMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (nonatomic) BOOL musicIsPlaying;
@property (nonatomic) BOOL musicIsChange;
@property (nonatomic) BOOL musicIsCan; //做什么用的？？？
@property (nonatomic) BOOL newItem;


@property (nonatomic) PlayMode  cycle;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSTimeInterval total;

@property (nonatomic,strong) PlayMusicManager *playmanager;

@property (nonatomic,strong) MenuView *menuview;

@end

@implementation MainPlayController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self adapterIphone4];
    [self addPanRecognizer];
    //添加轻扫的返回手势
    [self addShimmingView];
}

-(void)addShimmingView{
//    FBShimmeringView *shimmering = [[FBShimmeringView alloc] initWithFrame:_albumNameLable.frame];
//    shimmering.contentView = _albumNameLable;
//    shimmering.shimmering= YES;
//    shimmering.shimmeringOpacity= 0.8;
//    shimmering.shimmeringBeginFadeDuration = 5.0;
//    shimmering.shimmeringEndFadeDuration = 10.0;
//    shimmering.shimmeringSpeed = 100;
//    shimmering.shimmeringHighlightLength = 0.9;
}
#pragma mark - 初始化
/** 调整大小 */
- (void)adapterIphone4 {
    if (s_isPhone4) {
        CGFloat margin = 65;
        _leftContraint.constant = margin;
        _rightContraint.constant = margin;
    }
}

#pragma mark - 往下方轻扫，关闭播放音乐，同时推出当前VC
- (void)addPanRecognizer {
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closePlay:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
}

#pragma mark - 手势和点击公用一个方法
- (IBAction)closePlay:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //初始化UI
    _playmanager = [PlayMusicManager sharedInstance];
    _playmanager.delegate = self;
    _cycle = [_playmanager PlayerCycle];
    switch (_cycle) {
        case SingleCirculate:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            break;
        case SequencePlay:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            break;
        case RandomPlay:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    //判断
     _multiTitleLable.text = [_playmanager playMusicTitle];
    _albumNameLable.text = [_playmanager playMusicName];
    _singerNameLable.text = [_playmanager playSinger];
    
    [self setupBackgroudImage:[_playmanager playCoverLarge]];
    
    [self updateProgressLabelCurrentTime:CMTimeGetSeconds([_playmanager.player.currentItem currentTime]) duration:CMTimeGetSeconds([_playmanager.player.currentItem duration])];
    [self addObserverToPlayer:_playmanager.player];
    
    //上边的类似于添加全局观察以及局部监听的类似，添加独立的监听对象
    if (_playmanager.player.rate) {
        self.musicIsPlaying = YES;
    } else {
        self.musicIsPlaying = NO;
    }
    
    //根据是否收藏，切换图片显示
    if ([_playmanager hasBeenFavoriteMusic]) {
        [_favoriteButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
    } else {
        [_favoriteButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
    }
    
    _newItem = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - 设置背景图片，制作模糊效果
- (void)setupBackgroudImage:(NSURL *)imageUrl {
    _albumImage.layer.cornerRadius = 7;
    _albumImage.layer.masksToBounds = YES;
    
    [_albumImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"dfxnnxf "]];
    //中心图片
    [_backgroundImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"dfxnnxf "]];
    //后边的背景视图
    if(![_visualEffectView isDescendantOfView:_backgroundView]) {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //选择style
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _visualEffectView.frame = CGRectMake(0, 0, kScreenWidth , kScreenHeight);
        [_backgroundView addSubview:_visualEffectView];
    }
    //TODO:-2.执行转场动画？？？先放着
//    [_albumImage StartTransition];
    [_backgroundImageView StartTransition];
    [_backgroundView StartTransition];
}



#pragma mark - 更新时间数据
- (void)updateProgressLabelCurrentTime:(NSTimeInterval )currentTime duration:(NSTimeInterval )duration {
    
    _beginTimeLable.text = [NSString timeIntervalToMMSSFormat:currentTime];
    _endTimeLable.text = [NSString timeIntervalToMMSSFormat:duration];
    
    //TODO:-3.注意这里的cancel
    if (_musicIsCan == YES) {
        
        CGFloat currentTimef = currentTime;
        int currentTimei = currentTime;
        if (currentTimef == currentTimei) {
            _musicIsCan = NO;
        }
    }
    
    //表明音乐灭有切换，同时没有取消，那不就是表明正在播放么
    if (_musicIsChange == NO && _musicIsCan == NO) {
        
        [_musicSlider setValue:currentTime / duration animated:YES];
    }
}

#pragma mark -给AVPlayer添加观察者
-(void)addObserverToPlayer:(AVPlayer *)player{
    //TODO:-4.这里涉及到之前的计时发出通知。。。
    //监听时间变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicTimeInterval:) name:kNotificationOfMusicRemoteControlOfTimeInterval object:nil];
    //[player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//状态
    //[player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];//播放速度
    //[player addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:nil];
    //[player addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];//缓冲
    
    //MARK:-3.上边的注释掉的，是因为在切换歌曲的时候，会重新创建AVPlayer，所有这里采用了通知来替换KVO，实现收藏按钮切换，播放按钮切换，缓冲时间获取，
}

#pragma mark -播放管理者的代理方法，不过做的只是更换音乐显示信息以及背景图片，真正切换音乐的操作都是在playmanager中执行
-(void)changeMusic{
    //下边的是重新获取该张专辑中的另外一首音乐的相关信息
    _multiTitleLable.text = [_playmanager playMusicTitle];
    _albumNameLable.text = [_playmanager playMusicName];
    _singerNameLable.text = [_playmanager playSinger];

    //重新设置背景图片
    [self setupBackgroudImage:[_playmanager playCoverLarge]];
    //添加记录
    [_playmanager setHistoryMusic];
    
    //重新设置是否已经收藏过
    if ([_playmanager hasBeenFavoriteMusic]) {
        [_favoriteButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
    } else {
        [_favoriteButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
    }
    
    _newItem = YES;
}

#pragma mark - y移除观察者
-(void)removeObserverFromPlayer:(AVPlayer *)player{

    //上边的已经注释掉，无需移除
    //只是移除掉其他的
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -监听时间变化
-(void)musicTimeInterval:(NSNotification *)notification{
    
    NSTimeInterval current=CMTimeGetSeconds([_playmanager.player.currentItem currentTime]);

    if (_newItem == YES) {
        //一旦出现这个界面，都是设置为yes
        AVPlayerItem *newItem = self.playmanager.player.currentItem;
        if (!isnan(CMTimeGetSeconds([newItem duration]) )) {
            //验证合法性？？？不是无穷大，也不是无穷小？？
            self.total = CMTimeGetSeconds([newItem duration]);
            
            _newItem = NO;
        }
    }
    
    [self updateProgressLabelCurrentTime:current duration:self.total];

}

#pragma mark -属性的重写
-(void)setMusicIsPlaying:(BOOL)musicIsPlaying{
    _musicIsPlaying = musicIsPlaying;
    if (_musicIsPlaying) {
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
        
    } else {
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
    }
}

#pragma mark -检查是否是收藏的，进行切换图片显示 不过这个方法没有用到
- (void)checkMusicFavoritedIcon {
    if ([_playmanager hasBeenFavoriteMusic]) {
        [_favoriteButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
    } else {
        [_favoriteButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
    }
}

#pragma mark -点击事件
- (IBAction)ToggleMusic:(UIButton *)sender {
    if (_playmanager.player.status == 1) {
        
        //表示可以播放，而不是已经在播放
        [_playmanager pauseMusic];
        [self PostNotificationOfSetPauseViewWithSetPlayingStatus];
      
        
    }else{
        [self showMiddleHint:@"等待加载音乐"];
    }
}
- (IBAction)PreviousMusic:(UIButton *)sender {
    if (_playmanager.player.status == 1) {
        
        [_playmanager previousMusic];
        [self PostNotificationOfSetPauseViewWithSetPlayingStatus];
        
    }else{
        [self showMiddleHint:@"等待加载音乐"];
    }

}
- (IBAction)NextMusic:(UIButton *)sender {
    if (_playmanager.player.status == 1) {
        
        [_playmanager nextMusic];
        
        [self PostNotificationOfSetPauseViewWithSetPlayingStatus];
       
        
    }else{
        [self showMiddleHint:@"等待加载音乐"];
    }

}
- (IBAction)MusicCycle:(UIButton *)sender {
    if (_cycle < 3) {
        _cycle++;
    }else{
        _cycle = 1;
    }
    
    //MARK:-这里把播放模式存储在NSUserdefaults中
    NSNumber *userCycle = [NSNumber numberWithInt:_cycle];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userCycle forKey:@"cycle"];
    
    
    [_playmanager nextCycle];
    //把设定的模式存储到偏好设置里
    
    switch (_cycle) {
        case SingleCirculate:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            [self showMiddleHint:@"单曲循环"];
            break;
        case SequencePlay:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            [self showMiddleHint:@"顺序循环"];
            break;
        case RandomPlay:
            
            [_musicCycleButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            [self showMiddleHint:@"随机循环"];
            break;
            
        default:
            break;
    }

}
- (IBAction)MoreOperation:(UIButton *)sender {
//    [self showMiddleHint:@"更多操作"];
    [self.menuview show];
    //主要指的是添加，删除等操作，之后可以加上
}
- (IBAction)FavouriteMusic:(UIButton *)sender {
    
    [_favoriteButton StartAnimation];
    //这里会执行一个缩放动画
    if ([_playmanager hasBeenFavoriteMusic]) {
        [_playmanager delFavoriteMusic];
        [UIView showMiddleHint:@"取消收藏" toView:self.view];
        [_favoriteButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
    } else {
        [UIView showMiddleHint:@"添加收藏" toView:self.view];
        [_playmanager setFavoriteMusic];
        [_favoriteButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
    }

}
- (IBAction)ChangeIsPlaying:(MusicSlider *)sender {
    _musicIsChange = YES;
}
- (IBAction)ChangeToTime:(MusicSlider *)sender {
    CGFloat endTime = CMTimeGetSeconds([_playmanager.player.currentItem duration]);
    NSInteger dragedSeconds = floorf(sender.value * endTime);

    //转换成CMTime才能给player来控制播放进度
    [_playmanager.player seekToTime:CMTimeMakeWithSeconds(dragedSeconds, 1)];

    _musicIsChange = NO;
    _musicIsCan = YES;
}

#pragma mark - 下拉菜单
-(MenuView *)menuview{
    
    if(!_menuview){
        _menuview = [[MenuView alloc] initWithOrigin:CGPointMake(self.nextMusicButton.frame.origin.x - 80, self.nextMusicButton.frame.origin.y + 270) width:130];
        __weak MainPlayController *weakself = self;
        [_menuview setDidSelectMenuItem:^(MenuView *view, MenuItem *item) {
             __strong  MainPlayController *strongself = weakself;
//            [strongself dismissViewControllerAnimated:YES completion:nil];
            if ([item.title isEqualToString:@"我的收藏"]){
//                [strongself presentViewController:[[MyProfileViewController alloc] initWithMode:FavoriteMode]  animated:YES completion:nil];
//                [strongself.navigationController pushViewController:[[MyProfileViewController alloc] initWithMode:FavoriteMode] animated:YES];
            }
            if ([item.title isEqualToString:@"播放历史"]){
//                [strongself presentViewController:[[MyProfileViewController alloc] initWithMode:HistoryMode] animated:YES completion:nil];
            }
            if ([item.title isEqualToString:@"清理缓存"]){
              
            }
            if ([item.title isEqualToString:@"定时关机"]){
                
            }
        }];
    }
    return _menuview;
}


# pragma mark - HUD

- (void)showMiddleHint:(NSString *)hint {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [UIView showMiddleHint:hint toView:view];
}

#pragma mark -更改播放按钮图片以及设定播放状态
-(void)PostNotificationOfSetPauseViewWithSetPlayingStatus{
    if ([[PlayMusicManager sharedInstance] isPlay]) {
        self.musicIsPlaying = YES;
    }else{
        self.musicIsPlaying = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMusicPause object:nil userInfo:nil];
      //这里的切换图片竟然都是用通知来实现,另外这里通知的是在首页上的播放视图的显示问题
}

#pragma mark -移除
-(void)dealloc{
 
    [self removeObserverFromPlayer:_playmanager.player];
    NSLog(@"主播放界面销毁");
}




@end
