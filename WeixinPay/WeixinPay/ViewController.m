//
//  ViewController.m
//  WeixinPay
//
//  Created by sunkai on 16/10/18.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "ViewController.h"
//APP端签名相关头文件
#import "payRequsestHandler.h"
#import "WXApi.h"


@interface ViewController ()


@end

@implementation ViewController


- (IBAction)payMoney:(UIButton *)sender {
    
    //创建一次支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];

    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo];
    //上边的这个方法是用来生成订单的，dict是生成订单之后获取的参数
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        //公众账号ID
        req.openID              = [dict objectForKey:@"appid"];
        //商户号
        req.partnerId           = [dict objectForKey:@"partnerid"];
        /** 预支付订单 */
        req.prepayId            = [dict objectForKey:@"prepayid"];
        /** 随机串，防重发 */
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        /** 时间戳，防重发 */
        req.timeStamp           = stamp.intValue;
        /** 商家根据财付通文档填写的数据和签名 */
        req.package             = [dict objectForKey:@"package"];
        /** 商家根据微信开放平台文档对数据做的签名 */
        req.sign                = [dict objectForKey:@"sign"];
        
        //发送支付请求
        [WXApi sendReq:req];
    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //微信支付成功之后的，支付页面要处理支付结果，用通知来进行实现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendPay:) name:@"send" object:nil];
    
}


- (void)sendPay:(id)sender{
    
    //处理支付结果
    BaseResp * resp = [sender object];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                // 跳转到成功页面
//                PaySuccessfulViewController *paySuccessful = [PaySuccessfulViewController new];
//                [self.navigationController pushViewController:paySuccessful animated:YES];
            }
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
