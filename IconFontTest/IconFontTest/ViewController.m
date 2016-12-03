//
//  ViewController.m
//  IconFontTest
//
//  Created by sunkai on 16/12/2.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ViewController.h"
#import "ZFIconFont.h"
#import "ZFIconFontInfo.h"
#import "UIImage+ZFIconFont.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    ZFIconFontInfo *info = IconInfoMake(@"\U0000e602", 40, [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1]);
    UIImage *selfimage = [UIImage iconWithInfo:info];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:selfimage style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction)];
    self.navigationItem.leftBarButtonItem = leftBarButton;


    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage iconWithInfo:IconInfoMake(@"\U0000e60d",25, [UIColor colorWithRed:0.14 green:0.61 blue:0.83 alpha:1.00])] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.14 green:0.61 blue:0.83 alpha:1.00];

    
    
}

#pragma mark --左右两侧的点击方法
-(void)rightButtonAction{
    NSLog(@"点击了右侧的tabbaritem");
}
-(void)leftButtonAction{
    NSLog(@"点击了左侧的tabbaritem");
}

#pragma mark --自己定义的view，取代系统的！，对于这种字体的这种操作的一个好处：可以使用原生的字体和这种字体图片进行混合使用
-(void)loadView{
    [super loadView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 50, 30, 30)];
    [self.view addSubview:imageView];
    //图标编码是&#xe603，需要转成\U0000e603
    //&#xe617;自己的图片icon，应该是个爱心
    imageView.image = [UIImage iconWithInfo:IconInfoMake(@"\U0000e617", 30, [UIColor redColor])];
    //    button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 40, 40);
    [self.view addSubview:button];
    
    //这里应该是个照相机
    [button setImage:[UIImage iconWithInfo:IconInfoMake(@"\U0000e610", 40, [UIColor redColor])] forState:UIControlStateNormal];
    //    label,label可以将文字与图标结合一起，直接用label的text属性将图标显示出来
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, 280, 40)];
    [self.view addSubview:label];
    label.font = [UIFont fontWithName:@"iconfont" size:15];//设置label的字体
    label.text = @"这是用label显示的iconfont  \U0000e60c";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
