//
//  HomePageCell.h
//  Music
//
//  Created by sunkai on 16/11/5.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>


//点击了某一行，一般来说，如果添加了手势，也是会有可能起冲突的
@protocol HomeTableViewDelegate <NSObject>

- (void)HomeTableViewDidClick:(NSInteger)tag;

@end

@interface HomePageCell : UITableViewCell

// 添加代理
@property (nonatomic,assign) id<HomeTableViewDelegate> delegate;
@property(nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic) NSInteger tagInt;
@property (nonatomic) BOOL isPlay;

@end
