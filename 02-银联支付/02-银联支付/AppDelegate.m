//
//  AppDelegate.m
//  02-银联支付
//
//  Created by vera on 15/11/30.
//  Copyright © 2015年 vera. All rights reserved.
//

#import "AppDelegate.h"
#import "UPPaymentControl.h"
#import "RSA.h"
#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
//哈希安全算法

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark -返回支付结果
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        //自定义操作
         NSLog(@"返回结果是%@",code);
        if ([code isEqualToString:@"success"] ){
            
            //判断签名数据是否存在
            if (data == nil){
                return ;
            }

            //支付结果串，根据url解析数据，后边的block是用户自定义行为，其中的额两个参数，code返回支付结果，data为签名数据，使用银联公钥验证
            //对返回的结果进行签名验证，只有验证通过之后，才可以进行显示
            //数据从字典转换为字符串
            NSData *signdata = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString *signStr = [[NSString alloc] initWithData:signdata encoding:NSUTF8StringEncoding];
            
            //验签证书同后台验签证书
            //此处的verify，商户需送去商户后台做验签
            if([self verify:signStr]) {
                //支付成功且验签成功，展示支付成功提示
            }
            else {
                //验签失败，交易结果数据被篡改，商户app后台查询交易结果
            }
            
        }else if ([code isEqualToString:@"fail"]){
            NSLog(@"验证签名失败");
        }else{
            NSLog(@"交易取消");
        }
    }];
    
    return YES;
}

#pragma mark --通过什么去发送到后台验证？？
-(BOOL) verify:(NSString *) resultStr {
    
    //验签证书同后台验签证书
    //此处的verify，商户需送去商户后台做验签
    return NO;
}


- (NSString*)sha1:(NSString *)string
{
    //这里也就是20位的哈希数字验证
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    //初始话一个数组
    CC_SHA1_CTX context;
    NSString *description;
    CC_SHA1_Init(&context);
    //初始化上下文
    memset(digest, 0, sizeof(digest));
    //开辟空间
    description = @"";
    
    if (string == nil)
    {
        return nil;
    }
    // Convert the given 'NSString *' to 'const char *'.
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Check if the conversion has succeeded.
    if (str == NULL)
    {
        return nil;
    }
    
    // Get the length of the C-string.
    int len = (int)strlen(str);
    
    if (len == 0)
    {
        return nil;
    }
    
    if (str == NULL)
    {
        return nil;
    }
    
    CC_SHA1_Update(&context, str, len);
    
    CC_SHA1_Final(digest, &context);
    
    description = [NSString stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[ 0], digest[ 1], digest[ 2], digest[ 3],
                   digest[ 4], digest[ 5], digest[ 6], digest[ 7],
                   digest[ 8], digest[ 9], digest[10], digest[11],
                   digest[12], digest[13], digest[14], digest[15],
                   digest[16], digest[17], digest[18], digest[19]];
    
    return description;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
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
