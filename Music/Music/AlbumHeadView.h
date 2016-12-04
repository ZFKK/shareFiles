//
//  AlbumHeadView.h
//  Music
//
//  Created by sunkai on 16/11/11.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumPickView.h"
#import "AlbumIconNameView.h"
#import "AlbumDesView.h"

// 按钮协议
@protocol HeaderViewDelegate <NSObject>

- (void)topLeftButtonDidClick;
- (void)topRightButtonDidClick;

@end


@interface AlbumHeadView : UIImageView

// 定义代理
@property (nonatomic,weak) id<HeaderViewDelegate> delegete;

// 头部标题，最中间的那个
@property (nonatomic,strong) UILabel *title;
// 头像旁边标题(与头部视图text相等)，小的标题
@property (nonatomic,strong) UILabel *smallTitle;

// 背景图 和 方向图
@property (nonatomic,strong) AlbumPickView *picView;
// 自定义头像按钮
@property (nonatomic,strong) AlbumIconNameView *nameView;
// 自定义描述按钮
@property (nonatomic,strong) AlbumDesView *descView;

/** 根据标签数组, 设置按钮标签 */
- (void)setupTagsBtnWithTagNames:(NSArray *)tagNames;

//用于实时的修改模糊视图的高度
@property (nonatomic) CGRect visualEffectFrame;

@end
