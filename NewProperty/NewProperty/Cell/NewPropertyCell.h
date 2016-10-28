//
//  NewPropertyCell.h
//  NewProperty
//
//  Created by sunkai on 16/10/27.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PlayFinishedNotify @"PlayFinishedNotify"

//通知，针对当前的cell中的视频播放完毕，就会发出通知

@interface NewPropertyCell : UICollectionViewCell

//背景图片
@property(nonatomic,strong,nonnull)UIImage *  backImage;
//视频路径
@property(nonatomic,copy,nonnull)NSString *videoPath;

@end
