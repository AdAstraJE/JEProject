//
//  JEIntroducView.h
//  JEKit
//
//  Created by JE on 2018/6/10.
//  Copyright © 2018年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 引导页 */
@interface JEIntroducView : UIView 

/**  默认效果，有UIPageControl (tint = PageControl & 按钮颜色) */
+ (instancetype)Introduc:(NSArray <UIImage *> *)images tint:(UIColor *)tintColor;

/** 滑动显示文体、图片渐变效果 @[@[@"title1",@"title2",@"title3"],@[@"detail1",@"detail2",@"detail"]]*/
+ (instancetype)Introduc:(NSArray <UIImage *> *)images tint:(UIColor *)tintColor titleDesc:(NSArray <NSArray <NSString *> *> *)titleDesc descColor:(UIColor *)descColor;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <UIImage *> *)images tint:(UIColor *)tintColor titleDesc:(NSArray <NSArray <NSString *> *> *)titleDesc descColor:(UIColor *)descColor;

/** 重设描述图片frame */
- (void)resetDescImgFrame:(CGRect)frame;

- (void)dismiss;

@property (nonatomic,strong) UIColor *titleColor;///< ..
@property (nonatomic,strong) NSArray <UIColor *> *Arr_colors;///< 重设进入按钮渐变色
@property (nonatomic,strong) UIButton *Btn_finish;///< 进入应用
@property (nonatomic,strong) UIPageControl *Page;
@end
