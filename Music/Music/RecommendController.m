//
//  RecommendController.m
//  Music
//
//  Created by sunkai on 16/11/8.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "RecommendController.h"
#import "BaseScrollview.h"
#import "WebViewController.h"
#import "MyProfileViewController.h"
#import "SongAlbumViewController.h"
#import "CategoryMusicViewController.h"
#import "MoreClickViewController.h"

#import "MoreContentViewModel.h"
//对应的VM
#import "Pickview.h"
//时间选择器
#import "HeadScroller.h"
//头部的滚动


#import "MyProfileCell.h"
//我的cell,对于收藏和播放记录
#import "MoreCategoryCell.h"
//中间视图的cell以及跳转之后的，针对中间的专辑
#import "CategoryCell.h"
//乐库的cell

#import "PlistManger.h"
#import "NSObject+createPlist.h"
//用于生成Plist文件，只是用了一次

#import "TitleCategoryCell.h"
//每个分区的头视图，也就是个View

@interface RecommendController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,scrollDelegate,TitleViewDelegate>

/* 这个不知道什么时候使用,还是用于手势拖动*/
@property(nonatomic,strong)UIView *leftView;
@property(nonatomic,strong)UIView *backView;//蒙版
/*上边的两个视图还是依靠scrollView来进行的*/
//TODO:-2.感觉这个scrollView中不是已经含有left和back了么，为何还要进行添加
@property(nonatomic,strong)BaseScrollview *scroll;

/*上边用于放置按钮的视图*/
@property(nonatomic,strong)UIView *bottomView;


/** 页面 */
@property (nonatomic,strong) UITableView *tableView0;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;

@property (nonatomic,strong) NSMutableArray *KNamel; //存放的分组，比如精品，推荐，财经等，为了给乐库使用
@property (nonatomic,strong) NSMutableArray *myArray; //我的VC中的数据，从plist文件中获取，为了给我的使用，暂时没有用到

@property (nonatomic) BOOL isNav;

/*用于刚进入页面的视觉效果，是个占位符一样的图片显示，请求到结果之前的视图显示*/
@property (nonatomic, strong) UIView *yourSuperView;
@property (nonatomic, strong) UIImageView *imaView;


@property (nonatomic,strong) MoreContentViewModel *moreVM;
//对应的VM
@property (nonatomic, strong)Pickview *timePick;
//选择器时间
@property (nonatomic,strong)HeadScroller *scrollView;
//顶部的滚动视图

@end


@implementation RecommendController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scroll];
    [self initUI];
    [self initAdvView];
//    [self createPlist];
}

#pragma mark - 生成Plist文件,这里应该需要判断一下是否已经存在
-(void)createPlist{
    NSArray *values1 = @[@"我的收藏",@"播放历史",@"清理缓存",@"定时关机",@"关于希亚",@"联系我"];
    NSArray *values2= @[@"turntable_128px",@"compose_128px",@"gear_128px",@"meter_128px",@"lightbulb_128px",@"mail_128px"];
    NSString *path = @"mydata.plist";
    PlistManger *manager = [PlistManger shareInstance];
    [manager creatPlistWithArray:values1 withKey1:@"title" withOtherArray:values2 withOtherKey2:@"image" toPathName:path];
}
#pragma mark -出入设置
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden == YES){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
       if (_tableView0.frame.size.height == kScreenHeight-64) {
        
            [UIView animateWithDuration:0.2
                                animations:^{
                                    _tableView0.frame = CGRectMake(self.view.frame.size.width * 0, 0, self.view.frame.size.width, TableViewHeight);
                                    _tableView1.frame = CGRectMake(self.view.frame.size.width * 1, 0, self.view.frame.size.width, TableViewHeight);
                                    _tableView2.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, TableViewHeight);
                                 }];
            }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_tableView0.frame.size.height == kScreenHeight-64-49) {
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             _tableView0.frame = CGRectMake(self.view.frame.size.width * 0, 0, self.view.frame.size.width, TableViewHeight + 49);
                             _tableView1.frame = CGRectMake(self.view.frame.size.width * 1, 0, self.view.frame.size.width, TableViewHeight + 49);
                             _tableView2.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, TableViewHeight + 49);
                         }];
    }
}

