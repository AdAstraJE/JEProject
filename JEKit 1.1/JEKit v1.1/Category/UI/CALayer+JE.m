
#import "CALayer+JE.h"

@implementation CALayer (JE)

+ (CAShapeLayer *)LayerWithPath:(CGPathRef)path{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path;
    return layer;
}

+ (CAShapeLayer *)je_drawLine:(CGPoint)points to:(CGPoint)pointe color:(UIColor*)color{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:points];
    [path addLineToPoint:pointe];
    [path closePath];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    shapeLayer.lineWidth = 0.35;
    return shapeLayer;
}

+ (CAShapeLayer *)je_drawDashPattern:(CGPoint)points to:(CGPoint)pointe color:(UIColor*)color arr:(NSArray<NSNumber *> *)arr{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:points];
    [path addLineToPoint:pointe];
    [path closePath];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    shapeLayer.lineWidth = 0.5f;
    shapeLayer.lineCap = kCALineCapSquare;//@"round"
    shapeLayer.lineDashPattern = arr;
    return shapeLayer;
}

+ (CAShapeLayer *)je_drawRect:(CGRect)rect Radius:(CGFloat)redius color:(UIColor*)color{
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    UIBezierPath *solidPath =  [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:redius];
    solidLine.lineWidth = 0.35 ;
    solidLine.strokeColor = color.CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    solidLine.path = solidPath.CGPath;
    return solidLine;
}

- (void)je_addSquareDottedLine:(NSArray*)lineDashPattern Radius:(CGFloat)Radius{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor lightGrayColor].CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:Radius].CGPath;
    border.frame = self.bounds;
    border.lineWidth = 1.f;
    border.lineCap = kCALineCapSquare;
    border.lineDashPattern = lineDashPattern;
    [self addSublayer:border];
}

- (CABasicAnimation *)je_rotationWithDuration:(CGFloat)duration{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    animation.duration = duration;
    animation.repeatCount = MAXFLOAT;
    [self addAnimation:animation forKey:@"rotationAnimation"];
    return animation;
}

- (CAAnimation *)je_Shake{
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    shake.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)], [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)]];
    shake.autoreverses = YES;
    shake.repeatCount = 2.0f;
    shake.duration = 0.07f;
    [self addAnimation:shake forKey:nil];
    return shake;
}

- (CATransition*)je_fade{
    return [self je_fade:0.4];
}

- (CATransition*)je_fade:(CGFloat)time{
    CATransition *animation = [CATransition animation];
    [animation setDuration:time];
    [animation setType: kCATransitionFade];
    [animation setSubtype: kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self addAnimation:animation forKey:nil];
    return animation;
}

- (CAKeyframeAnimation *)je_transformscale{
    CAKeyframeAnimation *transformscale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    transformscale.values = @[@(0),@(0.5),@(1.08)];
    transformscale.keyTimes = @[@(0.0),@(0.2),@(0.4)];
    transformscale.calculationMode = kCAAnimationLinear;
    [self addAnimation:transformscale forKey:nil];
    return transformscale;
}

- (CAKeyframeAnimation *)je_heartBeat{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:self.transform],
                   [NSValue valueWithCATransform3D:CATransform3DScale(self.transform, 1.382, 1.382, 1)],
                   [NSValue valueWithCATransform3D:CATransform3DScale(self.transform, 1, 1, 1)],
                   [NSValue valueWithCATransform3D:CATransform3DScale(self.transform, 0.7, 0.7, 1)],
                   [NSValue valueWithCATransform3D:CATransform3DScale(self.transform, 1, 1, 1)], nil];
    anim.duration = 2;
    anim.removedOnCompletion = YES;
    anim.repeatCount = NSIntegerMax;
    [self addAnimation:anim forKey:nil];
    return anim;
}

- (CAAnimation *)je_rotationAnimation:(NSString*)direction duration:(NSTimeInterval)duration isReverse:(BOOL)isReverse repeatCount:(NSUInteger)repeatCount{
    NSString *key = @"reversAnim";
    if([self animationForKey:key]!=nil){
        [self removeAnimationForKey:key];
    }
    
    //创建普通动画
    CABasicAnimation *reversAnim = [CABasicAnimation animationWithKeyPath:[NSString stringWithFormat:@"transform.rotation.%@",direction]];
    reversAnim.fromValue=@(0);//起点值
    reversAnim.toValue = @(M_PI_2);//终点值
    reversAnim.duration = duration;//时长
    reversAnim.autoreverses = isReverse;//自动反转
    reversAnim.removedOnCompletion = YES;//完成删除
    reversAnim.repeatCount = repeatCount; //重复次数
    [self addAnimation:reversAnim forKey:key];
    
    return reversAnim;
}

@end
