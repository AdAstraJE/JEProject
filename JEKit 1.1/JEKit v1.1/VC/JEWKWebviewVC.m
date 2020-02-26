
#import "JEWKWebviewVC.h"
#import <WebKit/WebKit.h>
#import "JEKit.h"


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEOpenInSafariActivity   🔷 在Safari中打开
@interface JEOpenInSafariActivity : UIActivity

@end

@implementation JEOpenInSafariActivity{
    NSURL *_url;
}

+ (UIActivityCategory)activityCategory{ return UIActivityCategoryAction;}
- (NSString *)activityTitle{ return NSLocalizedString(@"在Safari中打开", nil);}
- (UIImage *)activityImage{ return JEBundleImg(@"ic_safari");}
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {return YES;}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (NSObject *obj in activityItems) {
        if ([obj isKindOfClass:NSURL.class]) { _url = (NSURL *)obj; }
    }
}

- (void)performActivity{
    if (_url) {
        [[UIApplication sharedApplication] openURL:_url options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
    }
    [self activityDidFinish:YES];
}

- (void)performFinish{
    
}

@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEWKWebviewVC   🔷🔷🔷🔷🔷🔷🔷🔷

@interface JEWKWebviewVC ()<WKUIDelegate,WKNavigationDelegate>{
    WKWebView *_webView;
    CGFloat _webVHeight;
    UIProgressView *_progressV;
    UIView *_Ve_tool;
    UIButton *_Btn_back,*_Btn_forward;///< 返回 前进
    NSString *_textResource,*_tempFileSharePath;
    BOOL _netLink;
}

@end

@implementation JEWKWebviewVC

- (void)dealloc{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if (self.Nav == nil && _tempFileSharePath) {
        [[NSFileManager defaultManager] removeItemAtPath:_tempFileSharePath error:nil];
    }
}

- (instancetype)initWithUrl:(id)url{
    self = [super init];_URL = url; return self;
}

- (instancetype)initWithHTMLString:(NSString*)HTMLStr{
    self = [super init];
    _HTMLString = HTMLStr;
    return self;
}

- (instancetype)sendInfo:(id)info{
    _URL = info;return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.title;
    
    [self setup_KWWebViewUI];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [_progressV setAlpha:1.0f];
    BOOL animated = _webView.estimatedProgress > _progressV.progress;
    [_progressV setProgress:_webView.estimatedProgress animated:animated];
    if(_webView.estimatedProgress >= 1.0f) {
        [UIView animateWithDuration:0.1f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
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

#pragma mark - WKUIDelegate,WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;{}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;{}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;{
//    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '260%'" completionHandler:nil];
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation;{}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation;{}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/** 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *url = navigationAction.request.URL;
    if ([url.scheme hasPrefix:@"itms-appss"] || [url.scheme isEqualToString:@"tel"] || [url.absoluteString containsString:@"ituns.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
        [self.Nav popViewControllerAnimated:NO];
    }

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
    [self rightNavBtn:(JEBundleImg(@"ic_navAction").clr(JEShare.navBarItemClr)) target:self act:@selector(webShareClick)];
    
    NSURLRequest *request = (NSURLRequest *)_URL;
    if ([_URL isKindOfClass:[NSURL class]]) {
        request = [NSURLRequest requestWithURL:(NSURL *)_URL];
    }else if ([_URL isKindOfClass:[NSString class]]) {
        request = [NSURLRequest requestWithURL:((NSString *)_URL).url];
    }else if ([_URL isKindOfClass:[NSData class]]) {
        _textResource = [[NSString alloc] initWithData:((NSData *)_URL) encoding:NSUTF8StringEncoding];
    }
    
    if ([request isKindOfClass:NSURLRequest.class] && [@"url" contain:[request.URL.absoluteString pathExtension].lowercaseString]) {
        NSArray <NSString *> *arr = [[NSString stringWithContentsOfFile:request.URL.path usedEncoding:nil error:nil] componentsSeparatedByString:@"\n"];
        NSString *prefix = @"URL=";
        for (NSString *str in arr) {
            if ([str hasPrefix:prefix]) { request = [NSURLRequest requestWithURL:[str substringFromIndex:prefix.length].url];break;}
        }
    }

    //打开网页
    if ([request isKindOfClass:NSURLRequest.class] && request.URL.absoluteString.isLink && !request.URL.fileURL) {
        _netLink = YES;
        [self.navBackButton je_resetImg:JEBundleImg(@"ic_navClose").clr(JEShare.navBarItemClr)];
        self.navBackButton.x += 5.5;
    }
    
    if ([request isKindOfClass:NSURLRequest.class] && [@[@"md",@"txt",@"json",@"plist",@"h",@"m"] containsObject:[request.URL.absoluteString pathExtension].lowercaseString]) {
        NSStringEncoding *useEncodeing = nil;
        _textResource = [NSString stringWithContentsOfFile:request.URL.path usedEncoding:useEncodeing error:nil];
        if (!_textResource){_textResource = [NSString stringWithContentsOfFile:request.URL.absoluteString encoding:0x80000632 error:nil];}
        if (!_textResource){_textResource = [NSString stringWithContentsOfFile:request.URL.absoluteString encoding:0x80000631 error:nil];}
    }
    
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    
    [wkUController addUserScript:[[WKUserScript alloc] initWithSource:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES]];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    wkWebConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, ScreenNavBarH, ScreenWidth, ScreenHeight - ScreenNavBarH) configuration:wkWebConfig].addTo(self.view);
    _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
    _webVHeight = _webView.height;
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    _progressV = [[UIProgressView alloc]initWithFrame:CGRectMake(0, _webView.y, ScreenWidth, 2)].addTo(self.view);
    _progressV.tintColor = Clr_blue.alpha_(0.5);
    
    if (_textResource) {
        [_webView loadData:_textResource.data MIMEType:@"text/plain" characterEncodingName:@"UTF-8" baseURL:[NSURL new]];
    }else{
        _HTMLString ? [_webView loadHTMLString:_HTMLString baseURL:nil] : [_webView loadRequest:request];
    }


    UIImage *leftArrow = JEBundleImg(@"ic_navBack").clr(Clr_blue);
    UIImage *rightArrow = [leftArrow je_rotate:180];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect].addTo(self.view);
    effectView.frame = CGRectMake(0, ScreenHeight - 44 - ScreenSafeArea, ScreenWidth, 44 + ScreenSafeArea);
    
    _Btn_back = JEBtn(JR(ScreenWidth/2 - 44 - 40,0,44,44),nil,@0,nil,_webView,@selector(goBack),leftArrow,0,effectView.contentView);
    [_Btn_back setImage:leftArrow.clr(Clr_txtC8) forState:(UIControlStateDisabled)];
    
    _Btn_forward = JEBtn(JR(ScreenWidth/2 + 40,0,44,44),nil,@0,nil,_webView,@selector(goForward),rightArrow,0,effectView.contentView);
    [_Btn_forward setImage:rightArrow.clr(Clr_txtC8) forState:(UIControlStateDisabled)];
    
    _Ve_tool = effectView;
    _Ve_tool.hidden = YES;
}

- (void)webShareClick{
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:_webView.URL.absoluteString,_webView.URL,nil];
    if (_webView == nil) {
        if ([_URL isKindOfClass:[NSData class]] && _textResource.length){
            if (_tempFileSharePath == nil) {
                _tempFileSharePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:Format(@"%@_%@.txt",kAPPName,@([[NSDate date] timeIntervalSince1970]))];
                [_textResource writeToFile:_tempFileSharePath atomically:YES encoding:(NSUTF8StringEncoding) error:nil];
            }
            items = @[_tempFileSharePath.fileUrl].mutableCopy;
        }else{
            items = @[_URL].mutableCopy;
        }
    }
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:(_netLink ? @[[[JEOpenInSafariActivity alloc] init]] : nil)];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
