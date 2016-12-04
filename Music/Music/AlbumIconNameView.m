//
//  AlbumIconNameView.m
//  Music
//
//  Created by sunkai on 16/11/11.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "AlbumIconNameView.h"

@implementation AlbumIconNameView

- (instancetype)init {
    if (self = [super init]) {
        self.icon.hidden = NO;
        self.name.hidden = NO;
    }
    return self;
}

#pragma mark -总是懒加载
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [UIImageView new];
        [self addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        _icon.image = [UIImage imageNamed:@"sound_default"];
        // 作圆图
        _icon.layer.cornerRadius = 15;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)name {
    if (!_name) {
        _name = [UILabel new];
        [self addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).mas_equalTo(5);
            make.centerY.mas_equalTo(self.icon);
        }];
        _name.textColor = [UIColor whiteColor];
        _name.text = @"我是昵称";
        _name.font = [UIFont boldSystemFontOfSize:14];
    }
    return _name;
}



@end
