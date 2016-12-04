//
//  ZFViewDelegate.h
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewModelDelegate;
//注意：VM绑定对应的model,然后对应的view绑定对应的VM，自己是这样认为的
@protocol ZFViewDelegate <NSObject>

@optional
-(instancetype)initWithViewModel:(id <ViewModelDelegate>) viewModel;
//下边就是对应的绑定方法以及键盘的触控事件
- (void)ZF_bindViewModel;
- (void)ZF_setupViews;
- (void)ZF_addReturnKeyBoard;

@end