#pragma mark - 初始化
-(void)initUI{
    //把创建的views设置为titleview
    self.navigationItem.titleView = self.bottomView;
    [self initBackItem];
    [self initTableView];
    [self initVM];
   
}

//VM的数据请求以及事件
-(void)initVM{
    [self.moreVM getDataCompletionHandle:^(NSError *error) {

        // 封装好的头部滚动视图
        _scrollView = [[HeadScroller alloc] initWithFocusImgMdoel:self.moreVM];
        _tableView1.tableHeaderView = self.scrollView.iView;
        
        __weak RecommendController *weakSelf = self;
        _scrollView.clickAction = ^(NSInteger index){
            
            RecommendController *innerSelf = weakSelf;
            if ([innerSelf.moreVM focusForIndex:index] == 2) {
                //表明是专辑，而不是榜单
                [innerSelf didSelectFocusImages2:index];
            }else {
                [innerSelf didSelectFocusImages3:index];
            }
            
            
        };
        _KNamel = [[NSMutableArray alloc] initWithArray:[self.moreVM tagsArrayForSection]];
        
        [_tableView1 reloadData];
        [_tableView2 reloadData];

        NSLog(@"推荐页面所有数据请求完成");
        [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:1];
        //延迟1s之后，隐藏掉
    }];
}

//返回按键以及基础设置
-(void)initBackItem{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

//初始化tableview，一次添加三个
-(void)initTableView{
    for (int i = 0; i < 3; i ++ ){
        if(i == 0){
            _tableView0 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64 - 49) style:UITableViewStyleGrouped];
            _tableView0.tag = 100 ;
            _tableView0.delegate = self;
            _tableView0.dataSource = self;
            _tableView0.backgroundColor = [UIColor redColor];
            
            [_tableView0 registerClass:[MyProfileCell class] forCellReuseIdentifier:MyCellIdentify];
            
            NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"mydata" ofType:@"plist"];
            _myArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
            //这里设定的是思数据
            //TODO:-5.这里一旦不注释掉，就crash
//            [self.scroll addSubview:_tableView0];
            
        }else if (i == 1) {
            
            _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, kScreenWidth,kScreenHeight  -64 - 49) style:UITableViewStyleGrouped];
            _tableView1.tag = 101;
            _tableView1.delegate = self;
            _tableView1.dataSource = self;
            
            //TODO:-1.一定要记住，注册cell
            [_tableView1 registerClass:[MoreCategoryCell class] forCellReuseIdentifier:MoreCategoryIdetify];
            
            _tableView1.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] ;
            
            [_tableView1 pm_RefreshHeaderWithBlock:^{
                
                [self.moreVM getDataCompletionHandle:^(NSError *error) {
                    
                    [_tableView1 reloadData];
                    [_scrollView.carousel reloadData];
                    [_tableView1 endRefresh];
                    
                }];
                
            }];
            
            
            [self.scroll addSubview:_tableView1];
        }else{
            _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(2 * self.view.frame.size.width, 0, kScreenWidth, kScreenHeight -64 - 49) style:UITableViewStyleGrouped];
            _tableView2.tag = 102;
            _tableView2.delegate = self;
            _tableView2.dataSource = self;
            
            //TODO:-2.还是同样的问题，要记住进行注册
            [_tableView2 registerClass:[CategoryCell class] forCellReuseIdentifier:MoreCategoryIdetify1];
            
            _tableView2.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];

            [self.scroll addSubview:_tableView2];
        }
        
    }
//       self.scroll.contentOffset = CGPointMake(0, 0);

}

