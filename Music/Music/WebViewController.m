//
//  WebViewController.m
//  Music
//
//  Created by sunkai on 16/11/5.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

//注意这里用的是WKWebview

@interface WebViewController ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;//旋转轮廓
@property (nonatomic, strong) UIProgressView *progressView; //进度条

@end

@implementation WebViewController

//直接把views给替换掉，用自定义的webview来代替
- (void)loadView{
    
    self.webView = [[WKWebView alloc] init];
    // 导航代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    self.view = self.webView;
    //开启手势触摸
    self.webView.allowsBackForwardNavigationGestures = YES;//开启手势
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupnav];
    [self initViews];//加载时候的圈圈
    [self addProgressview];
}

#pragma mark - 初始化头部
-(void)setupnav{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
#pragma mark - 设置上册的活动框
-(void)initViews{
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-15, [UIScreen mainScreen].bounds.size.height/2-85, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
}
#pragma mark - 添加类似网页的那种进度条
-(void)addProgressview{
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    self.progressView = [[UIProgressView alloc] initWithFrame: windowFrame];
    [self.view addSubview:self.progressView];
}

#pragma mark - 重写set方法
-(void)setURL:(NSURL *)URL{
    _URL = URL;
    if (_URL){
        NSURLRequest *request = [NSURLRequest requestWithURL:_URL];
        [(WKWebView *)self.view loadRequest:request];
    }
}
#pragma mark - 添加观察者
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    self.hidesBottomBarWhenPushed = YES;
    //隐藏 tabBar 在navigationController结构中
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //观察者添加
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 移除观察者
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    //KVO也都要进行移除
    [self.webView removeObserver:self forKeyPath:@"loading" context:nil];
    [self.webView removeObserver:self forKeyPath:@"title" context:nil];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
}

#pragma mark - 真正的而观察
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loading"]){
        NSLog(@"正在加载...");
    }
    if ([keyPath isEqualToString:@"title"]){
        self.title = self.webView.title;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]){
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    //加载完成,改变进度条的透明度
    if (self.progressView.progress == 1.0 ) {
        NSLog(@"加载完成");
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0.0;
        }];
    }
}

#pragma mark WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *schemeName = navigationAction.request.URL.scheme.lowercaseString;
    NSLog(@"你好%@",schemeName);
    
    if ( [schemeName containsString:@"bainuo"])//containsString 8.0之后才有 wk也是8.0之后，所以不需要判断
    {
        
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}

#pragma mark WKUIDelegate
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)())completionHandler;{
    
}

#pragma mark - WKScriptMessageHandler
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}

#pragma mark - WebView 前进 后退 刷新 取消

- (void)backButtonPush:(UIButton *)button{
    if (self.webView.canGoBack){
        [self.webView goBack];
    }
}
- (void)forwardButtonPush:(UIButton *)button{
    if (self.webView.canGoForward){
        [self.webView goForward];
    }else{
        //[self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)reloadButtonPush:(UIButton *)button{
    
    [self.webView reload];
}

- (void)stopButtonPush:(UIButton *)button{
    
    if (self.webView.loading){
        
        [self.webView stopLoading];
    }
    
}
@end
