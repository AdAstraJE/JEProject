
#import "JEShowImg.h"
#import "JEKit.h"
#import "YYAnimatedImageView.h"

static CGFloat const jkDuration = 0.2;///<

@implementation JEShowImg{
    __weak UIView *_Ve_from;
    
    CGRect _oldframe;
    CGRect _original;
    UIVisualEffectView *_Ve_effect;
    YYAnimatedImageView  *_ImgV;
    JEButton *_Btn_action;
}

+ (instancetype)ShowImgFrom:(UIImageView*)view{
    return [JEShowImg ShowImgFrom:view tureImg:nil];
}

+ (instancetype)ShowImgFrom:(UIImageView*)view tureImg:(UIImage*)tureimg {
    return [JEShowImg ShowImgFrom:view tureImg:tureimg action:YES];
}

+ (instancetype)ShowImgFrom:(UIImageView*)from tureImg:(UIImage*)tureImg action:(BOOL)action{
    if (from.image == nil) {return nil;}
    UIImage *img = tureImg;
    if (tureImg == nil && [from isKindOfClass:[UIImageView class]] ) {
        img = from.image;
    }
    if (img == nil) {return nil;}
    JEShowImg *view = [[JEShowImg alloc] initWithFrame:JR(0, 0, kSW, kSH) from:from tureImg:tureImg action:action].addTo(JEApp.window);
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame from:(UIImageView*)from tureImg:(UIImage*)tureImg action:(BOOL)action{
    self = [super initWithFrame:frame];
    self.alpha = 0;
    _Ve_from = from;

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _Ve_effect = [[UIVisualEffectView alloc] initWithEffect:effect].addTo(self);
    _Ve_effect.frame = self.bounds;
    
    _oldframe = [from convertRect:from.bounds toView:JEApp.window];
    _ImgV = [[YYAnimatedImageView alloc] initWithFrame:_oldframe].addTo(self);
    _ImgV.image = tureImg ? : from.image;
    
    _ImgV.contentMode = from.contentMode;
    _ImgV.userInteractionEnabled = YES;
    _ImgV.clipsToBounds  = from.clipsToBounds;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideImage)];
    tapGes.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self addGestureRecognizer:tapGes];
    
    UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    pinGes.delegate = (id<UIGestureRecognizerDelegate>)self;
    [_ImgV addGestureRecognizer:pinGes];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [_ImgV addGestureRecognizer:panGestureRecognizer];
    
    if (action) {
        UIImage *image = JEBundleImg(@"ic_navAction").clr(Clr_blue);
        _Btn_action = JEBtn(JR(kSW - 23 - 16,ScreenStatusBarH + 9,23,26),nil,@0,nil,self,@selector(JEShowImgShareBtnClick),image,0,self).touchs(15,15,15,15);
    }
    
    [UIView animateWithDuration:jkDuration delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self->_ImgV.frame = CGRectMake(0,(ScreenHeight - self->_ImgV.image.size.height*ScreenWidth/self->_ImgV.image.size.width)/2 , ScreenWidth, self->_ImgV.image.size.height*ScreenWidth/self->_ImgV.image.size.width);
        self.alpha = 1;
        self->_Ve_from.alpha = 0;
    } completion:nil];
    
    _original = _ImgV.frame;
    
    [self handelStyleDark];
    
    return self;
}

- (void)JEShowImgShareBtnClick{
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[_ImgV.image] applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed && activityError == nil) {[JEApp.window.rootViewController showHUD:nil type:HUDMarkTypeSuccess];}
    };
    [JEApp.window.rootViewController presentViewController:activityViewController animated:YES completion:nil];
}

- (void)HideImage{
    [UIView animateWithDuration:jkDuration delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self->_ImgV.frame = self->_oldframe;
        self->_Btn_action.alpha = self->_Ve_effect.alpha = 0;
    } completion:^(BOOL finished) {
        self->_Ve_from.alpha = 1;
        [self removeFromSuperview];
    }];
}

#pragma mark - 手势操作

- (void)handlePinch:(UIPinchGestureRecognizer*)ges{
    if (ges.view.frame.size.width <= ScreenWidth && ges.scale < 1) {
        return;
    }
    if (ges.view.transform.a <= 15 || ges.scale < 1) {
        ges.view.transform = CGAffineTransformScale(ges.view.transform, ges.scale, ges.scale);
        ges.scale = 1;
    }
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateChanged){
        [UIView animateWithDuration:0.2 animations:^{
            if (ges.view.width < self->_original.size.width) {ges.view.frame = self->_original;}
            if (ges.view.x > 0 ) {ges.view.x = 0;}
            if (ges.view.right < ScreenWidth) { ges.view.right = ScreenWidth;}
            if ((ges.view.y < 0 && ges.view.height < ScreenHeight) ||(ges.view.height > ScreenHeight && ges.view.y > 0)   ) { ges.view.y = 0;}
            if ((ges.view.bottom > ScreenHeight && ges.view.height < ScreenHeight) || (ges.view.height > ScreenHeight && ges.view.bottom < ScreenHeight)) { ges.view.bottom = ScreenHeight;}
        }];
    }
}

- (void)handlePan:(UIPanGestureRecognizer*)ges{
    CGFloat A = ges.view.transform.a;
    CGPoint translation = [ges translationInView:JEApp.window];
    ges.view.center = CGPointMake(ges.view.center.x + translation.x  * (A > 10 ? (A - 10)*0.8 : 1),
                                         ges.view.center.y + translation.y  * (A > 10 ? (A - 10)*0.8 : 1));
    [ges setTranslation:CGPointZero inView:JEApp.window];
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            if (ges.view.x > 0 ) {ges.view.x = 0;}
            if (ges.view.right <= ScreenWidth) { ges.view.right = ScreenWidth;}
            if ((ges.view.y <= 0 && ges.view.height <= ScreenHeight) ||(ges.view.height >= ScreenHeight && ges.view.y >= 0)   ) { ges.view.y = 0;}
            if ((ges.view.bottom > ScreenHeight && ges.view.height < ScreenHeight) || (ges.view.height > ScreenHeight && ges.view.bottom < ScreenHeight)) { ges.view.bottom = ScreenHeight;}
        }];
    }
    
}

#pragma mark - StyleDark 黑暗模式
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self handelStyleDark];
}

- (void)handelStyleDark{
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        BOOL dark = (mode == UIUserInterfaceStyleDark);
        _Ve_effect.effect = [UIBlurEffect effectWithStyle:dark ? UIBlurEffectStyleDark : UIBlurEffectStyleExtraLight];
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

@end
