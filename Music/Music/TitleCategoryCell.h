//
//  TitleCategoryCell.h
//  Music
//
//  Created by sunkai on 16/11/10.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate传值
@protocol TitleViewDelegate <NSObject>

- (void)titleViewDidClick:(NSInteger)tag;

@end

@interface TitleCategoryCell : UIView

// 添加代理
@property (nonatomic,weak) id<TitleViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title hasMore:(BOOL)more titleTag:(NSInteger) titleTag;

//注意：这里的hasmore是和VM中请求的相关的

/**  标题 */
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,assign) NSInteger titleTag;

@end
