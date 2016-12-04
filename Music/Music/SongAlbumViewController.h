//
//  SongAlbumViewController.h
//  Music
//
//  Created by sunkai on 16/11/8.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击的是推荐页面上的专辑
@interface SongAlbumViewController : UIViewController

// 选择接受外界title, 以及albumId 初始化
- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)oTitle;

@property (nonatomic,assign) NSInteger albumId;
@property (nonatomic,strong) NSString *oTitle;


@end
