
#import <UIKit/UIKit.h>

@interface JETabbarController : UITabBarController

//JETabbarController *tabbar = ((JEBaseNavtion *)JEApp.window.rootViewController).viewControllers.firstObject;

/** JETabbarController 默认样式 theme 里面处理 _.je_ UI属性*/
- (instancetype)initWithVCs:(NSArray <UIViewController *>*)VCs titles:(NSArray <NSString *> *)titles imgs:(NSArray <NSArray <UIImage*> *> *)imgs theme:(void (^)(JETabbarController *_))block;
- (void)setupVCs:(NSArray <UIViewController *>*)VCs titles:(NSArray <NSString *> *)titles imgs:(NSArray <NSArray <UIImage*> *> *)imgs;

/** 遍历隐藏tabbar */
- (void)hiddenTabbar:(NSArray <NSNumber *> *)indexArr;

/** 显示完全部tabbar */
- (void)showAllTabbar;
    
@end

