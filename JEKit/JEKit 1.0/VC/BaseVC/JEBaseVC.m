
#import "JEBaseVC.h"
#import "JEKit.h"

@implementation JEBaseVC

- (void)dealloc{
    jkDeallocLog
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
        [self removeStaticTvBlock];
    }
}

- (void)removeStaticTvBlock{
    [_staticTv.Arr_item enumerateObjectsUsingBlock:^(NSArray <JESTCItem *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(JESTCItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.selectBlock = nil;
            item.switchBlock = nil;
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.view.backgroundColor == nil) {
        self.view.backgroundColor = JEShare.VCBackgroundColor;
    }
    
    if (!self.disabel_je_NavBar) {
        [self je_useCustomNavBar];  
    }
}

/** tableView默认Frame */
- (CGRect)tvFrame{
    CGFloat tabBarHeight = 0.0f;
    if (self.Nav.viewControllers.count <= 1 && [self.Nav.viewControllers.firstObject isKindOfClass:[UITabBarController class]]) {
        tabBarHeight = ScreenTabBarH;
    }
//    return CGRectMake(0, ScreenNavBarH, ScreenWidth, ScreenHeight - ScreenNavBarH - ScreenSafeArea - tabBarHeight);
    return CGRectMake(0, ScreenNavBarH, ScreenWidth, ScreenHeight - ScreenNavBarH - tabBarHeight);
}

- (JETableView *)tableView{
    if (_tableView == nil) {
        _tableView = [self defaultTableView:(UITableViewStyleGrouped) cell:nil].addTo(self.view);
    }
    return _tableView;
}

- (JEStaticTableView *)staticTv{
    if (_staticTv == nil) {
        _staticTv = [[JEStaticTableView alloc] initWithFrame:self.tvFrame].addTo(self.view);
    }
    return _staticTv;
}

- (JETableView *)defaultTableView:(UITableViewStyle)style cell:(id)cellClass{
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
            [_ registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell ClassName]];
        }
    }
    
    
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


