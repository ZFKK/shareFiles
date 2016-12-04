//
//  ZFListViewModel.m
//  MVVMTest
//
//  Created by sunkai on 16/12/4.
//  Copyright © 2016年 JInCe. All rights reserved.
//

#import "ZFListViewModel.h"
#import "ZFCollectionViewModel.h"

@interface ZFListViewModel()

@property (nonatomic, assign) NSInteger currentPage;//当前页码

@end

@implementation ZFListViewModel

#pragma mark --重写父类的初始化方法，实际上也就是协议方法
-(void)ZF_initialize{
    @weakify(self);
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        NSMutableArray *alArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 8; i++) {
            ZFCollectionViewModel *viewModel = [[ZFCollectionViewModel alloc] init];
            //http://img.ivsky.com/img/bizhi/slides/201611/02/01_63944.jpg
            viewModel.headerImageStr = @"http://img.ivsky.com/img/bizhi/slides/201611/02/01_63944.jpg";
            viewModel.name = @"MVVM的测试";
            [alArray addObject:viewModel];
        }
        self.listHeaderViewModel.dataArray = alArray;
        //上侧的数据
        
        //感觉这里就是modle的赋值
        NSMutableArray *reArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 8; i++) {
            
            ZFCollectionViewModel *viewModel = [[ZFCollectionViewModel alloc] init];
            //http://img.ivsky.com/img/bizhi/slides/201611/02/xibu_shijie-006.jpg
            viewModel.headerImageStr = @"http://img.ivsky.com/img/bizhi/slides/201611/02/xibu_shijie-006.jpg";
            viewModel.name = @"自定义cell的title";
            viewModel.articleNum = @"1568";
            viewModel.peopleNum = @"568";
            viewModel.topicNum = @"5749";
            viewModel.content = @"别人家的孩子都结婚了，我们却都还在外边漂泊。。。。";
            [reArray addObject:viewModel];
        }
        
        self.dataArray = reArray;
        //给VC对应的VM，添加数据数组
        
        [self.listHeaderViewModel.refreshUISubject sendNext:nil];
        [self.refreshEndSubject sendNext:@(ZFFooterRefresh_HasMoreData)];
        DismissHud();
        //这里就是请求数据的地方，不过这里是死数据，所以直接消除
    }];
    
    //表示跳过第一个信号，然后只是取紧接着的一个信号
    [[[self.refreshDataCommand.executing skip:1] take:1] subscribeNext:^(id x) {
        
        if ([x isEqualToNumber:@(YES)]) {
            
            ShowMaskStatus(@"正在加载");
        }
    }];
    
    //这里command都是用来执行UI之后的一段任务
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        
        @strongify(self);
        
        NSMutableArray *reArray = [[NSMutableArray alloc] initWithArray:self.dataArray];
        for (int i = 0; i < 8; i++) {
            
            ZFCollectionViewModel *viewModel = [[ZFCollectionViewModel alloc] init];
            viewModel.headerImageStr = @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5";
            viewModel.name = @"财税培训圈子";
            viewModel.articleNum = @"1568";
            viewModel.peopleNum = @"568";
            viewModel.topicNum = @"5749";
            viewModel.content = @"自己交保险是不是只能交养老和医疗，费用是多少?";
            [reArray addObject:viewModel];
        }
        
        self.dataArray = reArray;
        [self.refreshEndSubject sendNext:@(ZFFooterRefresh_HasMoreData)];
        DismissHud();
    }];
    

}

#pragma mark --section的VM 
-(ZFListSectionHeaderViewModel *)sectionHeaderViewModel{
    if(!_sectionHeaderViewModel){
        _sectionHeaderViewModel = [[ZFListSectionHeaderViewModel alloc] init];
        _sectionHeaderViewModel.title = @"竖直方向的VM";
    }
    return _sectionHeaderViewModel;
}

#pragma mark --上侧的滚动视图VM
-(ZFListHeaderViewModel *)listHeaderViewModel{
    if(!_listHeaderViewModel){
        _listHeaderViewModel = [[ZFListHeaderViewModel alloc] init];
        _listHeaderViewModel.title = @"横向滚动的VM";
        _listHeaderViewModel.cellClickSubject = self.cellClickSubject;
    }
    return _listHeaderViewModel;
}

#pragma mark --存放需要的数据数组
-(NSArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

#pragma mark --点击cell的信号
-(RACSubject *)cellClickSubject{
    if(!_cellClickSubject){
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

#pragma mark --当前进行刷新的command
-(RACCommand *)refreshDataCommand{
    if (!_refreshDataCommand){
        @weakify(self);
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            //执行命令
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                //返回的信号，用来传递数据
                self.currentPage = 1;
                [self.request POST:REQUEST_URL parameters:nil success:^(ZFRequest *request, NSString *responseString) {
//                    NSDictionary *dict = [responseString objectFromJSONString];
                    [subscriber sendNext:responseString];
                    [subscriber sendCompleted];
                } failure:^(ZFRequest *request, NSError *error) {
                    ShowErrorStatus(@"网络连接失败");
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    
    return  _refreshDataCommand;
}

#pragma mark --加载更多的时候，任务的懒加载方法
-(RACCommand *)nextPageCommand{
    if(!_nextPageCommand){
        @weakify(self);
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                self.currentPage ++;
                [self.request POST:REQUEST_URL parameters:nil success:^(ZFRequest *request, NSString *responseString) {
                    
//                    NSDictionary *dict = [responseString objectFromJSONString];
                    [subscriber sendNext:responseString];
                    [subscriber sendCompleted];
                    
                } failure:^(ZFRequest *request, NSError *error) {
                    
                    @strongify(self);
                    self.currentPage --;
                    ShowErrorStatus(@"网络连接失败");
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _nextPageCommand;
}

#pragma mark --懒加载
-(RACSubject *)refreshUI{
    //刷新UI
    if (!_refreshUI){
        _refreshUI = [RACSubject subject];
    }
    return _refreshUI;
}

-(RACSubject *)refreshEndSubject{
    if (!_refreshEndSubject){
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}
@end
