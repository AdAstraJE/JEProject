
#import "JEBaseNavtion.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "JEDebugTool__.h"

@interface JEBaseNavtion ()<UIGestureRecognizerDelegate>

@end

@implementation JEBaseNavtion{
    NSArray <Class > *_Arr_VC;
    UIStatusBarStyle _originStyle;
    UIStatusBarStyle _currentStyle;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self statusBarAppearanceUpdate:viewController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self statusBarAppearanceUpdate:viewController];
}

- (void)statusBarAppearanceUpdate:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        viewController = ((UITabBarController *)viewController).selectedViewController;
    }
    UIStatusBarStyle other = _originStyle == 0 ? 1 : 0;
    UIStatusBarStyle newStyle = ([_Arr_VC containsObject:[viewController class]] ? other : _originStyle);
    if (_currentStyle == newStyle) { return;}
    _currentStyle = newStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _currentStyle;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController theme:(void (^)(UIViewController *_))block{
    !block ? : block(self);
    self = [super initWithRootViewController:rootViewController];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.hidden = YES;
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = NO;
    self.fd_prefersNavigationBarHidden = YES;
}

/** 状态栏Style */
- (void)setStatusBarStyle:(UIStatusBarStyle)style{
    _currentStyle = _originStyle = style;
    [self setNeedsStatusBarAppearanceUpdate];
}

/** 设置某些VC的状态栏Style 其他VC取相反的Style */
- (void)setDifferentStatusBarStyleWithVCClass:(NSArray <Class > *)classArr{
    self.delegate = (id<UINavigationControllerDelegate>)self;
    _Arr_VC = classArr;
}

#ifdef DEBUG
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [JEDebugTool__ SwitchONOff];
}	
#endif

@end
