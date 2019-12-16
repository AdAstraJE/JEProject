
#import "JEBaseVC.h"
#import "JEKit.h"

static CGFloat const JKPresentingNavH = 58.0f;///<

@implementation JEBaseVC

- (void)dealloc{jkDeallocLog}

#pragma mark -
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark -
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
    self.backgroundColor = JEShare.VCBgClr;
    
    if (!_disableNavBar) { [self createNavBar];}
    
    [self handelStyleDark];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
}

#pragma mark - 默认navBar
- (void)createNavBar{
    CGFloat height = self.presentingViewController ? JKPresentingNavH : ScreenNavBarH;
    UIView *_ = JEVe(JR(0, 0, ScreenWidth, height),JEShare.navBarClr, self.view);
    if (JEShare.navBarImage) {JEImg(_.bounds,JEShare.navBarImage,_);}
    
    {
        CGFloat x = self.presentingViewController ? 14 : (ScreenStatusBarH + 6);
        UILabel *la = JELab(JR(50,x, ScreenWidth - 50*2, 30),self.title,fontM(18),JEShare.navTitleClr,(1),_);
        la.adjustsFontSizeToFitWidth = YES;
        la.backgroundColor = [UIColor clearColor];
        _navTitleLable = la;
    }
    
    if (JEShare.navBarImage == nil && JEShare.navBarClr == UIColor.whiteColor) {
        _navBarline = JEVe(JR(0, _.height - 0.5, _.width, 0.5), JEShare.navBarLineClr, _);
    }
    
    if (self.Nav.viewControllers.count > 1) {
        UIImage *image = JEBundleImg(@"ic_navBack").clr(JEShare.navBarItemClr);
        _navBackButton = JEBtn(JR(3, ScreenStatusBarH + (kNavBarH44 - 26)/2, 26, 26),nil,_navTitleLable.font ? : font(17),JEShare.navBarItemClr,self,@selector(navBackButtonClick),image,0,_).touchs(ScreenStatusBarH,3,20,40);
    }
    _navBar = _;
}

- (void)navBackButtonClick{
    (self.presentingViewController) ? [self dismissViewControllerAnimated:YES completion:nil] : [self.Nav popViewControllerAnimated:YES];
}

- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    _navTitleLable.text = title;
}

- (JEButton *)leftNavBtn:(id)item{
    NSString *title = [item isKindOfClass:NSString.class] ? item : nil;
    UIImage *img = [item isKindOfClass:UIImage.class] ? item : nil;
    if (_navBackButton == nil) {
        _navBackButton = [self createBtn:item target:self act:@selector(navBackButtonClick)];
    }else{
        if (img) { [_navBackButton je_resetImg:img];}
        if (title) {[_navBackButton setTitle:title forState:UIControlStateNormal]; }
    }

    [_navBackButton sizeThatWidth];
    _navBackButton.x = 12;
    return _navBackButton;
}

- (JEButton *)rightNavBtn:(id)item target:(id)target act:(SEL)selector{
    JEButton *_ = [self createBtn:item target:target act:selector];
    _.x = ScreenWidth - _.width - 16;
    return _;
}

- (JEButton *)createBtn:(id)item target:(id)target act:(SEL)selector{
    NSString *title = [item isKindOfClass:NSString.class] ? item : nil;
    UIImage *img = [item isKindOfClass:UIImage.class] ? item : nil;
    CGFloat x = self.presentingViewController ? 0 : ScreenStatusBarH;
    CGFloat h = self.presentingViewController ? JKPresentingNavH : kNavBarH44;
    UIFont *font = self.presentingViewController ? fontM(17) : font(17);
    
    JEButton *_ = JEBtn(JR(-1,x, -1, h),title,font,JEShare.navBarItemClr,target,selector,img,0,_navBar).touchs(10,20,0,16);
    [_ sizeThatWidth];
    return _;
}

#pragma mark - 默认创建方法
- (CGRect)tvFrame{
    return JR(0, _navBar.height, ScreenWidth, ScreenHeight - _navBar.height - (self.presentingViewController ? ScreenStatusBarH : 0));
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

#pragma mark -   dark
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self handelStyleDark];
}

- (void)handelStyleDark{
    BOOL dark = NO;
    if (@available(iOS 13.0, *)) {dark = (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);}
    
    self.view.backgroundColor = dark ? UIColor.blackColor : _backgroundColor;
    if (_navBar) {
        _navBar.backgroundColor = dark ? UIColor.blackColor : JEShare.navBarClr;
        _navTitleLable.textColor = dark ? UIColor.whiteColor : JEShare.navTitleClr;
    }
}

@end


