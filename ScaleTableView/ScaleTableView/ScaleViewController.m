//
//  ScaleViewController.m
//  ScaleTableView
//
//  Created by sunkai on 16/11/20.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "ScaleViewController.h"
#import "UIImageView+AFNetworking.h"
//#import <AFNetworking.h>
#import <YYWebImage.h>
#import "UIView+Base.h"
#import "Person.h"
#import "NSObject+Runtimer.h"

@interface ScaleViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIStatusBarStyle _statusBar;
}
    
@property (nonatomic,strong)UIView *headview;
@property (nonatomic,strong)UIImageView *headimageview;
@property (nonatomic,strong)UIView *lineview;


@end

@implementation ScaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareTableView];
    [self preprareheadview];
    
    _statusBar = UIStatusBarStyleLightContent;
    
    //获取模型的属性数组
    NSArray  *pers = [Person objProperties];
    //进行字典转模型
    
    Person *person = [Person objcWithDic:@{@"name":@"zhagnsan",
                                           @"age":@20,
                                           @"title":@"麻痹"}];
    NSLog(@"%@",person);
}

//状态栏的设置
-(UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBar;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //隐藏导航栏
    
    //取消自动调整滚动视图间距 针对VC+NA,自动布局必须设置为NO
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)preprareheadview{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    head.backgroundColor = [UIColor blueColor];
    _headview = head;
    [self.view addSubview:_headview];
    
    UIImageView *iamge = [[UIImageView alloc] init];
    iamge.frame = head.bounds;
    iamge.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:@"http://pic1.win4000.com/pic/f/2e/022a445917.jpg"];
    iamge.contentMode = UIViewContentModeScaleAspectFill;
    //图片要进行裁剪，否则，宽度可能会出去
    iamge.clipsToBounds = YES;
//    [iamge setImageWithURL:url];
    [iamge yy_setImageWithURL:url options:1];
    _headimageview = iamge;
    [head addSubview:_headimageview];
    
    //设置分割线
    CGFloat lineheight = 1 / [UIScreen mainScreen].scale ;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200 - lineheight, _headimageview.Wid, lineheight)];
    lineView.backgroundColor = [UIColor blueColor];
    _lineview = lineView;
    [_headview addSubview:_lineview];
}
-(void)prepareTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //设置表格的偏距
    table.contentInset = UIEdgeInsetsMake(200, 0, 0, 0) ;
    //设置指示器的位置
    table.scrollIndicatorInsets = table.contentInset;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
    NSLog(@"%f",offset);
    if (offset <= 0){
        //往下拉
        _headview.Y = 0;
        _headview.Hei = 200 - offset;
        _headimageview.Hei = _headview.Hei;
        _headimageview.alpha = 1;
    }else{
      //往上移动
        _headview.Hei = 200;
        _headimageview.Hei = _headview.Hei;
        //headview 的最小值
        CGFloat min = 200 - 64;
        _headview.Y = -MIN(offset, min);
    
        //设置透明度
        CGFloat progerss = 1 - (offset / min);
        _headimageview.alpha = progerss;
        
        //根据透明度，设置状态栏的style
        _statusBar = (progerss < 0.5) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        //需要主动更新状态栏
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    }
    
    //设置分割线的位置
    _lineview.Y = _headview.Hei - _lineview.Hei;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
