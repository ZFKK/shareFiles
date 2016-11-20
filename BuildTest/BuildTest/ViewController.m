//
//  ViewController.m
//  BuildTest
//
//  Created by sunkai on 16/11/19.
//  Copyright © 2016年 imo. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    UIScrollView *scrollview = [[UIScrollView alloc] init];
//    [self.view addSubview:scrollview];
//    
//    //添加一个视图
//    UIView *view1 = [[UIView alloc] init];
//    view1.backgroundColor =  [UIColor blueColor];
//    
//    [scrollview addSubview:view1];
//    
//    //自动布局
//    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    
//    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(scrollview);
//        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000));
//    }];
//    
//    //之后的全部布局控件，都是添加到view1上就行了额
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:table];

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 99){
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.hidesBottomBarWhenPushed = YES;
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
