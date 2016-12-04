//
//  MenuCell.h
//  Music
//
//  Created by sunkai on 16/11/14.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface MenuCell : UITableViewCell

@property (nonatomic, strong) UIImageView             *itemImageView;
@property (nonatomic, strong) UILabel                 *itemTitleLabel;

@property (nonatomic, strong) MenuItem *model;

@end
