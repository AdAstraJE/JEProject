
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (JE)

/// LayerWithPath
+ (CAShapeLayer *)LayerWithPath:(CGPathRef)path;

/// 文本阴影
- (void)textShadow:(UIColor *)clr;

/// 画线
+ (CAShapeLayer *)je_drawLine:(CGPoint)points to:(CGPoint)pointe color:(UIColor*)color;

/// 画虚线
+ (CAShapeLayer *)je_drawDashPattern:(CGPoint)points to:(CGPoint)pointe color:(UIColor*)color arr:(NSArray<NSNumber *> *)arr;

/// 画框框线
+ (CAShapeLayer *)je_drawRect:(CGRect)rect Radius:(CGFloat)redius color:(UIColor*)color;

/// 添加虚线 @[@(1),@(5)]
- (void)je_addSquareDottedLine:(NSArray*)lineDashPattern Radius:(CGFloat)Radius;

/// 原地旋转动画
- (CABasicAnimation *)je_rotationWithDuration:(CGFloat)duration;

/// 颤抖效果
- (CAAnimation *)je_Shake;

/// 渐显效果
- (CATransition*)je_fade;

/// 渐显效果 效果时间
- (CATransition*)je_fade:(CGFloat)time;

/// 缩放效果
- (CAKeyframeAnimation *)je_transformscale;

/// 心跳效果
- (CAKeyframeAnimation *)je_heartBeat;

/// rotationAnimation direction   x | y | z
- (CAAnimation *)je_rotationAnimation:(NSString*)direction duration:(NSTimeInterval)duration isReverse:(BOOL)isReverse repeatCount:(NSUInteger)repeatCount;

@end
