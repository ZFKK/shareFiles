//
//  ViewController.m
//  02-银联支付
//
//  Created by vera on 15/11/30.
//  Copyright © 2015年 vera. All rights reserved.
//

#import "ViewController.h"
#import "UPPaymentControl.h"
#import "RSA.h"
//需要进行加密
#define URL   @"http://101.231.204.84:8091/sim/getacptn"
//向银联的后台发送请求，获取服务号



//官方提供的测试账号
/**
 *  主要存在两个
 招商银行借记卡：6226090000000048
 手机号：18100000000
 密码：111101
 短信验证码：123456（先点获取验证码之后再输入）
 证件类型：01身份证
 证件号：510265790128303
 姓名：张三

 
 华夏银行贷记卡：6226388000000095
 手机号：18100000000
 CVN2：248
 有效期：1219
 短信验证码：123456（先点获取验证码之后再输入）
 证件类型：01身份证
 证件号：510265790128303
 姓名：张三

 */

#if 0
source :
(1)Objective–C  支持OC和C混编
(2)Objective–C++ 支持OC,C和C++
#endif

@interface ViewController (){
    NSURLSessionDataTask  *_task;
    NSURLSession *_session;
    NSOperationQueue *_queue;
}

@property (nonatomic,copy)NSString *requestUrl;
@end

@implementation ViewController

#pragma mark -初始化会话
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置代理，完成进度的监听
    _session = [NSURLSession sharedSession];
    
}

#pragma mark -这里相当于是每次点击之后，都会发送一个datatask的请求
-(void )requestWithUrl:(NSURL *)url{
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
        _task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data && (error == nil)){
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                self.requestUrl = [result copy];
                NSLog(@"转换的结果是%@",self.requestUrl);
                //表示没有错误的情况下，才会进行真正的向银联发送请求支付
                [self reallyRequest];
            }
        }];
    [_task resume];
}
- (IBAction)pay:(id)sender
{
    /*
     startPay:交易流水号信息,银联后台生成, 通过商户后台返回到客户端并传 入支付控件;
     mode:接入模式设定,两个值: @"00":代表接入生产环境(正式版 本需要); @"01":代表接入开发测试环境(测 试版本需要);
     */
    
#if 0
    //检测是否已安装银联App接口调用(这个方法可写可不写)
    if([[UPPaymentControl defaultControl] isPaymentAppInstalled])
    {
        //当判断用户手机上已安装银联App，商户客户端可以做相应个性化处理
    }else{
        //下边是自己自定义的一些提示信息
        UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"小子，你都没安装客户端额" message:@"麻溜的取安装" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *quddingaction = [UIAlertAction  actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alt addAction:quddingaction];
        [alt addAction:cancelaction];
        [self presentViewController:alt animated:YES completion:nil];
    }
#endif
    [self requestWithUrl:[NSURL URLWithString:URL]];
  
}


-(void)reallyRequest{
    //这个Scheme和添加的url是关联的额，在info中添加
    if (self.requestUrl != nil && self.requestUrl.length > 0 ){
        NSLog(@"流水号是%@",self.requestUrl);
        [[UPPaymentControl defaultControl] startPay:self.requestUrl fromScheme:@"uppaysdk" mode:@"01" viewController:self];
    }
}



@end
