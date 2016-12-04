//
//  Pickview.h
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerviewDelegate <NSObject>

@optional

//可以不实现，是否点击了某个
-(void)didSelectedPickerView:(NSInteger)index time:(NSInteger)time;

@end

@interface Pickview : UIView

@property (nonatomic, assign) id<PickerviewDelegate> delegate;


@end
