//
//  ZFListViewController.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFListViewController.h"
#import "ZFListView.h"//整体的view界面
#import "ZFListViewModel.h" //针对VC的VM

#import "ZFBaseViewController.h"


@interface ZFListViewController ()
//添加两个属性

@property (nonatomic, strong) ZFListView *mainView;

@property (nonatomic, strong) ZFListViewModel *viewModel;

@end

@implementation ZFListViewController

#pragma mark --生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -- 系统的VC更新约束
-(void)updateViewConstraints{
    WS(weakSelf)
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    [super updateViewConstraints];

}


#pragma mark --懒加载方法,UI界面
-(ZFListView *)mainView{
    if (!_mainView){
        _mainView = [[ZFListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

#pragma mark --懒加载方法，获取VM以及数据
-(ZFListViewModel *)viewModel{
    if (!_viewModel){
        _viewModel = [[ZFListViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark --基类或者父类的协议方法
-(void)ZF_addSubviews{
    [self.view addSubview:self.mainView];
}

-(void)ZF_bindViewModel{
    @weakify(self);
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
        ZFBaseViewController *circleMainVC = [[ZFBaseViewController alloc] init];
        [self.navigationController pushViewController:circleMainVC animated:YES];
    }];
}

-(void)ZF_layoutNavigation{
    self.title = @"我的天";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
