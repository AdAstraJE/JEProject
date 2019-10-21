//
//  UIViewController+JE.h
//
//
//  Created by JE on 15/6/15.
//  Copyright © 2015年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@class JEHUDView;

typedef NS_ENUM(NSUInteger, HUDMarkType) {
    HUDMarkTypeSuccess = 0,///< √
    HUDMarkTypefailure = 1,///< X
    HUDMarkTypeNetError = 2,///< 网络错误图标
    HUDMarkTypeSystemBusy = 3,///< 系统忙
    HUDMarkTypeNone = 100,
};

@interface UIViewController (JEHUD)

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷  @implementation UIViewController (JEHUD)   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷

@property (nonatomic,strong) JEHUDView *HUDView;///< 显示时只有返回键可以点击

- (MBProgressHUD *)HUD;

/** 一直显示HUD 不可点击 */
- (void)showHUD;

/** 显示HUD动画 和 文字 */
- (void)showHUDLabelText:(NSString*)text;
- (void)showHUDLabelText:(NSString*)text delay:(CGFloat)delay;

/** 显示文本  背景可点击做其他操作  默认延迟消失 */
- (void)showHUD:(NSString*)text;
- (void)showHUD:(NSString*)text delay:(CGFloat)delay;///< 显示文本  背景可点击做其他操作  延迟消失时间

/** 显示文本  背景可点击做其他操作 显示默认图片类型  默认延迟消失 */
- (void)showHUD:(NSString*)text type:(HUDMarkType)type;
- (void)showHUD:(NSString*)text type:(HUDMarkType)type delay:(CGFloat)delay;///< 显示文本  背景可点击做其他操作 显示默认图片类型  延迟消失时间 
- (void)showHUD:(NSString*)text touch:(BOOL)touch type:(HUDMarkType)type delay:(CGFloat)delay;

/** hideHud */
- (void)hideHud;

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷  @implementation UIViewController (JEVC)   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷

@interface UIViewController (JEVC)

#define SBId_Main(VcIdentifier) (@[@"Main",VcIdentifier])
#define SBId_Home(VcIdentifier) (@[@"Home",VcIdentifier])
#define jkDeallocLog    JELog(@"🍁🍁🍁 %@ : %@  [* dealloc]",NSStringFromClass([self class]),NSStringFromClass([self superclass]));

/**  count = 2     @[@"StoryboardName",@"vcId"]   */
+ (NSArray <NSString *> *)__Storyboard_Name_Id__;

@property (nonatomic,assign) BOOL fullcellsep;///< tableView 显示完整的CellSeparator线

/** 统一获取 storyboard构建的 UIViewController   根据Storyboard_Name_ID获取 取不到就 [[[self class] alloc] init] */
+ (instancetype)VC;

/** self.navigationController */
- (UINavigationController*)Nav;

/** self.tabBarController 没有就是 self.Nav.viewControllers.firstObject */
- (UITabBarController*)Tab;

/** 导航控制器 取得对应栈上的vc*/
+ (instancetype)InNav;

/**  VC class showViewController */
+ (void)ShowVC;

/** showViewController  (顺便调 sendInfo:  传参) */
+ (void)ShowVC:(id)info;

/** showViewController; */
- (void)showVC;

/** UIViewController 默认传参方法 */
- (instancetype)sendInfo:(id)info;

/** 替换导航栏栈里最后一个vc */
- (void)je_replaceVC:(UIViewController *)vc;


@end
