//
//  MenuView.m
//  DynamicMenu
//
//  Created by sunkai on 16/11/21.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MenuView.h"
#import "MenuCell.h"
#import "MenuModel.h"

#define MENU_TAG 99999  // MenuView的tag
#define BACKVIEW_TAG 88888  // 背景遮罩view的tag
#define KRowHeight 40   // cell行高
#define KDefaultMaxValue 6  // 菜单项最大值
#define KNavigationBar_H 64 // 导航栏64
#define KIPhoneSE_ScreenW 375
#define KMargin 15

@interface MenuView() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIImageView * imageView; //放在菜单的底部视图，上边是表格视图
@property (nonatomic,strong) UIView * backView; //放在当前菜单所处的VC上
@property (nonatomic,assign) CGRect rect; //存放的是表格视图的大小
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UIViewController * target;


@end

@implementation MenuView

#pragma mark -- setDataArray
- (void)setDataArray:(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[MenuModel class]]) {
            MenuModel *model = [MenuModel MenuModelWithDict:(NSDictionary *)obj];
            [_dataArray addObject:model];
        }
    }];
}
#pragma mark 限定最多添加的iitem个数
- (void)setMaxValueForItemCount:(NSInteger)maxValueForItemCount{
    if (maxValueForItemCount <= KDefaultMaxValue) {
        _maxValueForItemCount = maxValueForItemCount;
    }else{
        _maxValueForItemCount = KDefaultMaxValue;
    }
}

#pragma mark -- Create Menu
+ (MenuView *)createMenuWithFrame:(CGRect)frame target:(UIViewController *)target dataArray:(NSArray *)dataArray itemsClickBlock:(void (^)(NSString *, NSInteger))itemsClickBlock backViewTap:(void (^)())backViewTapBlock{
    
    // 计算frame
    CGFloat factor = [UIScreen mainScreen].bounds.size.width < KIPhoneSE_ScreenW ? 0.36 : 0.3; // 适配比例
    CGFloat width = frame.size.width ? frame.size.width : [UIScreen mainScreen].bounds.size.width * factor;
    CGFloat height = dataArray.count > KDefaultMaxValue ? KDefaultMaxValue * KRowHeight : dataArray.count * KRowHeight;
    //如果个数大于默认的6个，就会显示最大的高度，否则根据个数来显示高度
    CGFloat x = frame.origin.x ? frame.origin.x : [UIScreen mainScreen].bounds.size.width - width - KMargin * 0.5;
    CGFloat y = frame.origin.y ? frame.origin.y : KNavigationBar_H - KMargin * 0.5;
    CGRect rect = CGRectMake(x, y, width, height);    // 菜单中tableView的frame
    frame = CGRectMake(x, y, width, height + KMargin); // 菜单的整体frame
    
    MenuView *menuView = [[MenuView alloc] init];
    menuView.tag = MENU_TAG;
    menuView.frame = frame;
    //下边的点算是右上角的那个角
    menuView.layer.anchorPoint = CGPointMake(1, 0);
    menuView.layer.position = CGPointMake(frame.origin.x + frame.size.width , frame.origin.y);
    menuView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    menuView.target = target;
    menuView.dataArray = [NSMutableArray arrayWithArray:dataArray];
    menuView.itemsClickBlock = itemsClickBlock;
    menuView.backViewTapBlock = backViewTapBlock;
    menuView.maxValueForItemCount = dataArray.count;
    [menuView setUpUIWithFrame:rect];
    [target.view addSubview:menuView];
    return menuView;
}

