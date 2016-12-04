//
//  TabBarBaseController.m
//  Music
//
//  Created by sunkai on 16/11/4.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "TabBarBaseController.h"
#import "HomePageController.h"
#import "RecommendController.h"
#import "MainPlayController.h"
//子控制器

#import "PlayView.h" 
//播放图标

#import "DimissAnimation.h"
//自定义的过渡动画
#import "PercentDrivenInteractiveAnimation.h"
//控制过渡动画的百分比的对象

#import "PlayMusicManager.h"
//播放管理者

#import "TrackViewModel.h"
//专辑对应的VM

@interface TabBarBaseController ()<UINavigationControllerDelegate,PlayViewDelegate,UIViewControllerTransitioningDelegate>

//创建需要的关联属性
@property (nonatomic,assign) NSInteger indexPathRow;//当前的索引
@property (nonatomic,assign) NSInteger rowNumber;//总共的行数
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic) BOOL isCan; //是否播放
@property (nonatomic,strong) PlayView *playView; //既是右下角的图标
@property (nonatomic,strong) PercentDrivenInteractiveAnimation *interactiveTransition;
@property (nonatomic,strong) TrackViewModel *tracksVM;

@end

@implementation TabBarBaseController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTabBarController];
}


# pragma mark -1.初始化
-(void)initTabBarController{
    //添加子控制器
    HomePageController *home = [[HomePageController alloc] init];
    [self controller:home title:@"主页" image:@"tab_icon_selection_normal" selectedimage:@"tab_icon_selection_highlight"];
    
    RecommendController *recommend = [[RecommendController alloc] init];
    [self controller:recommend title:@"推荐" image:@"icon_tab_shouye_normal" selectedimage:@"icon_tab_shouye_highlight"];
    
    RecommendController *play = [[RecommendController alloc] init];
    [self controller:play title:@"" image:@"" selectedimage:@""];

    //tabbar 的基础设置
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
    
    //初始的时候显示第一个
    [self setSelectedIndex:0];
    
    //在右侧添加播放的按钮
    self.playView = [[PlayView alloc] init];
    self.playView.delegate = self;
//    self.playView.backgroundColor = [UIColor blueColor]; //用于测试是否添加上
    //添加点击之后的代理
    [self.view addSubview:self.playView];
    //布局
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth / 3);
        make.height.mas_equalTo(70);
        make.right.equalTo(self.view).with.offset(0);
    }];
    //播放时候的通知
    [self addNotification];
    

}

//创建子控制器
-(void)controller:(UIViewController *)TS title:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage{
    
    TS.tabBarItem.title = title;
    if ([image isEqualToString:@""]){
        //不处理
    }else{
        TS.tabBarItem.image = [UIImage imageNamed:image];
        TS.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //设置点击之后的图片
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:TS];
    na.delegate = self;
    //添加导航控制器到子控制器数组
    [self addChildViewController:na];
}



#pragma mark -2.添加播放通知
-(void)addNotification{
    // 控制PlayView样式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPausePlayView:) name:kNotificationOfMusicPause object:nil];
    // 开启一个通知接受,开始播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingWithInfoDictionary:) name:kNotificationOfMusicBeginPlay object:nil];//这个是针对专辑中点击某一个，这里会出现点击之后的动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingInfoDictionary:) name:kNotificationOfMusicStartPlay object:nil];//这个是针对首页中点击某一个，同样的，首页中也会出现简单的动画，但是和上边不一样
    //当前歌曲改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCoverURL:) name:kNotificationOfMusicChangeUrl object:nil];
}


#pragma mark -3.playview的代理方法
-(void)PlayViewClick:(NSInteger)index{
    if ([[PlayMusicManager sharedInstance] playerStatus]){
        //表明已经准备好了
        //接着就会跳转到播放的主界面
        MainPlayController *mainPlayVc = [[MainPlayController alloc] initWithNibName:@"MainPlayController" bundle:nil];
        [self presentViewController:mainPlayVc animated:YES completion:nil];
        //模态跳转
    }else{
        if ([[PlayMusicManager sharedInstance] havePlay]){
            [self showMiddleHint:@"别急，正在加载中..."];
        }else{
            [self showMiddleHint:@"Sorry,没有加载歌曲呢"];
        }
    }
    
}


