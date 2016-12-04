//
//  CategoryCell.h
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate传值
@protocol CategoryTableDelegate <NSObject>

- (void)categoryViewDidClick:(NSInteger)tag;/**这里不用使用*/

@end


@interface CategoryCell : UITableViewCell

// 添加代理
@property (nonatomic,weak) id<CategoryTableDelegate> delegate;

/**  标题 */
@property (nonatomic,weak) NSString *title;
@property (nonatomic,weak) UILabel *titleLb;

@end
