#import "JELongPressButton.h"

static CGFloat const jkAngleFix = 90.0;///< 减90度开始

@implementation JELongPressButton{
    void (^_longPressEndBlock)(void); 
}

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineGap:(CGFloat)lineGap done:(void (^)(void))done{
    self = [super initWithFrame:frame];
    _longPressEndBlock = done;
    CGFloat WH = MAX(CGRectGetWidth(frame), CGRectGetHeight(frame));
    
    CAShapeLayer * (^defaultLayer)(UIColor *fillColor) = ^(UIColor *strokeColor){
        CAShapeLayer *_ = [CAShapeLayer layer];
        _.frame = CGRectMake(0, 0, WH, WH);
        _.fillColor = [UIColor clearColor].CGColor;
        _.lineWidth = lineWidth;
        _.strokeColor = strokeColor.CGColor;
        
        CGFloat angleFix = ((jkAngleFix)*M_PI)/180.0;
        _.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(WH/2.0, WH/2.0) radius:WH/2.0 - lineWidth/2.0 startAngle:-angleFix endAngle:(2*M_PI + angleFix) clockwise:YES].CGPath;
        return _;
    };
    
    [self.layer addSublayer:(_backLayer = defaultLayer([UIColor colorWithWhite:1 alpha:0.5]))];
    [self.layer addSublayer:(_frontLayer = defaultLayer([UIColor whiteColor]))];

    _backLayer.hidden = YES;
    _frontLayer.strokeEnd = 0;
    CGFloat btnWH = (WH - lineGap*2 - lineWidth*2);
    
    [self addSubview:(_Btn =  [[UIButton alloc] initWithFrame:CGRectMake((WH - btnWH)/2, (WH - btnWH)/2, btnWH, btnWH)])];
    [_Btn addTarget:self action:@selector(touchDown) forControlEvents:(UIControlEventTouchDown)];
    [_Btn addTarget:self action:@selector(touchCancel) forControlEvents:(UIControlEventTouchUpOutside | UIControlEventTouchUpInside)];

    return self;
}

- (void)touchDown{
    CGFloat delay = 0.1;
    NSLog(@"%f",_frontLayer.strokeEnd += delay);
    if (_frontLayer.strokeEnd >= (1 - jkAngleFix/360.0)) {
        [self touchCancel];
        !_longPressEndBlock ? : _longPressEndBlock();
        return;
    }

    if (_backLayer.hidden) {  _backLayer.hidden = NO; }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self->_backLayer.hidden) { [self touchDown];}
    });
}

- (void)touchCancel{
    _frontLayer.strokeEnd = 0;
    [_frontLayer removeAllAnimations];
    _backLayer.hidden = YES;
}

@end
