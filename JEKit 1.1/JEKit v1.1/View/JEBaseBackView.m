
#import "JEBaseBackView.h"
#import "JEKit.h"

const static CGFloat kAnimateDuration  = 0.2;///< 动画时间
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
    self.tintColor = Clr_blue;
    self.alpha = 0;
    self.backgroundColor = [UIColor Light:kRGBA(0, 0, 0, 0.382) dark:kRGBA(0, 0, 0, 0.618)];
    
    _backView =  JEVe(self.bounds, nil, self).jo.insets(0);//隐藏的点击背景
    CGFloat w = MIN(kSW, kSH)*0.89;
    
    _Ve_content = JEVe(JR0, [UIColor Light:kRGBA(255, 255, 255, 0.6) dark:kRGBA(62, 62, 62, 0.8)], self);
    _Ve_content.jo.inCenterX().y((kSH - height)/2).w(w).h(height);
    _Ve_content.rad = 14;
    _maskView = JEEFVe(JR0, UIBlurEffectStyleRegular, _Ve_content).jo.insets(0);
    
    [self handelStyleDark];
    
    return self;
}

- (void)setPopType:(JEPopType)popType{
    _popType = popType;
    if (_popType == JEPopTypeBottom) {
        [_Ve_content jo_clearAutoLayoutSettings];
        _Ve_content.jo.y(kSH).h(_Ve_content.height + ScreenSafeArea).left(0).right(0);
    }else{
        _Ve_content.jo.y((kSH - _Ve_content.height)/2);
    }
}

- (void)resetWidth:(CGFloat)widht{
    _Ve_content.jo.w(widht);
}

- (void)resetHeight:(CGFloat)height{
    _Ve_content.jo.h(height);
}

- (void)addCancelConfirmBtn{
    CGFloat btnH = 44;
    UIView *_ = _Ve_content;
    _Btn_cancel = JEBtn(JR0,@"取消".loc,fontM(17),self.tintColor,self,@selector(dismiss),nil,0,_);
    _Btn_cancel.jo.left(0).bottom(0).w_rate(_, 0.5).h(btnH);
    [_Btn_cancel setTitleColor:self.tintColor forState:(UIControlStateHighlighted)];
    
    _Btn_confirm = JEBtn(JR0,@"确定".loc,font(17),self.tintColor,self,@selector(confirmBtnClick),nil,0,_);
    _Btn_confirm.jo.right(0).bottom(0).w_rate(_, 0.5).h(btnH);
    [_Btn_confirm setTitleColor:self.tintColor forState:(UIControlStateHighlighted)];
    
    _lineH = JEVe(JR0, UIColor.je_sep, _).jo.left(0).bottom(btnH+0.5).right(0).h(0.5).me;
    _lineV = JEVe(JR0, UIColor.je_sep, _).jo.inCenterX().bottom(0).wh(0.6,btnH).me;
    
    [self handelStyleDark];
}

- (void)setTapToDismiss:(BOOL)tapToDismiss{
    _tapToDismiss = tapToDismiss;
    tapToDismiss ? [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]] : [_backView removeGestureRecognizer:_backView.gestureRecognizers.firstObject];
}

- (void)show{
    NSAssert(_Ve_content != nil, @"");
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.alpha = 1;
        if (self -> _popType == JEPopTypeBottom) {
            self->_Ve_content.jo.y(self->_Ve_content.y - self->_Ve_content.height).bottom(0);
        }
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.alpha = 0;
        if (self -> _popType == JEPopTypeBottom) {
            self->_Ve_content.jo.y(kSH);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)confirmBtnClick{
    
}

#pragma mark - StyleDark 深色模式
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    [self handelStyleDark];
}

- (void)handelStyleDark{
    BOOL dark = NO;
    if (@available(iOS 13.0, *)) {dark = (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);}
    
    UIColor *clr = (dark ? kRGB(62, 62, 62) : kRGB(222, 222, 222));
    UIImage *image = UIImage.clr(clr);
    [_Btn_cancel setBackgroundImage:image forState:UIControlStateHighlighted];
    [_Btn_confirm setBackgroundImage:image forState:UIControlStateHighlighted]; 
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