//整体视图的滚动视图的get方法
-(BaseScrollview *)scroll{
    if (!_scroll){
        _scroll = [[BaseScrollview alloc]initWithFrame:CGRectMake(0 , 0, kScreenWidth, kScreenHeight)];
        _scroll.contentSize = CGSizeMake(kScreenWidth * 3, 0);
        _scroll.pagingEnabled = YES;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.delegate = self;
        _scroll.sdelegate = self;
        _scroll.bounces = NO;
        _scroll.backgroundColor = [UIColor blueColor];
        _scroll.contentOffset = CGPointMake(kScreenWidth, 0);
        //显示的总是中间的这一个
        _scroll.alwaysBounceVertical = NO;
    }
    return _scroll;
}
//底部视图的get方法
-(UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 40)];
        //添加三个Button
        NSArray *titles = @[@"我的",@"推荐",@"乐库"];
        for(int i = 0;i < 3;i++){
            UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(self.view.frame.size.width/ 2 - 150 + (i * 100), 0, ButtonWidth, ButtonHeight);
            [button setTitle:titles[i] forState:UIControlStateNormal];
            if (i == 1){
                button.titleLabel.font = [UIFont fontWithName:ButtonFont size:18];
                [button setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
            }else{
                button.titleLabel.font = [UIFont fontWithName:ButtonFont size:15];
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(tbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
             button.tag = 1000 + i;
            [_bottomView addSubview:button];
        }

    }
    return _bottomView;
}

#pragma mark - 添加启动动画,不过这里是给imageview添加的动画组
-(void)initAdvView{
    _yourSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _yourSuperView.backgroundColor = RGBColor(0.678*255, 0.678*255, 0.678*255);
    
    //为了启动动画组，添加图片，不过都是同一张
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=9; i++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"music"]];
        [refreshingImages addObject:image];
    }
    
    _imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-170, kScreenHeight/2-200, 340, 340)];
    _imaView.animationImages = refreshingImages;
    
     [_yourSuperView addSubview:_imaView];
    
    [self.view addSubview:_yourSuperView];
     _yourSuperView.hidden = NO;

    //设置执行一次完整动画的时长
    _imaView.animationDuration = 9*0.15;
    //动画重复次数 （0为重复播放）
    _imaView.animationRepeatCount = 5;
    [_imaView startAnimating];


}

- (void)removeAdvImage{
    [UIView animateWithDuration:0.1f animations:^{
        _yourSuperView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        _yourSuperView.alpha = 0.f;
    } completion:^(BOOL finished) {
        //[_yourSuperView removeFromSuperview];//会直接移除，不能再次使用，故使用隐藏
        _yourSuperView.hidden = YES;
    }];
}

#pragma mark - scrollView的代理方法，这里实际上经过了两次代理的方法调用,然后跳转到需要的网页
-(void)scrollWebVC:(NSURL *)url{
    WebViewController *web = [[WebViewController alloc] init];
    web.URL = url;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - 上侧的Button点击之后的方法
-(void)tbuttonClick:(UIButton *)button{

    NSInteger clickTag = button.tag;
    switch (clickTag) {
        case 1000:
           [_tableView0 reloadData];
            _isNav = YES;
           [self.scroll setContentOffset:CGPointMake(0, -64) animated:YES];
           [self FontAndColorSettingOfButtonsWithTag:clickTag];
            break;
        case 1001:
            [_tableView1 reloadData];
            //包含广告视图的刷新
            [_scrollView.carousel reloadData];
             [self.scroll setContentOffset:CGPointMake(kScreenWidth, -64) animated:YES];
             [self FontAndColorSettingOfButtonsWithTag:clickTag];
            break;
        case 1002:
            [_tableView2 reloadData];
            [self.scroll setContentOffset:CGPointMake(self.view.frame.size.width*2, -64) animated:YES];
            [self FontAndColorSettingOfButtonsWithTag:clickTag];
            break;
        default:
            break;
    }
}

-(void)FontAndColorSettingOfButtonsWithTag:(NSInteger)clickTag{
    NSArray *views =[self.bottomView subviews];
    for (UIButton *button  in  views){
        if (button.tag == clickTag){
            [button setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:18];
        }else{
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             button.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:15];
        }
    }
}

#pragma mark - 和上边的点击滚动类似，不过下边的额是scrollView的滚动，也就是代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSString *str = [[NSString alloc] initWithFormat:@"%@",[scrollView class]];
    if ([str isEqualToString:@"BaseScrollview"]){
        CGFloat offsetX = scrollView.contentOffset.x;
        if (offsetX == 0){
            [_tableView0 reloadData];
            [self FontAndColorSettingOfButtonsWithTag:1000];
        }
        if (offsetX == kScreenWidth){
            [_tableView1 reloadData];
            [_scrollView.carousel reloadData];
            [self FontAndColorSettingOfButtonsWithTag:1001];

        }
        if (offsetX == 2 * kScreenWidth){
            [_tableView2 reloadData];
            [self FontAndColorSettingOfButtonsWithTag:1002];
        }
    }
}

