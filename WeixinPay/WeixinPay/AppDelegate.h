//
//  AppDelegate.h
//  WeixinPay
//
//  Created by sunkai on 16/10/18.
//  Copyright © 2016年 imo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "WXApi.h"

//这里设置一个回调代理，用于支付完成之后处理支付结果，并转接到之前的支付界面

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

