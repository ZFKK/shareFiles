//
//  ViewController.m
//  DynamicMenu
//
//  Created by sunkai on 16/11/21.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "ViewController.h"
#import "MenuView.h"

@interface ViewController ()

@property (nonatomic,assign) BOOL flag;
@property (nonatomic,assign) int itemCount;

@end

@implementation ViewController{
    NSArray *_dataArray;
    //私有成员变量，保存当前VC的菜单个数
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.flag = YES;

    NSDictionary *dict1 = @{@"imageName" : @"icon_button_affirm",
                            @"itemName" : @"撤回"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"icon_button_recall",
                            @"itemName" : @"确认"
                            };
    NSDictionary *dict3 = @{@"imageName" : @"icon_button_record",
                            @"itemName" : @"记录"
                            };
    NSArray *dataArray = @[dict1,dict2,dict3];
    
    _dataArray = dataArray;

    __weak typeof(self) weakSelf = self;
    
    [MenuView createMenuWithFrame:CGRectZero target:self.navigationController dataArray:dataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        [weakSelf doSomething:str tag:tag];
    } backViewTap:^{
        // 点击背景遮罩view后的block，可自定义事件
        // 这里的目的是，让rightButton点击，可再次pop出menu
        weakSelf.flag = YES;
    }];
    

}

#pragma mark  点击右上角的
- (IBAction)popMenu:(UIBarButtonItem *)sender {
    if (self.flag) {
        [MenuView showMenuWithAnimation:self.flag];
        self.flag = NO;
    }else{
        [MenuView showMenuWithAnimation:self.flag];
        self.flag = YES;
    }
}

#pragma mark  增加菜单
- (IBAction)AddMenu:(UIButton *)sender {
    NSDictionary *addDict = @{@"imageName" : @"icon_button_recall",
                              @"itemName" : [NSString stringWithFormat:@"新增项%d",self.itemCount + 1]
                              };
    NSArray *newItemArray = @[addDict];
    
    /**
     *  追加菜单项
     */
    [MenuView appendMenuItemsWith:newItemArray];
    self.itemCount ++;
}

#pragma mark  恢复菜单
- (IBAction)RecoveMenu:(UIButton *)sender {
    
    /**
     *  更新菜单
     */
    [MenuView updateMenuItemsWith:_dataArray];
    
    self.itemCount = 0;
}

#pragma mark -- 回调事件
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:[NSString stringWithFormat:@"点击了第%ld个菜单项",tag] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
    [MenuView hidden];  // 隐藏菜单
    self.flag = YES;
}

- (void)dealloc{
    [MenuView clearMenu];   // 移除菜单
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