#pragma mark - tableview的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 100){
        return 6;
    }
    if (tableView.tag == 101){
        return self.moreVM.sectionNumber;
    }
    return _KNamel.count;
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 101){
        return [self.moreVM rowForSection:section];
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 101){
        //这里需要自己定义的一个带有更多选项的头
        if (section == 0) {
            return nil;
        }else{
            TitleCategoryCell *titleview = [[TitleCategoryCell alloc] initWithTitle:[self.moreVM mainTitleForSection:section] hasMore:[self.moreVM hasMoreForSection:section] titleTag:section];
            titleview.delegate = self;
            return titleview;
        }
        
    }
    return  nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100){
        return 0.0001;
        //统一很小
    }
    if (tableView.tag == 101){
        return section == 0 ? 0 : 35;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag == 100){
        return 0.001;
    }
    return  10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 102){
        return self.view.frame.size.width * 0.4;
    }
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    if (tableView.tag == 100) {
        
        MyProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentify];
        
        [cell setAct:_myArray[indexPath.section]];
        
        return cell;
    }
    if (tableView.tag == 101){
        if (indexPath.section == 0) {
            static NSString *cellID = @"TCell101";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.imageView.image = [UIImage imageNamed:@"music_tuijian"];
            cell.textLabel.text = [self.moreVM titleForIndexPath:indexPath];
            cell.detailTextLabel.text = [self.moreVM subTitleForIndexPath:indexPath];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }  else {
            MoreCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCategoryIdetify];
            [cell.coverBtn setImageForState:UIControlStateNormal withURL:[self.moreVM coverURLForIndexPath:indexPath] placeholderImage:[UIImage imageNamed:@"find_albumcell_cover_bg"]];
            cell.titleLb.text = [self.moreVM titleForIndexPath:indexPath];
            cell.introLb.text = [self.moreVM subTitleForIndexPath:indexPath];
            cell.playsLb.text = [self.moreVM playsForIndexPath:indexPath];
            cell.tracksLb.text = [self.moreVM tracksForIndexPath:indexPath];
            return cell;

        }
    }
    
    if (tableView.tag == 102){
        
        CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCategoryIdetify1];
        [cell setTitle:_KNamel[indexPath.section]];
        
        return cell;
    }
    
    //如果不存在的话，仅仅显示系统的，并且提示错误
    static NSString *cellID = @"cell111";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"无法显示";
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];

     if (tableView.tag == 100) {
       //这里会涉及到6个东西
         
         if (indexPath.section == 0) {
             //我的收藏
             MyProfileViewController *myView = [[MyProfileViewController alloc]init];
//             myView.itemModel = favoritelItem;
             _isNav = YES;
             [self.navigationController pushViewController:myView animated:YES];
             
         }
         if (indexPath.section == 1) {
              //我的播放记录
             MyProfileViewController *myView = [[MyProfileViewController alloc]init];
             //             myView.itemModel = historyItem;
             _isNav = YES;
             [self.navigationController pushViewController:myView animated:YES];
             
         }
         
      
        if (indexPath.section == 2) {
             //清除缓存
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清除缓存吗" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
             UIAlertAction* defaultAction0 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive
                                                                    handler:^(UIAlertAction * action) {
                                                                        [self alertTextFiledDidChanged];
                                                                    }];
             UIAlertAction* defaultAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                                    handler:^(UIAlertAction * action) {
                                                                        
                                                                    }];
             
             [alert addAction:defaultAction0];
             [alert addAction:defaultAction1];
             
             [self presentViewController:alert animated:YES completion:nil];

         }
         if(indexPath.section == 3){
              //定时设计
//             [_pickerView removeFromSuperview];
             [_backView removeFromSuperview];
             
             UIWindow *window = [UIApplication sharedApplication].keyWindow;
//             self.pickerView = [[FYPickerView alloc] initWithFrame:CGRectMake(s_WindowW/2-140, s_WindowH+200, 280, 200)];
             self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
             self.backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
//             self.pickerView.delegate = self;
             [window addSubview:self.backView];
//             [window addSubview:self.pickerView];
             
             CGContextRef context = UIGraphicsGetCurrentContext();
             [UIView beginAnimations:nil context:context];
             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
             [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
             [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
//             self.pickerView.frame = CGRectMake(kScreenWidth/2-140, kScreenHeight/2-100, 280, 200);
//             self.backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:self.pickerView.frame.origin.y/kScreenHeight];
             
             [UIView setAnimationDelegate:self];
             [UIView commitAnimations];
         }
         
         if(indexPath.section == 4){
             //关于
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关于希亚音乐" message:@"仅仅是为了练手" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {}];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
         if(indexPath.section == 5){
             //开发者
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"开发者" message:@"903797097Vampile" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       
                                                                   }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }

         
     }
    
     if (tableView.tag == 101) {
           // 从本控制器VM获取头标题, 以及分类ID回初始化
         SongAlbumViewController *song = [[SongAlbumViewController alloc] initWithAlbumId:[self.moreVM albumIdForIndexPath:indexPath] title:[self.moreVM titleForIndexPath:indexPath]];
         [self.navigationController pushViewController:song animated:YES];
         
     }
    
     if (tableView.tag == 102) {
         //暂时这样写
         CategoryMusicViewController *category =[[CategoryMusicViewController alloc] init];
          category.keyName = _KNamel[indexPath.section];
          [self.navigationController pushViewController:category animated:YES];
     }
}

