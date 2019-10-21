//
//  UIButton+JE.h
//
//
//  Created by JE on 15/10/15.
//  Copyright © 2015年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JE)

/**  (font = NSNumber | UIFont) ~~~ (img = UIColor | imageName | 渐变色数组) */
+ (instancetype)Frame:(CGRect)frame title:(NSString*)title font:(id)font color:(UIColor*)titleColor rad:(CGFloat)rad tar:(id)target sel:(SEL)action img:(id)img;

/** 设置 backgroundImage 颜色 */
@property (nonatomic,strong) IBInspectable UIColor *bcImg;
@property (nonatomic,strong) IBInspectable UIColor *bcImg_h;

@property (nonatomic,strong) NSString *text;///< [self setTitle:text forState:UIControlStateNormal]

/** 添加倒角线条线框图 */
- (void)je_addImgByRadius:(CGFloat)rad color:(UIColor *)color lineWidth:(CGFloat)width;
- (void)je_addImgByRadius:(CGFloat)rad color:(UIColor *)color lineWidth:(CGFloat)width bcColor:(UIColor *)bcColor;

/** 添加倒角纯色背景图 */
- (void)je_addBackImg:(UIColor *)color rad:(CGFloat)rad;
    
/** 适应当前宽 */
- (instancetype)sizeThatWidth;

/** 全部有行间距的 */
- (instancetype)paragraph:(CGFloat)para str:(NSString*)str state:(UIControlState)state;

/** 倒计时 总秒数 按钮文本后缀 结束时的回调*/
- (void)je_countDowns:(NSInteger)timeLine suffix:(NSString *)suffix end:(void(^)(void))block;

typedef void (^je_btnClickBlock)(__kindof UIButton *sender);
- (__kindof UIButton *)click:(je_btnClickBlock)block;

@end
