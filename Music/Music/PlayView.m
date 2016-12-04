//
//  PlayView.m
//  Music
//
//  Created by sunkai on 16/11/4.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "PlayView.h"

//注意：这里的圆形等都是采用图片来实现的

@implementation PlayView

-(instancetype)init{
    if (self == [super init]){
        UIView *backView = [[UIView alloc]init];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo( kScreenWidth / 3);
            make.height.mas_equalTo(49);
            make.right.equalTo(self).with.offset(0);
            
        }];
        
        //布局
        //下边添加上两个imageview和一个uibutton
        UIImageView *backgoundIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_np_normal"]];
        [self addSubview:backgoundIV];
        [backgoundIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(70);
            make.right.equalTo(self).with.offset(0);
            
        }];
        
        _circleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_loading_n_p"]];
        [backgoundIV addSubview:_circleIV];
        [_circleIV mas_makeConstraints:^(MASConstraintMaker *make){
            
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(70);
            make.right.equalTo(self).with.offset(0);
            
        }];
        
        //TODO:-1.既然添加了Button，同时还添加手势，为何要添加这么多？？？难道是为了避免没有点击到Button，而是点击了后边的视图？？？
        [self.playButton setImage:[UIImage imageNamed:@"tabbar_np_play"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBackView:)];
        _circleIV.tag = 100;
        [_circleIV addGestureRecognizer:tap];
        
        // 设置circle的用户交互
        backgoundIV.userInteractionEnabled = YES;
        _circleIV.userInteractionEnabled = YES;
    }
    return self ;
}

//点击中间的Button
-(void)touchPlayButton:(UIButton *)sender{
    int tag = (int)sender.tag-100;
    [self.delegate PlayViewClick:tag];
}

//点击Button后边的视图
-(void)OnTapBackView:(UITapGestureRecognizer *)gesture{
    UIView *backView = (UIView *)gesture.view;
    int tag = (int)backView.tag-100;
    [self.delegate PlayViewClick:tag];
}
#pragma mark - 圆形图案内部的显示内容，主要区分是播放还是暂停
-(UIImageView *)contentIV{
    if (!_contentIV) {
        // 声明一个内容视图, 并约束好位置
        _contentIV = [[UIImageView alloc] init];
        // 绑定到圆视图
        [_circleIV addSubview:_contentIV];
        [_contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(7.8, 7.8, 7.8, 7.8));
        }];
        // KVO观察image变化, 变化了就初始化定时器, 值变化则执行task, BlockKit框架对通知的一个拓展
        [_contentIV bk_addObserverForKeyPath:@"image" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
            //TODO:2. 启动定时器,这里有用到了另外一个第三方BlocksKit
        }];
        // 作圆内容视图背景
        _contentIV.layer.cornerRadius = 22;
        _contentIV.clipsToBounds = YES;
        _contentIV.layer.masksToBounds = YES;
    }
    return  _contentIV;
}

-(UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setHighlighted:NO];// 去掉长按高亮
        _playButton.tag = 101;
        [self  addSubview:_playButton];
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(70);
        }];
    }
    
    return _playButton;
}

//显示为播放
- (void) setPlayButtonView{
    [self.playButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.playButton setImage:nil forState:UIControlStateNormal];
}

//显示为暂停
- (void) setPauseButtonView{
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"avatar_bg"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"toolbar_play_h_p"] forState:UIControlStateNormal];

}


@end
