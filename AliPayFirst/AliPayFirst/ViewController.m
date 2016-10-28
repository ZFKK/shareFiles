//
//  ViewController.m
//  AliPayFirst
//
//  Created by sunkai on 16/10/18.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "ViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)payMoney:(UIButton *)sender {
    
    /*
     1.生成订单信息
     2.签名
     */
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    //合作者身 份ID,签约的支付宝账号对应的支
    //付宝唯一用户号。
    //以 2088 开头的 16 位纯数字 组成。
    NSString *partner = @"2088901986198025";
    //收款的支付宝
    NSString *seller = @"ys@yaosha.com.cn";
    //私钥，服务器
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAM9uPRvzfKsa5xBwEf2WpthZMX2QK9mngp9BWV2FEjM/o3s5HnKFgo/FLBVV3Rz0VZaNK5Vuyy+0tYThAv6ubgnXeAlcVn8GarKaWTJeR/xU0vl6B4O43cOst6k7n7xnmlsdY4jwtfJV/miVYTShc/ASFLMEZD5DXs98jgizDQ//AgMBAAECgYAqSe45cZV8CLsM1dxFF96iAuUdFTRrZkQyFY+TilqgihvZNlbnwCJTDz6ihuPSUFnWnKdDCthvvGa5VWpX49XY28lfMnvUlVoIudfrdLpXB6APSN82lwOW0c2Dk1vCV10Sll+Pdu+mYv7UDHD+HSRHrZAy8Zn7WNqGYuCdixdpKQJBAO6UmJIjo5mm2B6AZ5L7GvSgFcDx/30ymciyHwHl+7q/uDMfqgtsYrDRYZ6ZasZ8YNvZ2ZbD70BGsJ7tY0CQYoMCQQDek2iXjr+U3/Ddg21zwtXhWzRU2OdiCwtwBOaA8BPiw1amFxO/zsauI4Xbazb4aKWJWXBC8EjTlEsjKPadmTPVAkEApI6DqZDBX9KPkII6bkuabQ4Z0wpXkXAcWCxbbMDHXyirkT+O1vA8Jf9VWMIyvpK9cAaTqQSd+fSIECZmZfrwpwJBAIbjw1GGm6j4BxvYWO79N236Pj7lrWUH2IitD5044nRdehfyiG+IO3Sx5p/R3GCz2w7ge162DQzdJKRMYRmmDXkCQQDTOLHU8jHBACw++FLSX/Bde0iNnOMufZWnWAYVOKFA9KOkI/GPHq1F50+xZX4ZbA+ER/QdCh9MtDHVjSHYY/hN";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    //商户id
    order.partner = partner;
    //收款账号
    order.sellerID = seller;
    
    order.outTradeNO = @"4323423432323"; //订单ID（由商家自行制定）
    order.subject = @"商品名字"; //商品标题
    order.body = @"商品描述"; //商品描述
    //该笔订单的资金总额,单位为 RMB-Yuan。取值范围为 [0.01,100000000.00],精确 到小数点后两位。
    order.totalFee = [NSString stringWithFormat:@"%d",100]; //商品价格
    //支付宝服务器主动通知商户 网站里指定的页面 http 路径。
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    //固定值。
    order.service = @"mobile.securitypay.pay";
    //支付类型。默认值为:1(商 品购买)。
    order.paymentType = @"1";
    //商户网站使用的编码格式,固 定为 utf-8。
    order.inputCharset = @"utf-8";
    /*
     设置未付款交易的超时时间, 一旦超时,该笔交易就会自动 被关闭。
     当用户输入支付密码、点击确 认付款后(即创建支付宝交易 后)开始计时。
     取值范围:1m~15d,或者使 用绝对时间(示例格式: 2014-06-13 16:00:00)。
     m-分钟,h-小时,d-天,1c- 当天(无论交易何时创建,都 在 0 点关闭)。
     该参数数值不接受小数点,如 1.5h,可转换为 90m。
     */
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"Alipay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //    canOpenUrl
    
    /*
     md5,
     RSA
     DES 
     AES
     base64
     */
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //私钥签名
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    //订单加密
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //调用支付宝支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            //如果resultStatus = 9000表示成功
        }];
        
    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
