//
//  AppDelegate.m
//  WeixinPay
//
//  Created by sunkai on 16/10/18.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "payRequsestHandler.h" //签名等相关文件
#import "WXApiObject.h" //用于回调

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    //这里的appid是通过审核之后的
    [WXApi registerApp:@"" withDescription:@"随便写"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    
    //相当是在支付成功之后，返回到原生app中才会进行设置代理，另外下边的url应该是本应用传递的，暂且设置为一个@“”
    if ([url.scheme hasPrefix:@""]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}


- (void)onResp:(BaseResp *)resp{
    
    //这里表示收到微信支付返回的结果
    //发送一个通知,给支付页面进行接收
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send" object:resp];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