#pragma mark -- initMenu
- (void)setUpUIWithFrame:(CGRect)frame{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:@"pop_black_backGround"];
    imageView.layer.anchorPoint = CGPointMake(1, 0);
    imageView.layer.position = CGPointMake(self.bounds.size.width, 0);
    self.imageView = imageView;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, frame.size.width, frame.size.height)];
    //注意:这里的15，是和上边的margin是一致的
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = KRowHeight;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MenuCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.target.view.bounds.size.width, self.target.view.bounds.size.height)];
    //注意：自己认为这个view，必须是最后加上的，也就是menu添加上的时候，也添加上了，不过因为这里设置为alpha
    //是0，那就没事了
    backView.backgroundColor = [UIColor blackColor];
    backView.userInteractionEnabled = YES;
    backView.alpha = 0.0;
    backView.tag = BACKVIEW_TAG;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [backView addGestureRecognizer:tap];
    self.backView = backView;
    
    [self.target.view addSubview:backView];
    [self addSubview:imageView];
    [self addSubview:self.tableView];
}

#pragma mark -- Adjust Menu Frame 公共方法，不论是添加还是删除都是都会进行调用
- (void)adjustFrameForMenu{
    
    MenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:MENU_TAG];
    menuView.maxValueForItemCount = menuView.dataArray.count;
    
    CGRect rect = CGRectMake(menuView.tableView.frame.origin.x, menuView.tableView.frame.origin.y, menuView.tableView.frame.size.width, KRowHeight * menuView.maxValueForItemCount);
    CGRect frame = CGRectMake(menuView.frame.origin.x, menuView.frame.origin.y, menuView.frame.size.width,  (menuView.maxValueForItemCount * KRowHeight + KMargin) * 0.01);
    
    menuView.tableView.frame = rect;   // 根据菜单项，调整菜单内tableView的大小
    menuView.frame = frame;     // 根据菜单项，调整菜单的整体frame
}

#pragma mark -- UITapGestureRecognizer 背景视图点击触发
- (void)tap:(UITapGestureRecognizer *)sender{
    [MenuView showMenuWithAnimation:NO];
    if (self.backViewTapBlock) {
        self.backViewTapBlock();
    }
}
#pragma mark -- layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.bounds = self.bounds;
}

#pragma mark -- Show With Animation 没懂？？？
+ (void)showMenuWithAnimation:(BOOL)isShow{
    
    MenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:MENU_TAG];
    UIView *backView = [[UIApplication sharedApplication].keyWindow viewWithTag:BACKVIEW_TAG];
    menuView.tableView.contentOffset = CGPointZero;
    [UIView animateWithDuration:0.25 animations:^{
        if (isShow) {
            menuView.alpha = 1;
            backView.alpha = 0.1;
            menuView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }else{
            menuView.alpha = 0;
            backView.alpha = 0;
            menuView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
    }];
}
#pragma mark -- Append Menu Items
+ (void)appendMenuItemsWith:(NSArray *)appendItemsArray{
    
    MenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:MENU_TAG];
    NSMutableArray *tempMutableArr = [NSMutableArray arrayWithArray:menuView.dataArray];
    [tempMutableArr addObjectsFromArray:appendItemsArray];
    menuView.dataArray = tempMutableArr;
    
    [menuView.tableView reloadData];
    [menuView adjustFrameForMenu];
}

#pragma mark -- Update Menu Items
+ (void)updateMenuItemsWith:(NSArray *)newItemsArray{
    
    MenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:MENU_TAG];
    [menuView.dataArray removeAllObjects];
    menuView.dataArray = [NSMutableArray arrayWithArray:newItemsArray];
    
    [menuView.tableView reloadData];
    [menuView adjustFrameForMenu];
}

#pragma mark -- Hidden & Clear
+ (void)hidden{
    [MenuView showMenuWithAnimation:NO];
}

+ (void)clearMenu{
    [MenuView showMenuWithAnimation:NO];
    MenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:MENU_TAG];
    UIView *backView = [[UIApplication sharedApplication].keyWindow viewWithTag:BACKVIEW_TAG];
    [menuView removeFromSuperview];
    [backView removeFromSuperview];
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuModel *model = self.dataArray[indexPath.row];
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.menuModel = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuModel *model = self.dataArray[indexPath.row];
    NSInteger tag = indexPath.row + 1;
    if (self.itemsClickBlock) {
        self.itemsClickBlock(model.itemName,tag);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KRowHeight;
}



@end
