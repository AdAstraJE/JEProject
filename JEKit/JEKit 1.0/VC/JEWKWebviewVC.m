
#import "JEWKWebviewVC.h"
#import "JEKit.h"

@interface JEWKWebviewVC ()<WKUIDelegate,WKNavigationDelegate>{
    CGFloat _webVHeight;
    UIProgressView *_progressV;
    UIView *_Ve_tool;
    UIButton *_Btn_back,*_Btn_forward;///< 返回 前进
    
}

@end

@implementation JEWKWebviewVC

- (void)dealloc{
    jkDeallocLog; [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

+ (void)Open:(NSString *)url{
    [[[JEWKWebviewVC alloc] initWithUrl:url] showVC];
}

- (instancetype)initWithUrl:(NSString*)url{
    self = [super init];
    _H5Url = url;
    return self;
}

- (instancetype)initWithHTMLString:(NSString*)HTMLStr{
    self = [super init];
    _HTMLString = HTMLStr;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup_KWWebViewUI];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [_progressV setAlpha:1.0f];
    BOOL animated = _webView.estimatedProgress > _progressV.progress;
    [_progressV setProgress:_webView.estimatedProgress animated:animated];
    
    if(_webView.estimatedProgress >= 1.0f) {
        [UIView animateWithDuration:0.2f delay:0.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self->_progressV setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self->_progressV setProgress:0.0f animated:NO];
        }];
    }
    
    if (_webView.title.length) {
        self.title = _webView.title;
    }
    
    _Ve_tool.hidden = (!_webView.canGoBack && !_webView.canGoForward);
    _Btn_back.enabled = _webView.canGoBack;
    _Btn_forward.enabled = _webView.canGoForward;
    _webView.height = _webVHeight - (_Ve_tool.hidden ? 0 : _Ve_tool.height);
}


// 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;{}

// 当内容开始返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;{}

// 页面加载完成之后
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;{
//    //HTMLString时   特殊设置字体大小的问题
//    if (_HTMLString) {
//        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '260%'" completionHandler:nil];
//    }
}

// 页面加载失败时
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation;{}

// 接收到服务器跳转请求之后
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation;{}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;{
    decisionHandler(WKNavigationResponsePolicyAllow);
}


/** 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *url = navigationAction.request.URL;
    if ([url.scheme isEqualToString:@"tel"] || [url.absoluteString containsString:@"ituns.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        [self.Nav popViewControllerAnimated:NO];
    }
    
    //    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) { // 对于跨域，需要手动跳转
    //        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
    //        decisionHandler(WKNavigationActionPolicyCancel);return; // 不允许web内跳转
    //    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定".loc style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}



#pragma mark - UI 相关设置

- (void)setup_KWWebViewUI{
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    
    [wkUController addUserScript:[[WKUserScript alloc] initWithSource:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES]];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    wkWebConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    if (self.Nav.navigationBar.isTranslucent || self.Nav.navigationBar.hidden) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, ScreenNavBarH, ScreenWidth, ScreenHeight - ScreenNavBarH) configuration:wkWebConfig].addTo(self.view);
        _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
    }else{
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - ScreenNavBarH) configuration:wkWebConfig].addTo(self.view);
        if (self.presentingViewController) {
            _webView.frame = JR(0, 0, kSW, ScreenHeight - 40);
        }
    }
    _webVHeight = _webView.height;
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    _progressV = [[UIProgressView alloc]initWithFrame:CGRectMake(0, _webView.y, ScreenWidth, 2)].addTo(self.view);
    
    if (_HTMLString != nil) {
        [_webView loadHTMLString:_HTMLString baseURL:nil];
    }else{
        if ([_H5Url isKindOfClass:[NSURLRequest class]]) {
            [_webView loadRequest:(NSURLRequest *)_H5Url];
        }else if ([_H5Url isKindOfClass:[NSURL class]]) {
            [_webView loadRequest:[NSURLRequest requestWithURL:(NSURL *)_H5Url]];
        }else{
            [_webView loadRequest:[NSURLRequest requestWithURL:_H5Url.url]];
        }
    }

    UIImage *image = [UIImage imageNamed:JEResource(@"NavCloseBtn.png")];
    [self.Btn_back setImage:image forState:UIControlStateNormal];
    [self.Btn_back setImage:[image imageWithColor:[[UIColor blackColor] je_Abe:0.618 Alpha:0.618]] forState:UIControlStateHighlighted];
    
    UIImage *arrow = [UIImage imageNamed:JEResource(@"NavBackBtn.png")];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect].addTo(self.view);
    effectView.frame = CGRectMake(0, ScreenHeight - 44 - ScreenSafeArea, ScreenWidth, 44 + ScreenSafeArea);
    
    _Btn_back = JEBtn(JR(ScreenWidth/2 - 44 - 40,0,44,44),nil,@0,nil,_webView,@selector(goBack),arrow.color([UIColor blackColor]),0,effectView.contentView);
    [_Btn_back setImage:[arrow imageWithColor:[[UIColor blackColor] je_Abe:1 Alpha:0.618]] forState:UIControlStateHighlighted];
    
    _Btn_forward = JEBtn(JR(ScreenWidth/2 + 40,0,44,44),nil,@0,nil,_webView,@selector(goForward),[arrow imageRotatedByDegrees:180].color([UIColor blackColor]),0,effectView.contentView);
    [_Btn_forward setImage:[[arrow imageRotatedByDegrees:180] imageWithColor:[[UIColor blackColor] je_Abe:1 Alpha:0.618]] forState:UIControlStateHighlighted];
    _Ve_tool = effectView;
    _Ve_tool.hidden = YES;
    
//    [self je_rightBarBtn:@"❖" act:@selector(webShareClick)];
}

- (void)webShareClick{
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:_webView.URL,_webView.URL.absoluteString,nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [JEApp.window.rootViewController presentViewController:activityViewController animated:YES completion:nil];
}

//    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//    }
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    [[NSURLCache sharedURLCache] setDiskCapacity:0];
//    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];

@end
