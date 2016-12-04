//
//  ZFBaseViewController.m
//  MVVMTest
//
//  Created by sunkai on 16/12/3.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFBaseViewController.h"

@interface ZFBaseViewController ()

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) BOOL changeStatusBarAnimated;

@end

@implementation ZFBaseViewController

#pragma mark --生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setIsExtendLayout:NO];
    //设定导航栏的不渗透
    [self removeNavgationBarLine];
    [self layoutNavigationBar:ImageNamed(@"navigationBarBG@2x.png") titleColor:black_color titleFont:YC_YAHEI_FONT(18)  leftBarButtonItem:nil rightBarButtonItem:nil];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    self.view.backgroundColor = white_color;
}

#pragma mark --调用alloc的时候，默认会调用下边的方法，但是如果灭有重写，那么调用alloc和allocwithZone的对象可能不是用一个
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    ZFBaseViewController *vc = [super allocWithZone:zone];
    @weakify(vc)
    //当前VC的方法被调用的时候
    [[vc rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        //表明在VC中的didLoad中，执行方法，添加子视图和绑定对应的VM
        @strongify(vc)
        //weak-strong-dance
        [vc ZF_addSubviews];
        [vc ZF_bindViewModel];
    }];
    [[vc rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        @strongify(vc);
        [vc ZF_layoutNavigation];
        [vc ZF_getNewData];
    }];
    return vc;
}

#pragma mark --根据对应的model，来创建VC，子类需要进行重写
-(instancetype)initWithViewModel:(id<BaseViewControllerDelegate>)viewModel{
    self = [super init];
    if (self){
        
    }
    return self;
}
#pragma mark --setter方法，设置导航栏的透明影响
-(void)setIsExtendLayout:(BOOL)isExtendLayout{
    if (!isExtendLayout){
        [self initializeSelfVCSetting];
    }
}

#pragma mark --当前VC的设置
-(void)initializeSelfVCSetting{
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        //这个方法是针对iOS7的
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
    }
    //这个方法是什么作用？？？
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
}

#pragma mark --移除导航栏的下侧横线
-(void)removeNavgationBarLine{
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        //表明一旦进行导航栏的设置，就会进行移除
        NSArray *list=self.navigationController.navigationBar.subviews;
        //_UINavigationBarBackground
        //_UINavigationBarBackIndicatorView
        for (id obj in list) {
            
            if ([obj isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView=(UIImageView *)obj;
                
                NSArray *list2=imageView.subviews;
                
                for (id obj2 in list2) {
                    //_UIBackdropView
                    //UIImageView
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        
                        UIImageView *imageView2=(UIImageView *)obj2;
                        
                        imageView2.hidden=YES;
                        
                    }
                }
            }
        }
    }

}

#pragma mark --修改状态栏的风格以及隐藏与否
-(void)changeStatusBarStyle:(UIStatusBarStyle)statusBarStyle statusBarHidden:(BOOL)statusBarHidden changeStatusBarAnimated:(BOOL)animated{
    self.statusBarStyle = statusBarStyle;
    self.statusBarHidden = statusBarHidden;
    if (animated){
        //状态栏的更新，需要手动进行调用
        [UIView animateWithDuration:0.25 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }else{
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark --隐藏状态栏的动态与否
-(void)hideNavigationBar:(BOOL)isHide animated:(BOOL)animated{
    if (animated){
        [UIView animateWithDuration:0.25 animations:^{
            self.navigationController.navigationBarHidden = isHide;
        }];
    }else{
        self.navigationController.navigationBarHidden = isHide;
    }
}

#pragma mark --导航栏的详细设置
-(void)layoutNavigationBar:(UIImage *)backGroundImage titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont leftBarButtonItem:(UIBarButtonItem *)leftItem rightBarButtonItem:(UIBarButtonItem *)rightItem{
    if(backGroundImage){
        [self.navigationController.navigationBar setBackgroundImage:backGroundImage forBarMetrics:UIBarMetricsDefault];
    }
    if (titleFont && titleColor){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:titleFont,NSForegroundColorAttributeName:titleColor}];
    }else if(titleFont){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:titleFont}];
    }else if (titleColor){
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor}];
    }
    if (leftItem){
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    if (rightItem){
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

#pragma mark --设置系统的状态栏风格
-(UIStatusBarStyle)preferredStatusBarStyle{
    if (self.statusBarStyle) {
        return self.statusBarStyle;
    }else{
        return UIStatusBarStyleLightContent;
    }
}

#pragma mark --设置状态栏的隐藏与否
-(BOOL)prefersStatusBarHidden{
    return self.statusBarHidden;
}

#pragma mark --限制屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
    //只是设置为竖屏
}

-(BOOL)shouldAutorotate{
    return NO;
    //不允许自动旋转
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
#pragma mark --销毁
-(void)dealloc{
    NSLog(@"运行%@,%@",self.class,NSStringFromSelector(_cmd));
}


#pragma mark --代理方法  也就是针对RAC的东西,并且这些方法都是需要子视图来进行重写的,不过这些方法是可选的 
-(void)ZF_getNewData{}

-(void)ZF_addSubviews{}

-(void)ZF_bindViewModel{}

-(void)ZF_layoutNavigation{}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
