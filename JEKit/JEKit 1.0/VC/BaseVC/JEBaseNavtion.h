
#import <UIKit/UIKit.h>

@interface JEBaseNavtion : UINavigationController

/** 没JETabbarController 或 以下theme回调 或 XIB构建时 navBar属性在 第一个vc viewDidLoad 前设置 */
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController theme:(void (^)(UIViewController *_))block;

/** 状态栏Style */
- (void)setStatusBarStyle:(UIStatusBarStyle)style;

/** 设置某些VC的状态栏Style 其他VC取相反的Style + (void)DidSetRootVC{ [(JEBaseNavtion *)JEApp.window.rootViewController setDifferentStatusBarStyleWithVCClass:@[VC.class]];} */
- (void)setDifferentStatusBarStyleWithVCClass:(NSArray <Class > *)classArr;

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
