//
//  LeftView.m
//  Music
//
//  Created by sunkai on 16/11/5.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "LeftView.h"
#import "WebViewController.h"
//跳转的页面

#import "MyProfileViewController.h"

@interface LeftView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation LeftView

#pragma mark -构造器
-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:0.97];
        [self initTableview:frame];
    }
    return  self;
}

#pragma mark -tableview初始化
-(void)initTableview:(CGRect )frame{
     self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    //这里限定不能进行滚动
    
}

#pragma mark -tableview的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

//头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:0.0];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 150;
            break;
        case 1:
            return 30;
            break;
        case 4:
            return 30;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"签到抽奖";
            break;
        case 1:
            cell.textLabel.text = @"我的主页";
            break;
        case 2:
            cell.textLabel.text = @"我的收藏";
            break;
        case 3:
            cell.textLabel.text = @"我的缓存";
            break;
        case 4:
            cell.textLabel.text = @"定时关机";
            break;
        case 5:
            cell.textLabel.text = @"意见反馈";
            break;
        case 6:
            cell.textLabel.text = @"(´・ω・)ﾉ点赞";
            break;
        default:
            cell.textLabel.text = @"加载错误";
            break;
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sandbox.runjs.cn/show/cph8yp2j"]];
            
            [self.delegate jumpWebVC:[NSURL URLWithString:@"http://sandbox.runjs.cn/show/cph8yp2j"]];
            break;
        case 1:
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sandbox.runjs.cn/show/ep2rmlww"]];
            break; 
        case 3:
            [self.delegate jumpDataVC:HistoryMode];
            break;
        case 2:
            [self.delegate jumpDataVC:FavoriteMode];
            break;
        case 4:
            
            break;
        case 5:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://903797097@qq.com"]];
            break;
        case 6:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/ZFKK"]];
            break;
        default:
            
            break;
    }
    
}

@end
