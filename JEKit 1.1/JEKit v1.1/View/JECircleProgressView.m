
#import "JECircleProgressView.h"

#define kCircleDegree(d) ((d)*M_PI)/180.0
#define kScreenWidth (self.frame.size.width)
#define kScreenHeight (self.frame.size.height)

@interface JECircleProgressView ()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *backLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, assign) CGFloat realWidth;///< 实际边长
@property (nonatomic, assign) CGFloat radius;///< 半径
@property (nonatomic, assign) CGFloat lastProgress;///<  上次进度 0-1

@property (nonatomic,strong) UIImageView *Img_start;///< 固定显示的起始点图片
@property (nonatomic,assign) CGFloat startDotDegress;///< 起始点图片偏移角度
@property (nonatomic,assign) CGPoint startDotOffset;///< 起始点图片偏移位置

@end

@implementation JECircleProgressView

- (instancetype)initWithFrame:(CGRect)frame stroke:(UIColor *)strokeColor fill:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth start:(CGFloat)startAngle reduce:(CGFloat)reduceAngle{
    return [self initWithFrame:frame stroke:strokeColor fill:fillColor lineWidth:lineWidth start:startAngle reduce:reduceAngle backLineWidth:lineWidth];
}

- (instancetype)initWithFrame:(CGRect)frame stroke:(UIColor *)strokeColor fill:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth start:(CGFloat)startAngle reduce:(CGFloat)reduceAngle backLineWidth:(CGFloat)backLineWidth{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    _strokeColor = strokeColor;
    _fillColor = fillColor;
    
    _lineWidth = lineWidth;
    _backLineWidth = backLineWidth;
    _startAngle = kCircleDegree(startAngle);
    _reduceAngle = kCircleDegree(reduceAngle);
    
    _increaseFromLast = YES;
    _animation = YES;
    _duration = 0.35;
    
    _realWidth = kScreenWidth>kScreenHeight?kScreenHeight:kScreenWidth;
    _radius = _realWidth/2.0 - _lineWidth/2.0;
    
    [self backLayer];
    
    return self;
}

- (void)showStartDot:(UIImage *)image size:(CGSize)size degree:(CGFloat)degress offset:(CGPoint)offset{
    self.Img_start.frame = CGRectMake(-1, -1, size.width, size.height);
    _Img_start.image = image;
    _startDotDegress = degress;
    _startDotOffset = offset;
    [self updateDotPosition:YES];
}

- (void)showEndDot:(UIImage *)image size:(CGSize)size{
    self.Img_end.frame = CGRectMake(-1, -1, size.width, size.height);
    _Img_end.image = image;
    [self updateDotPosition:YES];
}

- (UIImageView *)Img_start{ if (_Img_start == nil) { _Img_start = [[UIImageView alloc] init];[self addSubview:_Img_start];} return _Img_start;}
- (UIImageView *)Img_end{ if (_Img_end == nil) { _Img_end = [[UIImageView alloc] init];[self addSubview:_Img_end];} return _Img_end;}

- (CAShapeLayer *)backLayer {
    if (!_backLayer) {
        CAShapeLayer *_ = [CAShapeLayer layer];
        _.frame = CGRectMake((kScreenWidth-_realWidth)/2.0, (kScreenHeight-_realWidth)/2.0, _realWidth, _realWidth);
        _.fillColor = [UIColor clearColor].CGColor;//填充色
        _.lineWidth = _backLineWidth;
        _.strokeColor = _strokeColor.CGColor;
        _.lineCap = kCALineCapRound;
        
        UIBezierPath *backCirclePath = [self getNewBezierPath];
        _.path = backCirclePath.CGPath;
        [self.layer addSublayer:(_backLayer = _)];
    }
    return _backLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        CAShapeLayer *_ = [CAShapeLayer layer];
        _.frame = CGRectMake((kScreenWidth-_realWidth)/2.0, (kScreenHeight-_realWidth)/2.0, _realWidth, _realWidth);
        _.fillColor = [UIColor clearColor].CGColor;//填充色
        _.lineWidth = _lineWidth;
        _.strokeColor = _fillColor.CGColor;
        _.lineCap = kCALineCapRound;
        
        UIBezierPath *circlePath = [self getNewBezierPath];
        _.path = circlePath.CGPath;
        [self.layer addSublayer:(_progressLayer = _)];
    }
    return _progressLayer;
}

- (void)setStartAngle:(CGFloat)startAngle {
    if (_startAngle != kCircleDegree(startAngle)) {
        _startAngle = kCircleDegree(startAngle);
        
        //如果已经创建了相关layer则重新创建
        UIBezierPath *backCirclePath = [self getNewBezierPath];
        _backLayer.path = backCirclePath.CGPath;
        
        UIBezierPath *circlePath = [self getNewBezierPath];
        _progressLayer.path = circlePath.CGPath;
    }
    
    self.progress = _progress;[_Img_end.layer removeAllAnimations];
}

