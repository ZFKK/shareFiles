//
//  MenuView.m
//  Music
//
//  Created by sunkai on 16/11/14.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MenuView.h"
#import "MenuCell.h"

#import "UIView+Dismen.h"


@interface MenuView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) CGPoint     origin;
@property (nonatomic, assign) CGFloat     width;

// 遮罩
@property (nonatomic, strong) UIView      *maskView;

// 内容
@property (nonatomic, strong) UIView      *contentView;
@property (nonatomic, strong) UIView      *triangleView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MenuView

- (instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width {
    self = [super init];
    if (self) {
        
        _separatorColor = [UIColor blackColor];
        _rowHeight = 30;
        _triangleFrame = CGRectMake(width - 25, 0, 16, 12);
        
        // 背景
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.maskView.backgroundColor = [UIColor lightGrayColor];
        self.maskView.alpha = .7f;
        [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        
        // 内容
        self.origin = origin;
        self.width = width;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, self.rowHeight * self.items.count + CGRectGetHeight(self.triangleFrame) + 5)];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // 三角形
        [self _applytriangleView];
        
        // item
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(self.triangleFrame) + 5, width + 10, self.rowHeight * self.items.count + 5) style:UITableViewStylePlain];
        [self.tableView registerClass:[MenuCell class] forCellReuseIdentifier:@"MenuCell"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.bounces = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorColor = self.separatorColor;
        self.tableView.layer.cornerRadius = 2;
        self.tableView.tableFooterView = [[UIView alloc] init];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
        [self.contentView addSubview:self.tableView];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.model = self.items[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismiss];
    if (self.didSelectMenuItem) {
        self.didSelectMenuItem(self, self.items[indexPath.row]);
    }
}

- (void)_applytriangleView {
    if (self.triangleView == nil) {
        self.triangleView = [[UIView alloc] init];
        self.triangleView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.triangleView];
    }
    self.triangleFrame = CGRectMake(CGRectGetMinX(self.triangleFrame), self.contentView.frame.size.height - 12, CGRectGetWidth(self.triangleFrame), CGRectGetHeight(self.triangleFrame));
    self.triangleView.frame = self.triangleFrame;
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, CGRectGetWidth(self.triangleFrame) / 2.0, 12 );
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 0, self.contentView.frame.size.height);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, CGRectGetWidth(self.triangleFrame), CGRectGetHeight(self.triangleFrame));
    shaperLayer.path = path;
    self.triangleView.layer.mask = shaperLayer;
}

#pragma mark - setter
//- (void)setItems:(NSMutableArray *)items {
//    _items = items;
//    
//    self.contentView.frameHeight = self.rowHeight * self.items.count + CGRectGetHeight(self.triangleFrame) + 5;
//    self.tableView.frameHeight = self.rowHeight * self.items.count;
//    [self.tableView reloadData];
//    
//}

- (void)settriangleFrame:(CGRect)triangleFrame {
    _triangleFrame = triangleFrame;
    
    self.contentView.frameHeight = self.rowHeight * self.items.count + CGRectGetHeight(self.triangleFrame) + 5;
    self.tableView.frameHeight = self.rowHeight * self.items.count;
    [self _applytriangleView];
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    self.tableView.separatorColor = separatorColor;
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
    
    self.contentView.frameHeight = self.rowHeight * self.items.count + CGRectGetHeight(self.triangleFrame) + 5;
    self.tableView.frameHeight = self.rowHeight * self.items.count;

    [self.tableView reloadData];
}

#pragma mark - public
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskView];
    [window addSubview:self.contentView];
    //    self.contentView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    self.contentView.alpha = 0.0f;
    self.maskView.alpha = .0f;
    [UIView animateWithDuration:.35 animations:^{
        self.contentView.alpha = 1.0;
        //        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.maskView.alpha = .2f;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.15 animations:^{
        //        self.contentView.transform = CGAffineTransformMakeScale(.5f, .5f);
        self.contentView.alpha = 0.0f;
        self.maskView.alpha = .0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.maskView removeFromSuperview];
            [self.contentView removeFromSuperview];
        }
    }];
}

#pragma mark -- get方法
-(NSMutableArray *)items{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *menuImages = @[@"turntable_128px",@"compose_128px",@"gear_128px",@"meter_128px",@"lightbulb_128px",@"mail_128px"];
    NSArray *menuTitles = @[@"我的收藏",@"播放历史",@"清理缓存",@"定时关机",@"关于希亚",@"联系我"];
    for (int i = 0; i < menuImages.count; i++) {
        MenuItem *item = [MenuItem navigationBarMenuItemWithImage:[UIImage imageNamed:menuImages[i]] title:menuTitles[i]];
        [arr addObject:item];
    }
    return arr;
}


@end
