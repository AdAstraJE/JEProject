
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
    self.backgroundColor = [UIColor Light:kRGBA(0, 0, 0, 0.2) dark:kRGBA(0, 0, 0, 0.48)];
    
    _backView =  JEVe(self.bounds, nil, self);//隐藏的点击背景
    _Ve_content = JEVe(JR(kViewMargin, (ScreenHeight - height)/2, ScreenWidth - kViewMargin*2, height), [UIColor Light:kRGBA(255, 255, 255, 0.6) dark:kRGBA(62, 62, 62, 0.8)], self);
    _Ve_content.rad = 14;
    _maskView = JEEFVe(_Ve_content.bounds, UIBlurEffectStyleRegular, _Ve_content);
    [self handelStyleDark];
    
    return self;
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

- (void)resetWidth:(CGFloat)widht{
    _Ve_content.frame = CGRectMake((ScreenWidth - widht)/2, _Ve_content.y, widht, _Ve_content.height);
    _maskView.frame = _Ve_content.bounds;
}

- (void)resetHeight:(CGFloat)height{
    _Ve_content.height = height;
    _maskView.frame = _Ve_content.bounds;
    
    UIView *_ = _Ve_content;
    _Btn_confirm.y =_Btn_cancel.y = _.height - _Btn_cancel.height;
    _lineV.y = _lineH.y = _.height - _Btn_cancel.height - 0.5;
}

- (void)addCancelConfirmBtn{
    CGFloat btnH = 44;
    UIView *_ = _Ve_content;
    _Btn_cancel = JEBtn(JR(0, _.height - btnH, _.width/2,btnH),@"取消".loc,fontM(17),self.tintColor,self,@selector(dismiss),nil,0,_);
    [_Btn_cancel setTitleColor:self.tintColor forState:(UIControlStateHighlighted)];

    _Btn_confirm = JEBtn(JR(_Btn_cancel.width,_Btn_cancel.y, _Btn_cancel.width,btnH),@"确定".loc,font(17),self.tintColor,self,@selector(confirmBtnClick),nil,0,_);
    [_Btn_confirm setTitleColor:self.tintColor forState:(UIControlStateHighlighted)];

    _lineH = JEVe(JR(0, _.height - btnH - 0.5, _.width, 0.5), UIColor.je_sepLine, _);
    _lineV = JEVe(JR(_.width/2 - 0.3, _lineH.y, 0.6, btnH), UIColor.je_sepLine, _);
//    [_ insertSubview:_line1 atIndex:1];
//    [_ insertSubview:_line2 atIndex:1];
    
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

- (void)confirmBtnClick{
    
}

#pragma mark - StyleDark 黑暗模式
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
