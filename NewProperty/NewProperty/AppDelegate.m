//
//  AppDelegate.m
//  NewProperty
//
//  Created by sunkai on 16/10/27.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "AppDelegate.h"
#import "NewPropertyViewController.h"
#import "HomeViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [self newController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(NewPropertyViewController *)newController{
    NewPropertyViewController *new = [[NewPropertyViewController alloc] init];
    //设置本地视频数组
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 4;i++){
        [arr  addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide%d",i] ofType:@"mp4"]];
    }
    new.guideVideoArr = arr;
    //设置封面的图片数组
    new.guideImageArr = @[@"guide0",@"guide1",@"guide2",@"guide3"];
    //设置最后一个视频播放完之后的block
    new.lastOnePlayFinishedBlock = ^(){
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    };
    
    return new;
    
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
