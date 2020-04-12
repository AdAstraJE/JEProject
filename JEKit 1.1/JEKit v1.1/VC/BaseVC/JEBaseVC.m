
#import "JEBaseVC.h"
#import "JEKit.h"
#import "JEVisualEffectView.h"

static CGFloat const jkPresentingNavH = 56.0f;///<
static CGFloat const jkNavItemTitleMargin = 16.0f;///<
static CGFloat const jkNavItemFontSize = 17.0f;///<


@implementation JEBaseVC{
    JEButton *_Btn_right;
}

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
        [self removeStaticTvBlock];
        [_staticTv removeFromSuperview];
        _staticTv = nil;
        [_liteTv removeFromSuperview];
        _liteTv = nil;
    }
}

- (void)removeStaticTvBlock{
    [_staticTv.Arr_item enumerateObjectsUsingBlock:^(NSArray <JEStvIt *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(JEStvIt * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.selectBlock = nil;
            item.switchBlock = nil;
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = JEShare.VCBgClr ? : [UIColor Light:UIColor.whiteColor dark:UIColor.blackColor];
    
    if (!_disableNavBar && JEShare.customNavView) { [self createNavBar];}
}

- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    _navTitleLable.text = title;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    if (iPad) {
//        _Btn_right.x = self.view.width - _Btn_right.width - JKNavItemTitleMargin;
//        _navTitleLable.frame = JR(_navTitleLable.x, _navTitleLable.y, kSW - _navTitleLable.x*2, _navTitleLable.height);
//
//    }
//    _navBar.jo.heightIs(ScreenNavBarH);[_navBar updateLayout];
//

//    CGFloat height = (!self.navigationController ? jkPresentingNavH : ScreenNavBarH);
//    CGFloat y = (!self.navigationController ? 0 : ScreenStatusBarH);
//    if (self.modalPresentationStyle == UIModalPresentationFullScreen) {
//        height += 32;y = 32;
//    }
//    _navBar.jo.height(height);
}

#pragma mark - 默认navBar
- (void)createNavBar{
    CGFloat height = (!self.navigationController ? jkPresentingNavH : ScreenNavBarH);
    if (self.modalPresentationStyle == UIModalPresentationFullScreen) {height = ScreenNavBarH;}

    _navBar = JEVe(JR0,JEShare.navBarClr, self.view).jo.left(0).right(0).height(height).me;
    if (JEShare.navBarClr == nil) {
        _navBarEffect = [[JEVisualEffectView alloc] init].addTo(_navBar).jo.bounds;
    }
    if (JEShare.navBarImage) {
        JEImg(JR0,JEShare.navBarImage,nil).addTo(_navBar).jo.inset(0, 0, 0, 0);
    }else{
        _navBarline = JEVe(JR0, JEShare.navBarLineClr,_navBar).jo.bottom_(_navBar,-0.33).right(0).height(0.33).me;
    }
    
    CGFloat contentH = (!self.navigationController && self.modalPresentationStyle == UIModalPresentationPageSheet) ? height : kNavBarH44;
    _navBarContent = JEVe(JR0, nil,_navBar).jo.height(contentH).left(0).right(0).bottom(0).me;
    _navTitleLable = JELab(JR0,self.title,fontS(jkNavItemFontSize),JEShare.navTitleClr,(1),_navBarContent).adjust().jo.left(50).top(0).right(50).bottom(0).me;

    if (self.Nav.viewControllers.count > 1) {
        _navBackButton = [self leftNavBtn:JEBundleImg(@"ic_navBack") target:self act:@selector(navBackButtonClick)]
        .style(JEBtnStyleLeft,4.5).touchs(0,8,0,40)
        .jo.left(8).width(13).me;
        _navBackButton.jo.width([_navBackButton sizeThatWidth].width);[_navBackButton updateLayout];
    }

    [self viewDidLayoutSubviews];
    
//    [_navBar je_Debug:UIColor.redColor width:1];
//    [_navBarContent je_Debug:UIColor.redColor width:1];
//    [_navBarEffect je_Debug:UIColor.redColor width:1];
//    [_navBar je_Debug:UIColor.redColor width:1];
}

- (void)resetNavBarHeight:(CGFloat)h{
    _navBar.jo.height(h);
    [_navBar updateLayout];
}

- (void)navBackButtonClick{
    (self.presentingViewController) ? [self dismissViewControllerAnimated:YES completion:nil] : [self.Nav popViewControllerAnimated:YES];
}

- (void)navBackBtn:(id)item{
    if (_navBackButton == nil) {
        _navBackButton = [self leftNavBtn:item target:self act:@selector(navBackButtonClick)];
    }else{
        if ([item isKindOfClass:NSString.class]) {[_navBackButton setTitle:item forState:(UIControlStateNormal)];}
        if ([item isKindOfClass:UIImage.class]) {[_navBackButton setImage:item forState:(UIControlStateNormal)];}
        _navBackButton.jo.width([_navBackButton sizeThatWidth].width);
        [_navBackButton updateLayout];
    }
}

- (JEButton *)rightNavBtn:(id)item target:(id)target act:(SEL)selector{
    UIFont *font = (!self.navigationController && self.modalPresentationStyle == UIModalPresentationPageSheet) ? fontS(jkNavItemFontSize) : font(jkNavItemFontSize);
    JEButton *_ = [self navBarButton:item target:target act:selector font:font].touchs(0,jkNavItemTitleMargin,0,jkNavItemTitleMargin)
    .jo.right(jkNavItemTitleMargin).top(0).width(-0).bottom(0).me;
    _.jo.width([_ sizeThatWidth].width);[_navBackButton updateLayout];
    return _;
}

- (JEButton *)leftNavBtn:(id)item target:(id)target act:(SEL)selector{
    JEButton *_ = [self navBarButton:item target:target act:selector font:font(jkNavItemFontSize)].touchs(0,jkNavItemTitleMargin,0,jkNavItemTitleMargin)
    .jo.left(jkNavItemTitleMargin).top(0).width(-0).bottom(0).me;
    _.jo.width([_ sizeThatWidth].width);[_navBackButton updateLayout];
    return _;
}

- (JEButton *)navBarButton:(id)item target:(id)target act:(SEL)selector font:(UIFont *)font{
    NSString *title = [item isKindOfClass:NSString.class] ? item : nil;
    UIImage *img = [item isKindOfClass:UIImage.class] ? item : nil;
    return JEBtnSys(JR0, title, font, JEShare.navBarItemClr, target, selector, img, 0, _navBarContent);
}

#pragma mark - 默认创建方法
- (CGRect)tvFrame{
    return JR(0, _navBar.height, kSW, kSH - _navBar.height);
}

- (CGRect)tvFrameFull{
    return JR(0, 0, kSW, kSH);
}

- (JEStaticTableView *)staticTv{
    if (_staticTv == nil) {
        JEStaticTableView *tv = [[JEStaticTableView alloc] initWithFrame:JR0 style:(UITableViewStyleGrouped)];
        if (_navBar) {tv.contentInsetTop = _navBar.height;}
        [self.view insertSubview:tv atIndex:0];
        tv.jo.inset(0, 0, 0, 0);
        _staticTv = tv;
    }
    return _staticTv;
}

- (JETableView *)defaultTv:(UITableViewStyle)style cell:(id)cellClass{
    JETableView *tv = [[JETableView alloc] initWithFrame:JR0 style:style];
    tv.rowHeight = 45.0f;
    tv.delegate = (id<UITableViewDelegate>)self;
    tv.dataSource = (id<UITableViewDataSource>)self;
   
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
    if (_navBar) {
        tv.contentInsetTop = _navBar.height;
    }
    [self.view insertSubview:tv atIndex:0];
    tv.jo.inset(0, 0, 0, 0);
    return tv;
}

- (JELiteTV *)liteTv:(UITableViewStyle)style cellC:(nullable Class)cellClass cellH:(CGFloat)cellHeight
               cell:(nullable void (^)(__kindof UITableViewCell *cell,UITableView *tv,NSIndexPath *idxP,id obj))cell select:(nullable void (^)(UITableView *tv,NSIndexPath *idxP,id obj))select{
    JELiteTV *tv = [[JELiteTV alloc] initWithFrame:JR0 style:style cellC:cellClass cellH:cellHeight];
    tv.cell = cell;
    tv.select = select;
    if (_navBar) {
        CGFloat value = _navBar.height;
        tv.contentInset = UIEdgeInsetsMake(value, 0, value + ScreenSafeArea, 0);
    }
    [self.view insertSubview:tv atIndex:0];
    tv.jo.inset(0, 0, 0, 0);
    return tv;
}


#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)touchesBegan:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event{
    [self.view endEditing:YES];
}

@end



