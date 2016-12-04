//
//  Pickview.m
//  Music
//
//  Created by sunkai on 16/11/9.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "Pickview.h"

@interface Pickview ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic ) NSInteger timeInt; //获取选择的时间数字

@end


@implementation Pickview

#pragma mark - 初始化
-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        
        [self initPickerView:frame];
        [self initHeadView:frame];
    }
    return self;
}

#pragma mark - 添加头视图

- (void)initHeadView:(CGRect)frame{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    UIView *bheadView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 20)];

    headView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    bheadView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    headView.layer.cornerRadius = 10;
    bheadView.layer.borderWidth = 1;
    
    //MARK:-1.感觉这样写，还不如自己绘制
    UIButton *del = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 40, 36)];
    del.tag = 101;
    del.titleLabel.font = [UIFont systemFontOfSize:13];
    [del setTitle:@"取消" forState:UIControlStateNormal];
    [del setTitle:@"取消" forState:UIControlStateHighlighted];
    [del setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [del setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [del addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *ent = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 45, 2, 40, 36)];
    ent.tag = 102;
    ent.titleLabel.font = [UIFont systemFontOfSize:13];
    [ent setTitle:@"确定" forState:UIControlStateNormal];
    [ent setTitle:@"确定" forState:UIControlStateHighlighted];
    [ent setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [ent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [ent addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    [headView addSubview:del];
    [headView addSubview:ent];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 - 35, 2, 70, 36)];
    title.text = @"定时器";
    title.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:title];
    
    [self addSubview:bheadView];
    [self addSubview:headView];
}

#pragma mark -添加选择视图
- (void)initPickerView:(CGRect)frame{
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height-40)];
    self.pickerView.backgroundColor = [UIColor clearColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
}

#pragma mark - 代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 6;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (row) {
        case 0:
            return @"取消";
            break;
        case 1:
            return @"10Min";
            break;
        case 2:
            return @"20Min";
            break;
        case 3:
            return @"30Min";
            break;
        case 4:
            return @"40Min";
            break;
        case 5:
            return @"50Min";
            break;
            
        default:
            return @"返回";
            break;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (row) {
        case 1:
            _timeInt = 10;
            break;
        case 2:
            _timeInt = 20;
            break;
        case 3:
            _timeInt = 30;
            break;
        case 4:
           _timeInt = 40;
            break;
        case 5:
            _timeInt = 50;
            break;
            
        default:
          _timeInt = 0;
            break;
    }
}

#pragma mark -左右两侧的Button点击的方法
-(void)buttonClick:(UIButton * )button{
    NSInteger tag = button.tag;
    [self.delegate didSelectedPickerView:tag time:_timeInt];
}
@end

