
#import "JEGuideMaskView.h"

typedef NS_ENUM(NSInteger, JEGuideMaskDirection){
    /// 左上方
    JEGuideMaskDirectionLeftTop,
    /// 左下方
    JEGuideMaskDirectionLeftBottom,
    /// 右上方
    JEGuideMaskDirectionRightTop,
    /// 右下方
    JEGuideMaskDirectionRightBottom,
};

static NSTimeInterval const jkDuration = 0.25f;///< 动画时间

@interface JEGuideMaskView ()

@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation JEGuideMaskView{
    NSInteger _count;
    UILabel *_La_desc;
    CAShapeLayer *_maskLayer;
    NSArray <__kindof UIView *> * _Arr_view;
    NSArray <NSString *> * _Arr_desc;
}

+ (instancetype)ShowWithDatasource:(id<JEGuideMaskViewDataSource>)dataSource layout:(id<JEGuideMaskViewLayout>)layout{
    JEGuideMaskView *guideView = [[JEGuideMaskView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    guideView.dataSource = dataSource;
    guideView.layout = layout;
    [guideView show];
    return guideView;
}

+ (instancetype)ShowWithView:(NSArray <__kindof UIView *> *)views desc:(NSArray <NSString *> *)desc{
    JEGuideMaskView *guideView = [[JEGuideMaskView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    guideView->_Arr_view = views;
    guideView->_Arr_desc = desc;
    [guideView show];
    return guideView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    _maskLayer = [CAShapeLayer layer];
    [self addSubview:(_maskView = [[UIView alloc] initWithFrame:self.bounds])];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.7;
    
    UIImage *arrow = [UIImage imageNamed:[@"JEResource.bundle" stringByAppendingPathComponent:@"ic_guide_arrow"]];
    if (arrow == nil) { [UIImage imageNamed:@"ic_je_guide_arrow"];}
    if (arrow) {[self addSubview:(_arrowImgView = [[UIImageView alloc] initWithImage:arrow])]; }

    _La_desc = [UILabel new];
    _La_desc.numberOfLines = 0;
    _La_desc.textColor = [UIColor whiteColor];
    _La_desc.font = [UIFont systemFontOfSize:16];
    [self addSubview:_La_desc];
    return self;
}

#pragma mark - 显示蒙板

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    
    [self showMask];
    [self congifureItemsFrame];
}

- (void)showMask{
    CGPathRef fromPath = _maskLayer.path;
    
    /// 更新 maskLayer 的 尺寸
    _maskLayer.frame = self.bounds;
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGFloat maskCornerRadius = 5;
    
    if ([_layout respondsToSelector:@selector(guideMaskView:cornerRadiusForViewAtIndex:)]){
        maskCornerRadius = [_layout guideMaskView:self cornerRadiusForViewAtIndex:_currentIndex];
    }
    
    /// 获取可见区域的路径(开始路径)
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [toPath appendPath:[UIBezierPath bezierPathWithRoundedRect:[self fetchVisualFrame] cornerRadius:maskCornerRadius]];
    
    /// 遮罩的路径
    _maskLayer.path = toPath.CGPath;
    _maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = _maskLayer;
    
    /// 开始移动动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.duration  = jkDuration;
    anim.fromValue = (__bridge id _Nullable)(fromPath);
    anim.toValue   = (__bridge id _Nullable)(toPath.CGPath);
    [_maskLayer addAnimation:anim forKey:NULL];
}

- (void)congifureItemsFrame{
    if ([_layout respondsToSelector:@selector(guideMaskView:colorForDescriptionAtIndex:)]){
        _La_desc.textColor = [_layout guideMaskView:self colorForDescriptionAtIndex:_currentIndex];
    }
    
    if ([_layout respondsToSelector:@selector(guideMaskView:fontForDescriptionAtIndex:)]){
        _La_desc.font = [_layout guideMaskView:self fontForDescriptionAtIndex:_currentIndex];
    }
    
    NSString *desc = _dataSource ? [_dataSource guideMaskView:self descriptionForItemAtIndex:_currentIndex] : (_currentIndex < _Arr_desc.count ? _Arr_desc[_currentIndex]: @"");
    _La_desc.text = desc;
    
    /// 每个 item 的文字与左右边框间的距离
    CGFloat descInsetsX = 30;
    
    if ([_layout respondsToSelector:@selector(guideMaskView:horizontalInsetForDescriptionAtIndex:)]){
        descInsetsX = [_layout guideMaskView:self horizontalInsetForDescriptionAtIndex:_currentIndex];
    }
    
    /// 每个 item 的子视图（当前介绍的子视图、箭头、描述文字）之间的间距
    CGFloat space = 20;
    
    if ([_layout respondsToSelector:@selector(guideMaskView:spaceForItemAtIndex:)]){
        space = [_layout guideMaskView:self spaceForItemAtIndex:_currentIndex];
    }
    
    /// 设置 文字 与 箭头的位置
    CGRect textRect, arrowRect;
    CGSize imgSize   = _arrowImgView.image.size;
    CGFloat maxWidth = self.bounds.size.width - descInsetsX * 2;
    CGSize textSize  = [desc boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                     attributes:@{NSFontAttributeName : _La_desc.font}
                                                                        context:NULL].size;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    /// 获取 item 的 方位
    JEGuideMaskDirection itemRegion = [self fetchVisualRegion];
    
    switch (itemRegion){
        case JEGuideMaskDirectionLeftTop:{// 左上
            transform = CGAffineTransformMakeScale(-1, 1);
            arrowRect = CGRectMake(CGRectGetMidX([self fetchVisualFrame]) - imgSize.width * 0.5,
                                   CGRectGetMaxY([self fetchVisualFrame]) + space,
                                   imgSize.width,imgSize.height);
            CGFloat x = ((textSize.width < CGRectGetWidth([self fetchVisualFrame])) ? (CGRectGetMaxX(arrowRect) - textSize.width * 0.5) : (descInsetsX));
            textRect = CGRectMake(x, CGRectGetMaxY(arrowRect) + space, textSize.width, textSize.height);
            break;
        }
            
        case JEGuideMaskDirectionRightTop:{ // 右上
            arrowRect = CGRectMake(CGRectGetMidX([self fetchVisualFrame]) - imgSize.width * 0.5,
                                   CGRectGetMaxY([self fetchVisualFrame]) + space,
                                   imgSize.width,imgSize.height);
            CGFloat x = ((textSize.width < CGRectGetWidth([self fetchVisualFrame])) ? (CGRectGetMinX(arrowRect) - textSize.width * 0.5) : (descInsetsX + maxWidth - textSize.width));
            textRect = CGRectMake(x, CGRectGetMaxY(arrowRect) + space, textSize.width, textSize.height);
            break;
        }
            
        case JEGuideMaskDirectionLeftBottom:{// 左下
            transform = CGAffineTransformMakeScale(-1, -1);
            arrowRect = CGRectMake(CGRectGetMidX([self fetchVisualFrame]) - imgSize.width * 0.5,
                                   CGRectGetMinY([self fetchVisualFrame]) - space - imgSize.height,
                                   imgSize.width,imgSize.height);
            CGFloat x = ((textSize.width < CGRectGetWidth([self fetchVisualFrame])) ? (CGRectGetMaxX(arrowRect) - textSize.width * 0.5) : (descInsetsX));
            textRect = CGRectMake(x, CGRectGetMinY(arrowRect) - space - textSize.height, textSize.width, textSize.height);
            break;
        }
            
        case JEGuideMaskDirectionRightBottom:{// 右下
            transform = CGAffineTransformMakeScale(1, -1);
            arrowRect = CGRectMake(CGRectGetMidX([self fetchVisualFrame]) - imgSize.width * 0.5,
                                   CGRectGetMinY([self fetchVisualFrame]) - space - imgSize.height,
                                   imgSize.width,imgSize.height);
            CGFloat x = ((textSize.width < CGRectGetWidth([self fetchVisualFrame])) ? (CGRectGetMinX(arrowRect) - textSize.width * 0.5) : (descInsetsX + maxWidth - textSize.width));
            textRect = CGRectMake(x, CGRectGetMinY(arrowRect) - space - textSize.height, textSize.width, textSize.height);
            break;
        }
    }
    
    /// 图片 和 文字的动画
    [UIView animateWithDuration:jkDuration animations:^{
        self->_arrowImgView.transform = transform;
        self->_arrowImgView.frame = arrowRect;
        self->_La_desc.frame = textRect;
    }];
}

- (CGRect)fetchVisualFrame{
    if (_currentIndex >= _count){
        return CGRectZero;
    }
    
    UIView *view = _dataSource ? [_dataSource guideMaskView:self viewForItemAtIndex:_currentIndex] : _Arr_view[_currentIndex];
    CGRect visualRect = [self convertRect:view.frame fromView:view.superview];
    
    /// 每个 item 的 view 与蒙板的边距
    UIEdgeInsets maskInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    
    if ([_layout respondsToSelector:@selector(guideMaskView:insetForViewAtIndex:)]){
        [_layout guideMaskView:self insetForViewAtIndex:_currentIndex];
    }
    
    visualRect.origin.x += maskInsets.left;
    visualRect.origin.y += maskInsets.top;
    visualRect.size.width  -= (maskInsets.left + maskInsets.right);
    visualRect.size.height -= (maskInsets.top + maskInsets.bottom);
    
    return visualRect;
}

- (JEGuideMaskDirection)fetchVisualRegion{
    CGPoint visualCenter = CGPointMake(CGRectGetMidX([self fetchVisualFrame]),CGRectGetMidY([self fetchVisualFrame])); // 可见区域的中心坐标
    CGPoint viewCenter   = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));                         // self.view 的中心坐标
    
    if ((visualCenter.x <= viewCenter.x) && (visualCenter.y <= viewCenter.y))   {return JEGuideMaskDirectionLeftTop;}
    if ((visualCenter.x > viewCenter.x) && (visualCenter.y <= viewCenter.y))    {return JEGuideMaskDirectionRightTop;}
    if ((visualCenter.x <= viewCenter.x) && (visualCenter.y > viewCenter.y))    {return JEGuideMaskDirectionLeftBottom;}
    return JEGuideMaskDirectionRightBottom;
}


#pragma mark - 显示

- (void)show{
    _count = _dataSource ? [_dataSource numberOfItemsInGuideMaskView:self] : _Arr_view.count;
    if (_count == 0)  return;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alpha = 0;
    [UIView animateWithDuration:jkDuration animations:^{
        self.alpha = 1;
    }];

    /// 从 0 开始进行显示
    self.currentIndex = 0;
}

#pragma mark - 隐藏
- (void)hide{
    [UIView animateWithDuration:jkDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        !self->_dismissHandle ? : self->_dismissHandle();
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    (_currentIndex < _count - 1) ? (self.currentIndex ++) : ([self hide]);//下一个或消失
}

@end