- (void)setReduceAngle:(CGFloat)reduceAngle {
    if (_reduceAngle != kCircleDegree(reduceAngle)) {
        if (reduceAngle>=360) {
            return;
        }
        _reduceAngle = kCircleDegree(reduceAngle);
        
        UIBezierPath *backCirclePath = [self getNewBezierPath];
        _backLayer.path = backCirclePath.CGPath;
        
        UIBezierPath *circlePath = [self getNewBezierPath];
        _progressLayer.path = circlePath.CGPath;
    }
    
    self.progress = _progress;[_Img_end.layer removeAllAnimations];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    _radius = _realWidth/2.0 - _lineWidth/2.0;
    
    //设置线宽之后会导致radius改变，因此需要修改使用过strokeWidth和radius的属性
    _backLayer.lineWidth = _lineWidth;
    UIBezierPath *backCirclePath = [self getNewBezierPath];
    _backLayer.path = backCirclePath.CGPath;
    
    _progressLayer.lineWidth = _lineWidth;
    UIBezierPath *circlePath = [self getNewBezierPath];
    _progressLayer.path = circlePath.CGPath;
    
    self.progress = _progress;
    [_Img_end.layer removeAllAnimations];
}

- (void)setStrokeColor:(UIColor *)pathBackColor {
    _backLayer.strokeColor = (_strokeColor = pathBackColor).CGColor;
}

- (void)setFillColor:(UIColor *)pathFillColor {
    _progressLayer.strokeColor = (_fillColor = pathFillColor).CGColor;
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animation:YES];
}

- (void)setProgress:(CGFloat)progress animation:(BOOL)animation{
    _progress = progress;
    if (_progress < 0) { _progress = 0;} if (_progress > 1) { _progress = 1;}
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_realWidth/2.0, _realWidth/2.0) radius:_radius startAngle:_startAngle endAngle:(2*M_PI-_reduceAngle)*_progress +_startAngle clockwise:YES];
    self.progressLayer.path = circlePath.CGPath;
    
    if (animation) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = _duration;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:_lastProgress/_progress];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        _progressLayer.strokeEnd = 1.0;
    }
    
    [self updateDotPosition:animation];
    _lastProgress = _progress;
}

/// 刷新最新路径
- (UIBezierPath *)getNewBezierPath {
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(_realWidth/2.0, _realWidth/2.0) radius:_radius startAngle:_startAngle endAngle:(2*M_PI-_reduceAngle+_startAngle) clockwise:YES];
}

- (void)updateDotPosition:(BOOL)animation{
    CGFloat startDotAngle = (2*M_PI-_reduceAngle)*kCircleDegree(_startDotDegress) + _startAngle;
    
    CGFloat rad = _radius + _endDotFixRad;
    _Img_start.center = CGPointMake(_startDotOffset.x + (kScreenWidth - kScreenHeight)/2 + _realWidth/2.0+rad*cosf(startDotAngle),_startDotOffset.y + _realWidth/2.0+rad*sinf(startDotAngle));
    [self bringSubviewToFront:_Img_start];
    
    CGFloat endDotAngle = (2*M_PI-_reduceAngle)*_progress +_startAngle;
    if (isnan(endDotAngle)) {
        endDotAngle = 0;
    }
    _Img_end.center = CGPointMake((kScreenWidth - kScreenHeight)/2 + _realWidth/2.0+rad*cosf(endDotAngle), _realWidth/2.0+rad*sinf(endDotAngle));
    [self bringSubviewToFront:_Img_end];
    
    if (_Img_end == nil) {return;}
    CAKeyframeAnimation *pointAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pointAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pointAnimation.fillMode = kCAFillModeForwards;
    pointAnimation.calculationMode = @"paced";
    pointAnimation.removedOnCompletion = YES;
    pointAnimation.duration = animation ? _duration : 0;
    pointAnimation.delegate = self;
    
    BOOL clockwise = NO;
    if (_progress < _lastProgress && _increaseFromLast == YES) {
        clockwise = YES;
    }
    
    UIBezierPath *imagePath = [UIBezierPath bezierPathWithArcCenter:
                               CGPointMake((kScreenWidth - kScreenHeight)/2 + _realWidth/2.0, _realWidth/2.0)
                                                             radius:rad
                                                         startAngle:_increaseFromLast ? ((2*M_PI-_reduceAngle)*_lastProgress +_startAngle) : _startAngle
                                                           endAngle:endDotAngle
                                                          clockwise:!clockwise];
    pointAnimation.path = imagePath.CGPath;
    if (animation) {
        [_Img_end.layer addAnimation:pointAnimation forKey:nil];
    }

    [UIView animateWithDuration:_duration animations:^{
        self->_Img_end.transform = CGAffineTransformMakeRotation(endDotAngle);
    }];
    
    if (!_increaseFromLast && _progress == 0.0) {
        [_Img_end.layer removeAllAnimations];
    }
}


@end
