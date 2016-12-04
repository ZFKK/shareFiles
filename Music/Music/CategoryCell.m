//
//  CategoryCell.m
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "CategoryCell.h"

@interface CategoryCell()

@property (nonatomic,strong) UIImageView *arrow; //底部的图片显示
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;//添加模糊效果,只是针对点击之后的效果，动态添加视图
@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer; //长按手势

@end

@implementation CategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        //titleLabel.font = [UIFont systemFontOfSize:30];
        titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:30];
        titleLabel.text = _title;
        [self.arrow addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.arrow).with.offset(20);
            make.bottom.equalTo(self.arrow).with.offset(-10);
            make.width.mas_equalTo(180);
        }];
        _titleLb = titleLabel;
        
        // 分割线缩短
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return self;
}

#pragma mark - 懒加载  并且是本身就是一个cell上，加上一个图片，另外在这个图片上再次添加一个背景图片和同时加上一个label，
- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        [self.contentView addSubview:_arrow];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0);
            make.left.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
        }];
        
        //下背景图片
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.image = [UIImage imageNamed:@"album_album_mask"];
//        [_arrow addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).with.offset(0);
//            make.left.equalTo(self).with.offset(0);
//            make.bottom.equalTo(self).with.offset(0);
//            make.right.equalTo(self).with.offset(0);
//        }];
        
        /* 长按手势来形成按钮效果 */
        self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        self.pressRecognizer.minimumPressDuration = 0.2;
        
        self.pressRecognizer.delegate = self;
        self.pressRecognizer.cancelsTouchesInView = NO;
        
        [self addGestureRecognizer:self.pressRecognizer];
    }
    return _arrow;
}

#pragma mark  --手势代理方法 表示如果两个手势同时发生是允许的
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - 长按手势的触发方法
-(void)longPress:(UITapGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan){
        
        if(![_visualEffectView isDescendantOfView:self]) {
            UIVisualEffect *blurEffect;
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            _visualEffectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.4);
            
            [self addSubview:_visualEffectView];
            
            //标题
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:50];
            titleLabel.text = _title;
            titleLabel.textColor = [UIColor whiteColor];
            [_visualEffectView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.arrow).with.offset(20);
                make.bottom.equalTo(self.arrow).with.offset(-10);
                make.width.mas_equalTo(180);
            }];
            
        }
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [_visualEffectView removeFromSuperview];
    }
    
}

#pragma mark  --plist文件的获取
-(void)setTitle:(NSString *)title{
    _title = title;
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"categoryData" ofType:@"plist"];
    NSMutableArray *categoryArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    NSInteger counts = [categoryArray count];
    for (int i=0; i < counts; i++) {
        
        if ([_title isEqualToString:categoryArray[i][@"title"]]) {
            
            self.arrow.image = [UIImage imageNamed:categoryArray[i][@"image"]];
            break;
        }else{
            self.arrow.image = [UIImage imageNamed:@"music_dan.jpg"];
        }
    }
    self.titleLb.text = _title;
    [self.titleLb setTextColor:[UIColor whiteColor]];
    
    self.backgroundColor = [UIColor whiteColor];

}


@end
