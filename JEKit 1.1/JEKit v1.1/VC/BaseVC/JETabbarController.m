
#import "JETabbarController.h"
#import "JEKit.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "JEBaseNavtion.h"

@interface JETabbarController () <UITabBarControllerDelegate>{
    NSArray <NSString *> *_Arr_titles_orgin;
    NSArray <NSArray <UIImage*> *> *_Arr_img_orgin;
    NSArray <UIViewController *> *_Arr_vc_orgin;
    
    NSMutableArray <NSString *> *_Arr_titles;
    NSMutableArray <NSArray <UIImage*> *> *_Arr_img;
}

@end

@implementation JETabbarController

- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

/** JETabbarController 默认样式 */
- (instancetype)initWithVCs:(NSArray <UIViewController *>*)VCs titles:(NSArray <NSString *> *)titles imgs:(NSArray <NSArray <UIImage*> *> *)imgs theme:(void (^)(JETabbarController *_))block{
    self = [super init];
    self.delegate = self;
    
    !block ? : block(self);
    
    [self setupVCs:VCs titles:titles imgs:imgs];

    return self;
}

- (void)setupVCs:(NSArray <UIViewController *>*)VCs titles:(NSArray <NSString *> *)titles imgs:(NSArray <NSArray <UIImage*> *> *)imgs{
    _Arr_titles_orgin = titles.copy;
    _Arr_img_orgin = imgs.copy;
    _Arr_vc_orgin = VCs;
    
    _Arr_titles = titles.mutableCopy;
    _Arr_img = imgs.mutableCopy;
    self.viewControllers = VCs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JEShare.VCBgClr;
   
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3.5)];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : Clr_txt99,NSFontAttributeName : [UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : Clr_txt33,NSFontAttributeName : [UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
}

- (void)hiddenTabbar:(NSArray <NSNumber *> *)indexArr{
    _Arr_titles = _Arr_titles_orgin.mutableCopy;
    _Arr_img = _Arr_img_orgin.mutableCopy;
    NSMutableArray *vcs = _Arr_vc_orgin.mutableCopy;
    [indexArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self->_Arr_titles removeObjectAtIndex:obj.integerValue];
        [self->_Arr_img removeObjectAtIndex:obj.integerValue];
        [vcs removeObjectAtIndex:obj.integerValue];
    }];
    self.viewControllers = vcs;
}

/** 显示完全部tabbar */
- (void)showAllTabbar{
    _Arr_titles = _Arr_titles_orgin.mutableCopy;
    _Arr_img = _Arr_img_orgin.mutableCopy;
    self.viewControllers = _Arr_vc_orgin.mutableCopy;
}

- (void)viewDidLayoutSubviews{
    for (int i = 0; i < _Arr_titles.count; i++) {
        UITabBarItem *_ = [self.tabBar.items objectAtIndex:i];
        _.title = _Arr_titles[i];
        _.image = [_Arr_img[i].firstObject imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _.selectedImage = [_Arr_img[i].lastObject imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    JEBaseNavtion *nav = (JEBaseNavtion *)self.navigationController;
    if ([nav isKindOfClass:[JEBaseNavtion class]]) {
        [nav navigationController:nav didShowViewController:viewController animated:YES];
    }
    [self viewDidLayoutSubviews];
}

@end
