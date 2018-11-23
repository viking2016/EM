//
//  ESSWebController.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/11.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSWebController.h"

#import <WebKit/WebKit.h>

@interface ESSWebController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy) void(^block)(void);

@end

@implementation ESSWebController

#pragma mark - Public Method

- (instancetype)initWithURLStr:(NSString *)URLStr viewWillDisappear:(void (^)(void))block {
    self = [super init];
    if (self) {
        self.navigationItem.title = @"请稍后...";
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLStr]]];
        self.webView.allowsBackForwardNavigationGestures = YES;
        [self.view addSubview:self.webView];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        
        if (block) {
            self.block = block;
        }
        
        // 添加KVO监听
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        
        // 设置进度条
        self.progressView = [[UIProgressView alloc] init];
        self.progressView.frame = self.view.bounds;
        [self.progressView setProgressTintColor:MAINCOLOR];
        [self.view addSubview:self.progressView];
    }
    return self;

}

- (instancetype)initWithURLStr:(NSString *)URLStr {
    return [self initWithURLStr:URLStr viewWillDisappear:nil];
}

#pragma mark - Private Method

#pragma mark - Navigation delegate

// 开始加载的回调函数
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.alpha = 1;
}

// 内容返回的回调函数
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
}

// 结束加载的回调函数
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIView animateWithDuration:0.5 animations:^{
        self.progressView.alpha = 0;
    }];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
    }
    if ([keyPath isEqualToString:@"title"]) {
        [self.navigationItem setTitle:self.webView.title];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.block) {
        self.block();
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    [self.webView removeObserver:self forKeyPath:@"title" context:nil];
}

@end
