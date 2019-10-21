//
//  CALayer+JE.h
//  
//
//  Created by JE on 15/6/15.
//  Copyright © 2015年 JE. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (JE)

+ (CAShapeLayer *)LayerWithPath:(CGPathRef)path;

+ (CAShapeLayer *)je_DrawLine:(CGPoint)points To:(CGPoint)pointe color:(UIColor*)color;/**< 画线 */
+ (CAShapeLayer *)je_DrawDashPattern:(CGPoint)points To:(CGPoint)pointe color:(UIColor*)color arr:(NSArray<NSNumber *> *)arr;///< 画虚线
+ (CAShapeLayer *)je_drawRect:(CGRect)rect Radius:(CGFloat)redius color:(UIColor*)color;/**< 画框框线 */
- (void)je_addSquareDottedLine:(NSArray*)lineDashPattern Radius:(CGFloat)Radius;/**< 添加虚线 @[@(1),@(5)] */

/** 原地旋转动画 */
- (CABasicAnimation *)je_rotationWithDuration:(CGFloat)duration;

/** 颤抖效果 */
- (CAAnimation *)je_Shake;

/** 渐显效果 */
- (CATransition*)je_fade;

/** 渐显效果 效果时间 */
- (CATransition*)je_fade:(CGFloat)time;

/** 缩放效果 */
- (CAKeyframeAnimation *)je_transformscale;

/** 心跳效果 */
- (CAKeyframeAnimation *)je_heartBeat;
    
/**
 *   rotationAnimation
 *
 *  @param direction   x | y | z
 */
- (CAAnimation *)rotationAnimation:(NSString*)direction duration:(NSTimeInterval)duration isReverse:(BOOL)isReverse repeatCount:(NSUInteger)repeatCount;

@end