#pragma mark -4.导航栏的代理方法
//TODO:-7.但是自己这里注释掉，并没有影响整个过程
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.hidesBottomBarWhenPushed){
        //这里实际上就是动态的隐藏下边的tabbar
        if(self.tabBar.frame.origin.y == kScreenHeight - 49){
            [UIView animateWithDuration:0.2 animations:^{
                CGRect tabframe = self.tabBar.frame;
                tabframe.origin.y = [[UIScreen mainScreen] bounds].size.height;
                self.tabBar.frame = tabframe;
            }];
            self.tabBar.hidden = YES;
        }
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.hidesBottomBarWhenPushed){
        
    }else{
        if (self.tabBar.frame.origin.y == kScreenHeight){
            [UIView animateWithDuration:0.2 animations:^{
                CGRect tabframe = self.tabBar.frame;
                tabframe.origin.y -= 49;
                self.tabBar.frame = tabframe;
            }];
        }
        self.tabBar.hidden = NO;
    }
}


#pragma mark .备用，
//TODO:8.这里似乎没有用到
-(void)hideTabbar{
    self.playView.hidden = YES;
}

-(void)showTabbar{
    self.playView.hidden = NO;
}


#pragma mark -6.通知对应的消息
-(void)setPausePlayView:(NSNotification *)notification{
    if ([[PlayMusicManager sharedInstance] isPlay]) {
        [self.playView setPlayButtonView];
        //正在播放，点击之后，切换为播放的图片，那么Button的背景图片为nil
    }else{
        [self.playView setPauseButtonView];
    }
}
/** 通过播放地址 和 播放图片 */
-(void)playingWithInfoDictionary:(NSNotification *)notification{
     if (!_isCan) {
         _isCan = YES;
          [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfMusicTableInteger object:nil userInfo:nil];
        //TODO: -2.这里是表示点击了具体哪一列？？？
         // 设置背景图
         NSURL *coverURL = notification.userInfo[@"coverURL"];
         //通知的具体消息,这里会用到具体的viewsModel
        //TODO: -3.这里的VM还是需要自己理解
         self.tracksVM = notification.userInfo[@"theSong"];
         self.indexPathRow = [notification.userInfo[@"indexPathRow"] integerValue];
         self.rowNumber = self.tracksVM.rowNumber; //专辑中歌曲总数
         [self.playView setPlayButtonView];
         
         //下边是点击之后，音乐的头像会有一个轨迹动画，包含透明度和缩放，同时右下角的views，也会出现一个类似闪烁的动画
         CGFloat y = [notification.userInfo[@"originy"] floatValue];
         CGRect rect = CGRectMake(10, y + 80, 50, 50);
         
         //这里因为每个cell的高是80，可能是在其他地方，这个index计算不一样，所以需要加上一个cell的高
         CGFloat moveX = kScreenWidth - 68;
         CGFloat moveY = kScreenHeight - rect.origin.y - 60;
         
         //转换成毫秒,获取一天内的某个随机时刻
         NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970]*1000;
         NSInteger imTag = (long)nowTime%(3600000*24);
         
         //这个图片是专门进行操作动画的
         UIImageView * sImgView = [[UIImageView alloc]initWithFrame:rect];
         sImgView.tag = imTag;
         //TODO:-4.这里为何要设置一个tag？？？
         [sImgView sd_setImageWithURL:coverURL];
         //和专辑图片一致
         [self.view addSubview:sImgView];
         sImgView.layer.cornerRadius = 22;
         sImgView.clipsToBounds = YES;
         
         //组动画的创建
         CABasicAnimation * alphaBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
         alphaBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
         alphaBaseAnimation.duration = moveX/800; //动画时长和屏幕宽度成线性关系
         alphaBaseAnimation.removedOnCompletion = NO;
         [alphaBaseAnimation setToValue:[NSNumber numberWithFloat:0.0]];
         alphaBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
         //决定动画的变化节奏
         //组动画之缩放动画
         CABasicAnimation * scaleBaseAnimation = [CABasicAnimation animation];
         scaleBaseAnimation.removedOnCompletion = NO;
         scaleBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
         scaleBaseAnimation.duration = moveX/800;
         scaleBaseAnimation.keyPath = @"transform.scale";
         scaleBaseAnimation.toValue = @0.3;
         
         //组动画之路径变化
         CGMutablePathRef path = CGPathCreateMutable();//创建一个路径
         CGPathMoveToPoint(path, NULL, sImgView.center.x, sImgView.center.y);
         CGPathAddQuadCurveToPoint(path, NULL, sImgView.center.x+moveX/12, sImgView.center.y-80, sImgView.center.x+moveX/12*2, sImgView.center.y);
         
         CGPathAddLineToPoint(path,NULL,sImgView.center.x+moveX/12*4,sImgView.center.y+moveY/8);
         
         CGPathAddLineToPoint(path,NULL,sImgView.center.x+moveX/12*6,sImgView.center.y+moveY/8*3);
         
         CGPathAddLineToPoint(path,NULL,sImgView.center.x+moveX,sImgView.center.y+moveY);
         
         
         CAKeyframeAnimation * frameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
         
         frameAnimation.duration = 5*moveX/800;
         
         frameAnimation.removedOnCompletion = NO;
         frameAnimation.fillMode = kCAFillModeForwards;
         
         [frameAnimation setPath:path];
         CFRelease(path);
         
         //TODO:-5.这个动画轨迹似乎有点奇怪
         
         CAAnimationGroup *animGroup = [CAAnimationGroup animation];
         
         animGroup.animations = @[alphaBaseAnimation,scaleBaseAnimation,frameAnimation];
         animGroup.duration = moveX/800;
         animGroup.fillMode = kCAFillModeForwards;//不恢复原态
         animGroup.removedOnCompletion = NO;
         [sImgView.layer addAnimation:animGroup forKey:[NSString stringWithFormat:@"%ld",(long)imTag]];
         //难道还要根据tag值来进行清除动画？？？
         
         NSDictionary * dic = @{
                                @"animationGroup":sImgView,
                                @"coverURL":coverURL,
                                };
         
         
         NSTimer * t = [NSTimer scheduledTimerWithTimeInterval:animGroup.duration target:self selector:@selector(endPlayImgView:) userInfo:dic repeats:NO];
         //这里还是第一次碰到，计时器中穿过去参数，
         [[NSRunLoop currentRunLoop]addTimer:t forMode:NSRunLoopCommonModes];
         //一定要放到commonModes中

     }
    
}