#pragma mark - 清除缓存,MB竟然也是有进度条的
-(void)alertTextFiledDidChanged{
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    //加载条上显示文本
    hud.label.text = @"正在清理中";
    //设置对话框样式
    hud.mode = MBProgressHUDModeDeterminate;
//    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_global_queue(0, 0));
//    dispatch_source_set_event_handler(source, ^{
//        //清除内存,这里只是借助SD来清理了图片
//        [[SDImageCache sharedImageCache] clearMemory];
//        [self.tableView0 reloadData];
//        [self.tableView1 reloadData];
//        [self.tableView2 reloadData];
//        [hud removeFromSuperview];
//    });
//    dispatch_resume(source);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while (hud.progress < 1.0) {
//            hud.progress += 0.01;
//            [NSThread sleepForTimeInterval:0.02];
//        }
//        hud.label.text = @"清理完成";
//        dispatch_source_merge_data(source, 1);//通知队列
//    });
    [hud showAnimated:YES whileExecutingBlock:^{
        while (hud.progress < 1.0) {
            hud.progress += 0.01;
            [NSThread sleepForTimeInterval:0.02];
        }
        hud.label.text = @"清理完成";
    } completionBlock:^{
        //清除内存
        [[SDImageCache sharedImageCache] clearMemory];
        [self.tableView0 reloadData];
        [self.tableView1 reloadData];
        [self.tableView2 reloadData];
        [hud removeFromSuperview];
    }];

  
}

#pragma mark - 点击上册的广告视图之后，根据type不同跳转到不同的页面,2对应的是专辑，3对应的是榜单，也就是需要再点击一次，在可以进入专辑页面

- (void)didSelectFocusImages2:(NSInteger )index{
    
    SongAlbumViewController *vc = [[SongAlbumViewController alloc] initWithAlbumId:[self.moreVM albumIdForIndex:index] title:[self.moreVM titleForIndex:index]];

    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didSelectFocusImages3:(NSInteger )index{
    
    CategoryMusicViewController *vc = [[CategoryMusicViewController alloc] init];
    vc.keyName = @"榜单";
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击头地图之后的跳转
-(void)titleViewDidClick:(NSInteger)tag{
//    [UIView showMiddleHint:@"更多" toView:self.view];
    //根据tag值获取当前点击的section的title，实际上也就是section
    NSString *title = [self.moreVM mainTitleForSection:tag];
    MoreClickViewController  *clickVC = [[MoreClickViewController alloc] init];
    clickVC.keyName = title;
    [self.navigationController pushViewController:clickVC animated:YES];
   
}
#pragma mark -VM的get方法
-(MoreContentViewModel *)moreVM{
    if (!_moreVM){
        _moreVM = [[MoreContentViewModel alloc] initWithCategoryId:2 contentType:@"album"];
        //实际上，原本的链接中id应该是1
        //MARK:-6.这里请求的是固定的死数据，原本应该是自己设定的参数
    }
    return _moreVM;
}


@end

