//
//  ZFBaseViewController.h
//  MVVMTest
//
//  Created by sunkai on 16/12/3.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseViewControllerDelegate <NSObject>

@optional
//方法都是可选的
-(instancetype)initWithViewModel:(id <BaseViewControllerDelegate>)viewModel;

-(void)ZF_bindViewModel;
//绑定VM
-(void)ZF_addSubviews;
//添加子视图
-(void)ZF_layoutNavigation;
//设置子VC的导航栏
-(void)ZF_getNewData;
//请求数据，是通过VM来进行
-(void)ZF_recoverKeyboard;
//遮盖键盘
@end



@interface ZFBaseViewController : UIViewController<BaseViewControllerDelegate>
/**
 *  VIEW是否渗透导航栏
 * (YES_VIEW渗透导航栏下／NO_VIEW不渗透导航栏下)
 */
@property (assign,nonatomic) BOOL isExtendLayout;

/**
 * 功能：设置修改StatusBar
 * 参数：（1）StatusBar样式：statusBarStyle
 *      （2）是否隐藏StatusBar：statusBarHidden
 *      （3）是否动画过渡：animated
 */

-(void)changeStatusBarStyle:(UIStatusBarStyle)statusBarStyle
            statusBarHidden:(BOOL)statusBarHidden
    changeStatusBarAnimated:(BOOL)animated;

/**
 * 功能：隐藏显示导航栏
 * 参数：（1）是否隐藏导航栏：isHide
 *      （2）是否有动画过渡：animated
 */
-(void)hideNavigationBar:(BOOL)isHide
                animated:(BOOL)animated;

/**
 * 功能： 布局导航栏界面
 * 参数：（1）导航栏背景：backGroundImage
 *      （2）导航栏标题颜色：titleColor
 *      （3）导航栏标题字体：titleFont
 *      （4）导航栏左侧按钮：leftItem
 *      （5）导航栏右侧按钮：rightItem
 */
-(void)layoutNavigationBar:(UIImage*)backGroundImage
                titleColor:(UIColor*)titleColor
                 titleFont:(UIFont*)titleFont
         leftBarButtonItem:(UIBarButtonItem*)leftItem
        rightBarButtonItem:(UIBarButtonItem*)rightItem;
@end
