
#import "JEBaseVC.h"
#import "JEKit.h"

@implementation JEBaseVC

- (void)dealloc{
    jkDeallocLog
}

- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    JEBaseNavtion *nav = (JEBaseNavtion *)self.navigationController;
    if ([nav isKindOfClass:[JEBaseNavtion class]]) {
        [nav navigationController:nav didShowViewController:self animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if (self.Nav == nil) {
        [_staticTv removeFromSuperview];
        _staticTv = nil;
        [_liteTv removeFromSuperview];
        _liteTv = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JEShare.VCBgClr;
    
    if (!self.je_disableNavBar) {
        [self je_useCustomNavBar];
    }
//    UIInterfaceOrientationUnknown            = UIDeviceOrientationUnknown,
//       UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
//       UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
//       UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight,
//       UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft
//    UIInterfaceOrientation orien = [UIApplication sharedApplication].statusBarOrientation;
//    NSLog(@"🔵\nOrientation:%@\n", @(orien));
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillRotate:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidRotate:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

//- (void)handleDeviceOrientationChanged:(NSNotification *)notification{
//    NSDictionary *userInfo = [notification userInfo];
//    UIInterfaceOrientation appOrientation = [UIApplication sharedApplication].statusBarOrientation;
//
//    NSLog(@"\nOrientation:%@\n User Info :%@", @(appOrientation), userInfo);
//}
//
//- (void)handleWillRotate:(NSNotification *)notification{
//    NSDictionary *userInfo = [notification userInfo];
//    //    [0]    (null)    @"UIApplicationStatusBarOrientationUserInfoKey" : (int)4
//    //UIApplicationStatusBarOrientationUserInfoKey
//    UIInterfaceOrientation orien = userInfo.str(UIApplicationStatusBarOrientationUserInfoKey).integerValue;
//    NSLog(@"\nWill Rotate %@", userInfo);
//    //
//    if (orien == UIInterfaceOrientationLandscapeRight) {
//        self.je_Btn_back.x = 3 + ScreenSafeArea;
//    }
//
//}

- (void)handleDidRotate:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"\nDid Rotate %@", userInfo);
}

/** tableView默认Frame */
- (CGRect)tvFrame{
    return JR(0, self.je_navBar.height, ScreenWidth, ScreenHeight - self.je_navBar.height - (self.presentingViewController ? ScreenStatusBarH : 0));
}

- (JEStaticTableView *)staticTv{
    if (_staticTv == nil) {
        _staticTv = [[JEStaticTableView alloc] initWithFrame:self.tvFrame];
        [self.view insertSubview:_staticTv atIndex:0];
    }
    return _staticTv;
}

- (JETableView *)defaultTv:(UITableViewStyle)style cell:(id)cellClass{
    JETableView *_ = [[JETableView alloc]initWithFrame:self.tvFrame style:style];
    _.rowHeight = 45.0f;
    _.delegate = (id<UITableViewDelegate>)self;
    _.dataSource = (id<UITableViewDataSource>)self;
    if (style == UITableViewStylePlain) {
        _.tableFooterView = [UIView new];
    }
    
    if ([cellClass isKindOfClass:[NSArray class]]) {
        [cellClass enumerateObjectsUsingBlock:^(Class obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_ registerClass:obj forCellReuseIdentifier:NSStringFromClass(obj)];
        }];
    }else{
        if (cellClass) {
            [_ registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
        }else{
            [_ registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell className]];
        }
    }
    [self.view insertSubview:_ atIndex:0];
    return _;
}


#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)touchesBegan:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event{
    [self.view endEditing:YES];
}

@end