//动画执行过程中
-(void)endPlayImgView:(NSTimer *)timer{
    //取出点击的专辑图片,实际上，也就是动画执行完之后，才把播放的背景图片进行了更改
     UIImageView * imgView = (UIImageView *)[timer.userInfo objectForKey:@"animationGroup"];
    if (imgView) {
        [imgView removeFromSuperview];
        imgView = nil;
    }
    
    // 设置背景图
    NSURL *coverURL = timer.userInfo[@"coverURL"];
    [self.playView.contentIV sd_setImageWithURL:coverURL];
     self.playView.contentIV.alpha = 0.0;
    //修改透明度
    CABasicAnimation * alphaBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    alphaBaseAnimation.duration = 1.0;
    alphaBaseAnimation.removedOnCompletion = NO;
    [alphaBaseAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    alphaBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //决定动画的变化节奏
    [self.playView.contentIV.layer addAnimation:alphaBaseAnimation forKey:[NSString stringWithFormat:@"%ld",(long)self.playView.contentIV]];
    //TODO:-6.这个contentIV怎么是ld类型的？？？
    
    PlayMusicManager *playmanager = [PlayMusicManager sharedInstance];
    [playmanager playWithModel:_tracksVM indexPathRow:_indexPathRow];
    //装载专辑中的某一首歌曲
    
    _isCan = NO;
    // 远程控制事件 Remote Control Event
    // 加速计事件 Motion Event
    // 触摸事件 Touch Event
    // 开始监听远程控制事件
    // 成为第一响应者（必备条件）
    [self becomeFirstResponder];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}

//这个方法里的东西完全和上边中的一致
-(void)playingInfoDictionary:(NSNotification *)notification{
    
    _tracksVM = notification.userInfo[@"theSong"];
    _indexPathRow = [notification.userInfo[@"indexPathRow"] integerValue];
    _rowNumber = self.tracksVM.rowNumber;
    
    [self changeCoverWithAnimation:notification];
    
    [self.playView setPlayButtonView];
    
    PlayMusicManager *playmanager = [PlayMusicManager sharedInstance];
    [playmanager playWithModel:_tracksVM indexPathRow:_indexPathRow];
    _isCan = NO;
    // 远程控制事件 Remote Control Event
    // 加速计事件 Motion Event
    // 触摸事件 Touch Event
    // 开始监听远程控制事件
    // 成为第一响应者（必备条件）
    [self becomeFirstResponder];
}

-(void)changeCoverURL:(NSNotification *)notification{
    
     [self changeCoverWithAnimation:notification];
    
}

//发送通知后的公用方法
-(void)changeCoverWithAnimation:(NSNotification *)notification{
    // 设置背景图
    NSURL *coverURL = notification.userInfo[@"coverURL"];
    
    [self.playView.contentIV sd_setImageWithURL:coverURL];
    self.playView.contentIV.alpha = 0.0;
    
    //修改透明度
    CABasicAnimation * alphaBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    alphaBaseAnimation.duration = 1.0;
    alphaBaseAnimation.removedOnCompletion = NO;
    [alphaBaseAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    alphaBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//决定动画的变化节奏
    
    [self.playView.contentIV.layer addAnimation:alphaBaseAnimation forKey:[NSString stringWithFormat:@"%ld",(long)self.playView.contentIV]];
}

#pragma mark -7.自定义的切换视图，或者交互,这里实际上是定义的dismiss的动画,这里和普通的动画是有区别的，这里应该称为动态动画，不过这里似乎只是定义了一个消失的动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这个实际上返回的是一个遵循协议的动画对象
    return [[DimissAnimation alloc] init];
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    //这里返回的是一个用来控制上一个方法返回的动画对象交互的对象
    return (self.interactiveTransition.isInteracting ? self.interactiveTransition : nil);
}
#pragma mark -8.远程事件监控
-(BOOL)canBecomeFirstResponder{
    return YES;
}

//监听远程
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    //    event.type; // 事件类型
    //    event.subtype; // 事件的子类型
    //    UIEventSubtypeRemoteControlPlay                 = 100,
    //    UIEventSubtypeRemoteControlPause                = 101,
    //    UIEventSubtypeRemoteControlStop                 = 102,
    //    UIEventSubtypeRemoteControlTogglePlayPause      = 103,
    //    UIEventSubtypeRemoteControlNextTrack            = 104,
    //    UIEventSubtypeRemoteControlPreviousTrack        = 105,
    //    UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
    //    UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
    //    UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
    //    UIEventSubtypeRemoteControlEndSeekingForward    = 109,

    //这里只是考虑暂停，前一首，以及下一首
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [[PlayMusicManager sharedInstance] pauseMusic];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [[PlayMusicManager sharedInstance] nextMusic];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [[PlayMusicManager sharedInstance] previousMusic];
            
        default:
            break;
    }

}
#pragma mark -9.HUD显示
- (void)showMiddleHint:(NSString *)hint {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    //TODO:-1.这里没有设置偏移的y值
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

#pragma mark -10.移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //同时这里还是需要移除播放器
    [[PlayMusicManager sharedInstance] releasePlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
