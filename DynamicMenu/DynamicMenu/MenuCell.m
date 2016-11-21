//
//  MenuCell.m
//  DynamicMenu
//
//  Created by sunkai on 16/11/21.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell{
    UIView *_lineView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    _lineView = lineView;
    [self addSubview:lineView];
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//统一布局就好了
- (void)layoutSubviews{
    [super layoutSubviews];
    _lineView.frame = CGRectMake(10, self.bounds.size.height - 1, self.bounds.size.width - 20, 1);
}

- (void)setMenuModel:(MenuModel *)menuModel{
    _menuModel = menuModel;
    self.imageView.image = [UIImage imageNamed:menuModel.imageName];
    self.textLabel.text = menuModel.itemName;
}


@end
