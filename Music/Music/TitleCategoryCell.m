
//
//  TitleCategoryCell.m
//  Music
//
//  Created by sunkai on 16/11/10.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "TitleCategoryCell.h"

@interface TitleCategoryCell()

/**  三角剪头 */
@property (nonatomic,strong) UIImageView *arrowV;
@property (nonatomic,strong) UIImageView *arrowIV;

/**  更多按钮 */
@property (nonatomic,strong) UIButton *moreBtn;


@end

@implementation TitleCategoryCell

- (instancetype)initWithTitle:(NSString *)title hasMore:(BOOL)more titleTag:(NSInteger) titleTag{
    
    if (self = [super init]) {
        self.title = title;
        self.arrowIV.image = [UIImage imageNamed:@"tabbar_np_play@2x"];
        self.arrowV.image = [UIImage imageNamed:@"xm_accessory@2x"];
        self.tag = titleTag;
        [self.titleLb setTextColor:[UIColor blackColor]];
        if (more) {
            [self.moreBtn setTitle:@"更多 " forState:UIControlStateNormal];
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 懒加载 右侧的箭头
- (UIImageView *)arrowV {
    
    if (!_arrowV) {
        _arrowV = [[UIImageView alloc] init];
        [self addSubview:_arrowV];
        [_arrowV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-4);
            make.bottom.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
    }
    return _arrowV;
}

#pragma mark -左侧的箭头
- (UIImageView *)arrowIV {
    
    if (!_arrowIV) {
        _arrowIV = [[UIImageView alloc] init];
        [self addSubview:_arrowIV];
        [_arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.bottom.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(12, 15));
        }];
    }
    return _arrowIV;
}

#pragma mark -中间的标题
- (UILabel *)titleLb {
    
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.arrowIV);
            make.left.mas_equalTo(self.arrowIV.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(self.moreBtn.mas_left).mas_equalTo(10);
        }];
        _titleLb.font = [UIFont systemFontOfSize:13];
        _titleLb.text = _title;
    }
    return _titleLb;
}

#pragma mark -只有说更多属性是YES的时候，才会显示出文字
- (UIButton *)moreBtn {
    
    if (!_moreBtn) {
        _moreBtn = [UIButton new];
        [self addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_arrowV);
            make.centerY.mas_equalTo(self.arrowIV);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
        [_moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _moreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_moreBtn setImage:[UIImage imageNamed:@"cell_arrow"] forState:UIControlStateNormal];
        
        // 按钮点击事件
        [_moreBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moreBtn;
}

- (void)click {
    
    if ([self.delegate respondsToSelector:@selector(titleViewDidClick:)]) {
        [self.delegate titleViewDidClick:self.tag];
    }
//    NSLog(@"更多按钮被点击 %ld",(long)self.tag);
}

@end
