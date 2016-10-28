//
//  NewPropertyViewController.h
//  NewProperty
//
//  Created by sunkai on 16/10/27.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MS_Width [UIScreen mainScreen].bounds.size.width
#define MS_Height [UIScreen mainScreen].bounds.size.height
#define Key_Window [UIApplication sharedApplication].keyWindow

@interface NewPropertyViewController : UICollectionViewController

//封面图片数组
@property (nonatomic,strong) NSArray *guideImageArr;
//封面视频数组
@property(nonatomic,strong)NSArray *guideVideoArr;
//播放完之后的block
@property(nonatomic,copy)void (^lastOnePlayFinishedBlock)();

@end
