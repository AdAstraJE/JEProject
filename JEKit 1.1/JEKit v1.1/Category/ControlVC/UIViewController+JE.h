
#import <UIKit/UIKit.h>

@interface JEAlertController : UIAlertController
@end




@interface UIViewController (JEVC)

#define SBId_Main(VcIdentifier) (@[@"Main",VcIdentifier])
#define SBId_Home(VcIdentifier) (@[@"Home",VcIdentifier])
#define jkDeallocLog    JELog(@"🍁🍁🍁 %@ : %@  [* dealloc]",NSStringFromClass([self class]),NSStringFromClass([self superclass]));

///  count = 2     @[@"StoryboardName",@"vcId"]
+ (NSArray <NSString *> *)__Storyboard_Name_Id__;

/// 统一获取 storyboard构建的 UIViewController   根据Storyboard_Name_ID获取 取不到就 [[[self class] alloc] init]
+ (instancetype)VC;

/// self.navigationController
- (UINavigationController*)Nav;

/// self.tabBarController 没有就是 self.Nav.viewControllers.firstObject
- (UITabBarController*)Tab;

/// 导航控制器 取得对应栈上的vc
+ (instancetype)InNav;

///  VC class showViewController
+ (void)ShowVC;

/// presentViewController
+ (void)PresentVC:(UIModalPresentationStyle)style;

/// showViewController  (顺便调 sendInfo:  传参)
+ (instancetype)ShowVC:(id)info;

/// showViewController;
- (instancetype)showVC;

/// UIViewController 默认传参方法
- (instancetype)sendInfo:(id)info;

/// 替换导航栏栈里最后一个vc
- (void)je_replaceVC:(UIViewController *)vc;

/// UIAlertControllerStyleAlert
- (void)Alert:(NSString*)title msg:(NSString*)msg act:(NSArray <NSString *> *)actions destruc:(NSArray <NSString *> *)destructive _:(void(^)(NSString *act,NSInteger idx))block;
/// UIAlertControllerStyleAlert
- (void)Alert:(NSString*)title msg:(NSString*)msg act:(NSArray <NSString *> *)actions destruc:(NSArray <NSString *> *)destructive _:(void(^)(NSString *act,NSInteger idx))block cancel:(NSString *)cancel _:(void (^)(void))cancelBlock;

/// UIAlertControllerStyleActionSheet
- (void)ActionSheet:(NSString*)title msg:(NSString*)msg act:(NSArray <NSString *> *)actions destruc:(NSArray <NSString *> *)destructive _:(void(^)(NSString *act,NSInteger idx))block cancel:(NSString *)cancel _:(void (^)(void))cancelBlock;

@end
