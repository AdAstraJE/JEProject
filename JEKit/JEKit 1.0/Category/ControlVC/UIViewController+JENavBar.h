//
//  UIViewController+JENavBar.h
//   
//
//  Created by JE on 16/8/22.
//  Copyright © 2016年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JEButton;

@interface UIViewController (JENavBar)

//--------------------------------------UITabBarController UINavigationController 控制---------------------------------------
@property  UIColor *je_navBarColor;///< 导航栏背景颜色
@property (nonatomic,strong)  UIImage *je_navBarImage;///< 导航栏背景图片
@property (nonatomic,strong)  UIColor *je_navBarLineColor;///< 导航栏底部线条颜色 ### 默认背景白色时kHexColorA(0xCCCCCC,0.6)
@property (nonatomic,strong)  UIColor *je_navBarItemColor;///< 自定义导航栏 返回键按钮&标题颜色
@property (nonatomic,strong)  UIColor *je_titleColor;///< 标题颜色 高优先级
//-------------------------------------------------------------------------------------------------------------------
@property (nonatomic,strong)  UIImageView *Ve_jeNavBar;///< 自定义导航栏
@property (nonatomic,strong)  UIView *Ve_navBarline;///< 导航栏底部线条
@property (nonatomic,strong)  UILabel *La_title;///< 标题label
@property (nonatomic,strong)  UIButton *Btn_back;///< 返回按钮 

@property (nonatomic,assign) BOOL disabel_je_NavBar;///< 不使用自定义Bar ###默认使用的
@property (nonatomic,assign) BOOL ctrlBySelf;///< 用self VC控制以上属性

@property (nonatomic,copy) NSString *je_title;///< 


/** 使用自定义导航栏  */
- (void)je_useCustomNavBar;

/** 导航栏返回键点击事件 可重写控制返回 */
- (void)je_navPopBtnClick;

/** 自定义返回键 */
- (JEButton *)je_customNavBackButton;

/** 设置已存在的返回键标题 */
- (void)je_setBackButtonTitle:(NSString *)title;

/** 设置已存在的返回键颜色 */
- (void)je_setBackButtonColor:(UIColor *)color;

/** 构建 rightBarButtonItem title */
- (JEButton *)je_rightBarBtn:(NSString*)title act:(SEL)selector;
- (JEButton *)je_rightBarBtn:(NSString*)title target:(id)target act:(SEL)selector;

/** 构建 rightBarButtonItem  image or ImageName */
- (JEButton *)je_rightBarBtnImgN:(id)imageN act:(SEL)selector;
- (JEButton *)je_rightBarBtnImgN:(id)imageN target:(id)target act:(SEL)selector;

@end
