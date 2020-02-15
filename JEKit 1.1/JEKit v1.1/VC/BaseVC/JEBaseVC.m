
#import "JEBaseVC.h"
#import "JEKit.h"

static CGFloat const JKPresentingNavH = 58.0f;///<
static CGFloat const JKNavItemTitleMargin = 16.0f;///<

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
    if (JEShare.navBarClr == nil) {
        _navBarEffect = JEEFVe(_.bounds, UIBlurEffectStyleExtraLight, _);
    }

    if (JEShare.navBarImage) {JEImg(_.bounds,JEShare.navBarImage,_);}
    {
        CGFloat x = self.presentingViewController ? 14 : (ScreenStatusBarH + 7);
        UILabel *la = JELab(JR(50,x, ScreenWidth - 50*2, 30),self.title,fontM(17),JEShare.navTitleClr,(1),_);
        la.adjustsFontSizeToFitWidth = YES;
        la.backgroundColor = [UIColor clearColor];
        _navTitleLable = la;
    }
    
    if (JEShare.navBarImage == nil) {
        _navBarline = JEVe(JR(0, _.height - 0.5, _.width, 0.5), nil, _);
    }
    
    if (self.Nav.viewControllers.count > 1) {
        UIImage *image = JEBundleImg(@"ic_navBack").clr(JEShare.navBarItemClr);
        _navBackButton = JEBtn(JR(1.5, ScreenStatusBarH + (kNavBarH44 - 26)/2, 26, 26),nil,_navTitleLable.font ? : font(17),JEShare.navBarItemClr,self,@selector(navBackButtonClick),nil,0,_).touchs(ScreenStatusBarH,3,20,40);
        [_navBackButton je_resetImg:image];
    }
    _navBar = _;
}

/// navBar navBarEffect navBarline frame
- (void)resetNavBarHeight:(CGFloat)h{
    _navBar.height = _navBarEffect.height = h;
    _navBarline.y = _navBarline.superview.height - _navBarline.height;
}

- (void)navBackButtonClick{
    (self.presentingViewController) ? [self dismissViewControllerAnimated:YES completion:nil] : [self.Nav popViewControllerAnimated:YES];
}

- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    _navTitleLable.text = title;
}

- (void)leftNavBtn:(id)item{
    NSString *title = [item isKindOfClass:NSString.class] ? item : nil;
    UIImage *img = [item isKindOfClass:UIImage.class] ? item : nil;
    if (_navBackButton == nil) {
        _navBackButton = [self leftBtn:item target:self act:@selector(navBackButtonClick)];
    }else{
        if (img) { [_navBackButton je_resetImg:img];}
        if (title) {[_navBackButton setTitle:title forState:UIControlStateNormal]; }
    }

    [_navBackButton sizeThatWidth];
    _navBackButton.x = JKNavItemTitleMargin;
}

- (JEButton *)rightNavBtn:(id)item target:(id)target act:(SEL)selector{
    JEButton *_ = [self leftBtn:item target:target act:selector];
    _.x = ScreenWidth - _.width - JKNavItemTitleMargin;
    if (self.presentingViewController) {
        _.titleLabel.font = fontM(_.titleLabel.font.pointSize);
    }
    
    return _;
}

- (JEButton *)leftBtn:(id)item target:(id)target act:(SEL)selector{
    NSString *title = [item isKindOfClass:NSString.class] ? item : nil;
    UIImage *img = [item isKindOfClass:UIImage.class] ? item : nil;
    CGFloat x = self.presentingViewController ? 0 : ScreenStatusBarH;
    CGFloat h = self.presentingViewController ? JKPresentingNavH : kNavBarH44;
    UIFont *font = font(17);
    
    JEButton *_ = JEBtn(JR(JKNavItemTitleMargin,x, -1, h),title,font,JEShare.navBarItemClr,target,selector,nil,0,_navBar).touchs(10,20,0,16);
    [_ je_resetImg:img];
    [_ sizeThatWidth];
    return _;
}

#pragma mark - 默认创建方法
- (CGRect)tvFrame{
    return JR(0, _navBar.height, ScreenWidth, ScreenHeight - _navBar.height - (self.presentingViewController ? ScreenStatusBarH : 0));
}

- (CGRect)tvFrameFull{
    return JR(0, 0, ScreenWidth, ScreenHeight - (self.presentingViewController ? (ScreenStatusBarH*2 - ScreenSafeArea) : 0));
}

- (JEStaticTableView *)staticTv{
    if (_staticTv == nil) {
        JEStaticTableView *tv = [[JEStaticTableView alloc] initWithFrame:self.tvFrameFull];
        if (_navBar) {tv.contentInsetTop = _navBar.height - (self.presentingViewController ? 0 : ScreenStatusBarH);}
        [self.view insertSubview:tv atIndex:0];
        _staticTv = tv;
    }
    return _staticTv;
}

- (JETableView *)defaultTv:(UITableViewStyle)style cell:(id)cellClass{
    JETableView *tv = [[JETableView alloc]initWithFrame:self.tvFrameFull style:style];
    tv.rowHeight = 45.0f;
    tv.delegate = (id<UITableViewDelegate>)self;
    tv.dataSource = (id<UITableViewDataSource>)self;
    if (style == UITableViewStylePlain) {tv.tableFooterView = [UIView new];}
    
    if ([cellClass isKindOfClass:[NSArray class]]) {
        [cellClass enumerateObjectsUsingBlock:^(Class obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tv registerClass:obj forCellReuseIdentifier:NSStringFromClass(obj)];
        }];
    }else{
        if (cellClass) {
            [tv registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
        }else{
            [tv registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell className]];
        }
    }
    if (_navBar) {tv.contentInsetTop = _navBar.height - (self.presentingViewController ? 0 : ScreenStatusBarH);}
    [self.view insertSubview:tv atIndex:0];
    return tv;
}

- (JELiteTV *)liteTv:(UITableViewStyle)style cellC:(nullable Class)cellClass cellH:(CGFloat)cellHeight
               cell:(nullable void (^)(__kindof UITableViewCell *cell,UITableView *tv,NSIndexPath *idxP,id obj))cell select:(nullable void (^)(UITableView *tv,NSIndexPath *idxP,id obj))select{
    JELiteTV *tv = [[JELiteTV alloc] initWithFrame:self.tvFrameFull style:style cellC:cellClass cellH:cellHeight];
    tv.cell = cell;
    tv.select = select;
    if (_navBar) {tv.contentInsetTop = _navBar.height - (self.presentingViewController ? 0 : ScreenStatusBarH);}
    [self.view insertSubview:tv atIndex:0];
    return tv;
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
    
    if (JEShare.navBarLineClr) {_navBarline.backgroundColor = dark ? kRGBA(84, 84, 89, 0.6) : JEShare.navBarLineClr;}
    if (_navBar) {
        _navBar.backgroundColor = dark ? nil : JEShare.navBarClr;
        _navBarEffect.effect = [UIBlurEffect effectWithStyle:(dark ? UIBlurEffectStyleDark : UIBlurEffectStyleExtraLight)];
        _navTitleLable.textColor = dark ? UIColor.whiteColor : JEShare.navTitleClr;
    }
}

@end


