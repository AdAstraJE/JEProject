
#import "JEBaseBackView.h"
#import "JEKit.h"

const static CGFloat kAnimateDuration  = 0.25;///< 动画时间
#define kViewMargin (ScreenWidth *0.11)

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  @implementation JEBaseBackView   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JEBaseBackView

- (void)dealloc{ jkDeallocLog}

+ (instancetype)Show{
    JEBaseBackView *view = [[[self class] alloc] initWithFrame:JEApp.window.bounds];
    [JEApp.window addSubview:view];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame contentHieht:(CGFloat)height{
    self = [super initWithFrame:frame];
    self.alpha = 0;
    self.backgroundColor = kRGBA(0, 0, 0, 0.2);
    
    _backView =  JEVe(self.bounds, nil, self);//隐藏的点击背景
    _Ve_content = JEVe(JR(kViewMargin, (ScreenHeight - height)/2, ScreenWidth - kViewMargin*2, height), UIColor.clearColor, self);
    _Ve_content.rad = 14;
    _maskView = JEEFVe(_Ve_content.bounds, UIBlurEffectStyleExtraLight, _Ve_content);
    
    return self;
}

- (void)resetWidth:(CGFloat)widht{
    _Ve_content.frame = CGRectMake((ScreenWidth - widht)/2, _Ve_content.y, widht, _Ve_content.height);
    _maskView.frame = _Ve_content.bounds;
}

- (void)setPopType:(JEPopType)popType{
    _popType = popType;
    if (_popType == JEPopTypeBottom) {
        _Ve_content.height += ScreenSafeArea;
        _Ve_content.frame = CGRectMake(0, ScreenHeight, ScreenWidth, _Ve_content.height);
        _maskView.frame = _Ve_content.bounds;
    }else{
        _Ve_content.y = (ScreenHeight - _Ve_content.height)/2;
    }
}

- (void)setTapToDismiss:(BOOL)tapToDismiss{
    _tapToDismiss = tapToDismiss;
    tapToDismiss ? [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]] : [_backView removeGestureRecognizer:_backView.gestureRecognizers.firstObject];
}

- (void)show{
    NSAssert(_Ve_content != nil, @"");
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.alpha = 1;
        if (self -> _popType == JEPopTypeBottom) { self->_Ve_content.y = (self->_Ve_content.y - self->_Ve_content.height);}
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.alpha = 0;
        if (self -> _popType == JEPopTypeBottom) { self -> _Ve_content.y = ScreenHeight;}
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  举个例子   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JEInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame contentHieht:140];
    //    self.popType = JEPopTypeBottom;
    //    self.tapToDismiss = YES;
    
    
    [self show];
    
    return self;
}

@end
