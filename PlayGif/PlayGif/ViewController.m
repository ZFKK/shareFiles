//
//  ViewController.m
//  PlayGif
//
//  Created by sunkai on 16/11/20.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "ViewController.h"
#import <SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+GIF.h"
#import "YYWebImage.h"
#import "GifCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareTableView];
}


-(void)prepareTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 120;
    [table registerClass:[GifCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:table];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

//http://ww1.sinaimg.cn/bmiddle/006czPLdgw1ex7q35dchng306t06tx61.gif
//http://down.laifudao.com/tupian/2015114224111.gif
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *im = [UIImage sd_animatedGIFWithData:data];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://down.laifudao.com/tupian/2015114224111.gif"] placeholderImage:nil];
//    [cell.imageView setImage:im];
    [cell.imageView yy_setImageWithURL:[NSURL URLWithString:@"http://down.laifudao.com/tupian/2015114224111.gif"] placeholder:nil];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
