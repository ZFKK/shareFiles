//
//  HomePageCell.m
//  Music
//
//  Created by sunkai on 16/11/5.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "HomePageCell.h"

@interface HomePageCell()

//添加播放按钮
@property (nonatomic , strong) UIButton *playButton;

@end


@implementation HomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark 可以自定义点击状态
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    //可以自定义点击状态
}

//MARK:-1.自定义cell的时候，设定自己的tag以及播放按钮的tag
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.tag = 1000;
        self.playButton.tag = 2000;
        [self.playButton addTarget:self action:@selector(clickButtontap:)
                  forControlEvents:UIControlEventTouchUpInside];
        [super bringSubviewToFront:self.playButton];
    }
    return self;
}

#pragma mark View 中的控件都是采用懒加载的形式添加

-(UIImageView *)coverIV{
    if(_coverIV == nil) {
        _coverIV = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverIV];
        //每个控件都是在自己的懒加载方法中进行布局
        [_coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-kScreenWidth * 0.2);
        }];
        
        //背景视图需要可以点击,不过这里是在每个背景视图上添加一个整个屏幕大的视图，然后添加手势，应该是在其他的地方会去掉，
         //不过点击整个大的视图来进行相应，又涉及到传递
        UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        //这里只是起了个蒙版的作用,但是显示的范围似乎很是奇怪
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickViewtap:)];
        [self addGestureRecognizer:tap];
        
        //TODO:-1.暂时不要加上这个蒙版
//        [_coverIV addSubview:backView];
    }
    return _coverIV;
}

-(UILabel *)titleLb{
    if (_titleLb == nil ){
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:14];
          [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(kScreenWidth*0.2);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}

- (UIButton *)playButton {
    
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setHighlighted:NO];// 去掉长按高亮
        [self addSubview:_playButton];
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset((kScreenWidth - 65)/2);
            make.top.equalTo(self.contentView).with.offset((kScreenWidth - 65)/2);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(65);
        }];
    }
    return _playButton;
}

#pragma mark 手势点击
-(void)clickViewtap:(UITapGestureRecognizer *)sender{
    //tag实际上都是1000
     NSInteger tag = (NSInteger)sender.view.tag + _tagInt;
     //注意：这里的tagint等于section，也就是和索引是一样的
     [self.delegate HomeTableViewDidClick:tag];
}

#pragma mark 这里点击Button和cell是不同，主要靠tag俩进行区分，利用的都是cell的代理方法来执行
-(void)clickButtontap:(UIButton *)sender{
    self.isPlay = YES;
    //类似的，Button的tag值都是2000
    NSInteger tag = (NSInteger)sender.tag + _tagInt;
     [self.delegate HomeTableViewDidClick:tag];
}

#pragma mark 切换点击Button之后的图片
-(void)setIsPlay:(BOOL)isPlay{
    _isPlay = isPlay;
    if (isPlay == YES){
        [self.playButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
    }else{
        [self.playButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
    }
}

@end
