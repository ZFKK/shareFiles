//
//  NewPropertyViewController.m
//  NewProperty
//
//  Created by sunkai on 16/10/27.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "NewPropertyViewController.h"
#import "NewPropertyFlowLayout.h"
#import "NewPropertyCell.h"
#import "HomeViewController.h"


@interface NewPropertyViewController()

//添加页码
@property(nonatomic,strong)UIPageControl *page;
//添加是否播放完成
@property(nonatomic,assign,getter=isFinished)BOOL isOver;
//起了个别名

@end

static NSString * const cellIdetify = @"cellIdentify";

@implementation NewPropertyViewController

//很喜欢懒加载啊
-(UIPageControl *)page{
    if (!_page){
        CGFloat width = 120;
        CGFloat height = 30;
        CGFloat x = (MS_Width - width) * 0.5;
        CGFloat y = MS_Height - 30 - 20;
        UIPageControl *pagecontroler = [[UIPageControl alloc] initWithFrame:CGRectMake(x, y, width, height)];
        pagecontroler.pageIndicatorTintColor = [UIColor lightGrayColor];
        pagecontroler.currentPageIndicatorTintColor = [UIColor redColor];
        [Key_Window addSubview:pagecontroler];
        //这里也是用self.view的！
        _page = pagecontroler;
    }
    return _page;
}

//MARK:-1.生命周期
-(instancetype)init{
    //自定义布局来初始化
    return [super initWithCollectionViewLayout:[[NewPropertyFlowLayout alloc] init]];
}

-(void)viewDidLoad{
    [super viewDidLoad ];
    [self setUp];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.page.numberOfPages = self.guideImageArr.count;
}

-(void)dealloc{
    [self.page removeFromSuperview];
    self.page = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//MARK:-2.初始化
-(void)setUp{
    [self.collectionView registerClass:[NewPropertyCell class] forCellWithReuseIdentifier:cellIdetify];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished) name:PlayFinishedNotify object:nil];
    //TODO:-1.这里为何又来了个播放完成？？？
}
-(void)movieFinished{
    self.isOver = YES;
}

//MARK:-3.代理方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.guideImageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewPropertyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdetify forIndexPath:indexPath];
    cell.backImage = [UIImage imageNamed:self.guideImageArr[indexPath.item]];
    cell.videoPath = self.guideVideoArr[indexPath.item];
    self.isOver = NO;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.guideVideoArr.count - 1 && self.isOver == YES){
        //滑动到最后一个，并且已经播放完毕，然后才会执行跳转，也就是block的操作
        if (self.lastOnePlayFinishedBlock){
            self.lastOnePlayFinishedBlock();
        }
    }
}

//MARK:-4.scrollView的代理方法,使得页码控制和滚动联动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    uint pages = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    self.page.currentPage = pages;
}

@end
