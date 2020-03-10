
#import "JERefreshHeader.h"
#import "JEKit.h"

@interface JERefreshHeader()
{
    __unsafe_unretained UIImageView *_arrowView;
    CAShapeLayer *shapeLayer;
}
@property (weak, nonatomic, readonly) UIImageView *arrowView;
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation JERefreshHeader

//UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.tintColor = [UIColor grayColor];
////    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//    [refreshControl addTarget:self action:@selector(refreshTabView) forControlEvents:UIControlEventValueChanged];
//    _Col.refreshControl = refreshControl;
//    [_Col setContentOffset:CGPointMake(0, _Col.y - _Col.refreshControl.frame.size.height) animated:NO];
//    [_Col.refreshControl beginRefreshing];
//    [_Col.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
//
//    [_Col.refreshControl endRefreshing];

#pragma mark - 懒加载子控件
- (UIImageView *)arrowView{
    if (!_arrowView) {
        shapeLayer = [CAShapeLayer layer];
        UIImage *image = JEBundleImg(@"ic_refreshArrow").clr(Tgray2);
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

- (UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    _arrowView.image = JEBundleImg(@"ic_refreshArrow").clr(_color);
}

#pragma mark - 公共方法
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
    
    self.loadingView = nil;
    [self setNeedsLayout];
}

#pragma mark - 重写父类的方法
- (void)placeSubviews{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
//    if (!self.stateLabel.hidden) {
//        arrowCenterX -= 100;
//    }
    CGFloat arrowCenterY = self.mj_h * 0.618;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    if (self.state == MJRefreshStateRefreshing) {
        [shapeLayer removeFromSuperlayer];
        return;
    }
    
    if (_arrowView.mj_x == 0) {
        return;
    }
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    CGFloat offsetY = self.scrollView.mj_offsetY + 12.0f;

    if (offsetY > 0) {
        offsetY = 0;
    }
    if ((int)offsetY == 0) {
        return;
    }
    if (offsetY - happenOffsetY >= 0) {
        return;
    }
    
    // 普通 和 即将刷新 的临界点
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
    if (pullingPercent > 1) {
        pullingPercent = 1;
    }
    
    float startAngle = - M_PI_2 + 0.2;
    float endAngle = startAngle + (2.0 * M_PI * pullingPercent) + 0.8;
    if (pullingPercent < 0.1) {
        startAngle = endAngle;
    }
    CGFloat radius = _arrowView.mj_w*0.8;

    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 1;
    [path addArcWithCenter:_arrowView.center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = _color ? _color.CGColor : Tgray2.CGColor;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [shapeLayer removeFromSuperlayer];
    [self.layer addSublayer:shapeLayer];
    
}

- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                self.arrowView.hidden = NO;
            }];
        } else {
            [self.loadingView stopAnimating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.loadingView stopAnimating];
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startAnimating];
        self.arrowView.hidden = YES;
        [shapeLayer removeFromSuperlayer];
    }
}

@end
