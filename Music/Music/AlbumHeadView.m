//
//  AlbumHeadView.m
//  Music
//
//  Created by sunkai on 16/11/11.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "AlbumHeadView.h"
#import "UIControl+BlocksKit.h"

@interface AlbumHeadView ()


@property (nonatomic,strong) UIButton *topLeftBtn;
@property (nonatomic,strong) UIButton *topRightBtn;
@property (strong, nonatomic) UIVisualEffectView *myvisualEffectView;


@end

@implementation AlbumHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 用户交互
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"bg_albumView_header"];
        
        if(![_myvisualEffectView isDescendantOfView:self]) {
            UIVisualEffect *blurEffect;
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _myvisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            _myvisualEffectView.frame = CGRectMake(0, 0, kScreenWidth, frame.size.height+20);
            [self addSubview:_myvisualEffectView];
        }
        
        [self.topLeftBtn setImage:[UIImage imageNamed:@"icon_back@2x"] forState:UIControlStateNormal];
        [self.topRightBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        
        self.descView.hidden = NO;
    }
    return self;
}


#pragma mark -重写rect的frame设置
- (void)setVisualEffectFrame:(CGRect)visualEffectFrame{
    
    CGFloat height = visualEffectFrame.size.height;
    _myvisualEffectView.frame = CGRectMake(0, 0, kScreenWidth, height);
}


#pragma mark - 各个控件的懒加载，左侧Button，右侧Button，中间title，头像，专辑封面，描述title
- (UIButton *)topLeftBtn {
    if (!_topLeftBtn) {
        _topLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_topLeftBtn];
        [_topLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(20);
        }];
        
        //这里设置一下图片的偏距
        _topLeftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        [_topLeftBtn bk_addEventHandler:^(id sender) {
            if ([self.delegete respondsToSelector:@selector(topLeftButtonDidClick)]) {
                [self.delegete topLeftButtonDidClick];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _topLeftBtn;
}
- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(self.topLeftBtn);
            make.width.mas_lessThanOrEqualTo(180);
        }];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont boldSystemFontOfSize:18];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UIButton *)topRightBtn {
    if (!_topRightBtn) {
        _topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_topRightBtn];
        [_topRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-10);
        }];
        
        //这里设置一下图片的偏距
        _topRightBtn.imageEdgeInsets = UIEdgeInsetsMake(18, 15, 18, 15);
        
        [_topRightBtn bk_addEventHandler:^(id sender) {
            if ([self.delegete respondsToSelector:@selector(topRightButtonDidClick)]) {
                [self.delegete topRightButtonDidClick];
                //MARK:-1.相当于Button的方法通过代理来进行实现
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _topRightBtn;
}

- (AlbumPickView *)picView {
    if (!_picView) {
        _picView = [AlbumPickView new];
        [self addSubview:_picView];
        [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.topLeftBtn.mas_bottom).mas_equalTo(15);
        }];
    }
    return _picView;
}

- (AlbumIconNameView *)nameView {
    if (!_nameView) {
        _nameView = [AlbumIconNameView new];
        [self addSubview:_nameView];
        [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.topMargin.mas_equalTo(self.picView);
            make.left.mas_equalTo(self.picView.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(30);
        }];
        
    }
    return _nameView;
}

- (AlbumDesView *)descView {
    if (!_descView) {
        _descView = [AlbumDesView new];
        [self addSubview:_descView];
        [_descView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.picView);
            make.leadingMargin.mas_equalTo(self.nameView);
            // 可能根据字体来设置
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(30);
        }];
//        _descView.descLb.text = @"暂无简介";
    }
    return _descView;
}

#pragma mark - 根据数据中的标签数组，来设置文本,感觉这些是完全没有必要来设置成Button的，好不？？？
/** 根据标签数组, 设置按钮标签 */
- (void)setupTagsBtnWithTagNames:(NSArray *)tagNames {
    // 记录最后一个视图控件
    UIView *lastView = nil;
    // 创建标签按钮
    // 首页只展示两个标签按钮 所以要判断个数
    // 记录个数, 最高展示就两个
    NSInteger maxTags = 2;
    NSInteger counts = tagNames.count;
    if (counts < 2) {
        maxTags = counts;
    }
    for (NSInteger i = 0; i<maxTags; i++) {
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:tagBtn];
        // 按钮根据按钮上文字自适应大小,NSFontAttributeName 要和按钮titleLabel的font对应
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat length = [tagNames[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.width;
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottomMargin.mas_equalTo(self.picView);
            // 文字大小
            make.size.mas_equalTo(CGSizeMake(length+20, 25));
            if (lastView) {  // 存在
                make.left.mas_equalTo(lastView.mas_right).mas_equalTo(5);
            } else {  // 刚开始创建, 按钮的位置
                make.leadingMargin.mas_equalTo(self.descView);
            }
        }];
        // 赋值标签按钮指针
        lastView = tagBtn;
        
        // 设置按钮的属性
        [tagBtn setTitle:tagNames[i] forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        // 76*50 背景图
        [tagBtn setBackgroundImage:[UIImage imageNamed:@"sound_tags"] forState:UIControlStateNormal];
    }
}
@end
