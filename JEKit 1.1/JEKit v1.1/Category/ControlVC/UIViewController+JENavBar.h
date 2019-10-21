
#import <UIKit/UIKit.h>
@class JEButton;

@interface UIViewController (JENavBar)

//--------------------------------------UITabBarController UINavigationController 控制---------------------------------------
@property (nonatomic,strong)  UIColor *je_navBarClr;///< 导航栏背景颜色 ### [UIColor whiteColor]
@property (nonatomic,strong)  UIImage *je_navBarImage;///< 导航栏背景图片 ### nil
@property (nonatomic,strong)  UIColor *je_navBarLineClr;///< 导航栏底部线条颜色 ### kHexColorA(0xCCCCCC,0.6)
@property (nonatomic,strong)  UIColor *je_navBarItemClr;///< 自定义导航栏 返回键按钮&标题颜色
@property (nonatomic,strong)  UIColor *je_navTitleClr;///< 标题颜色 高优先级
//-------------------------------------------------------------------------------------------------------------------
@property (nonatomic,strong)  UIImageView *je_navBar;///< 自定义导航栏
@property (nonatomic,strong)  UIView *je_navBarline;///< 导航栏底部线条
@property (nonatomic,strong)  UILabel *je_La_title;///< 标题label
@property (nonatomic,strong)  JEButton *je_Btn_back;///< 返回按钮 
@property (nonatomic,assign) BOOL je_disableNavBar;///< 不使用自定义Bar ###默认使用的
@property (nonatomic,assign) BOOL je_ctrlBySelf;///< 用self VC控制以上属性

- (UIViewController *)je_ctrlVC;///< 控制属性的VC

/// 使用自定义导航栏
- (void)je_useCustomNavBar;

/// 导航栏返回键点击事件 可重写控制返回
- (void)je_navPopBtnClick;

/// 设置返回键标题
- (JEButton *)je_leftNavBtn:(id)item;

/// 导航栏右边按钮
- (JEButton *)je_rightNavBtn:(id)item target:(id)target act:(SEL)selector;

@end
