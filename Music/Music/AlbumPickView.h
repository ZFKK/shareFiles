//
//  AlbumPickView.h
//  Music
//
//  Created by sunkai on 16/11/11.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

//实际上，也就是大的专辑头像

@interface AlbumPickView : UIView

/**
 *  方形图片
 */
// 方图
@property (nonatomic,strong) UIImageView *coverView;
// 透明图层
@property (nonatomic,strong) UIImageView *bgView;
// 播放数
@property (nonatomic,strong) UIButton *playCountBtn;



@end
