
#import "JEShowImg.h"
#import "JEKit.h"
#import "YYAnimatedImageView.h"
#import <PhotosUI/PhotosUI.h>

static CGFloat const jkDuration = 0.2;///<

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷    YYAnimatedImageView   🔷🔷🔷🔷🔷🔷🔷🔷
@interface YYAnimatedImageView (IOS14)

@end

@implementation YYAnimatedImageView (IOS14)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method1 = class_getInstanceMethod([self class], @selector(lz_displayLayer:));
        Method method2 = class_getInstanceMethod([self class], @selector(displayLayer:));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)lz_displayLayer:(CALayer *)layer {
    Ivar ivar = class_getInstanceVariable(self.class, "_curFrame");
    UIImage *_curFrame = object_getIvar(self, ivar);
    if (_curFrame) {
        layer.contents = (__bridge id)_curFrame.CGImage;
    }else{
        if (@available(iOS 14.0, *)) {
            [super displayLayer:layer];
        }
    }
}

@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷    JELivePhotoView   🔷🔷🔷🔷🔷🔷🔷🔷

API_AVAILABLE(ios(9.1))
@interface JELivePhotoView : PHLivePhotoView
@property (nonatomic,assign) BOOL playing;///<
@end

@implementation JELivePhotoView{
    UIView *_Ve_desc;
    UIButton *_Img_;
    UILabel *_La_desc;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.delegate = (id<PHLivePhotoViewDelegate>)self;
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *showView = self.subviews.firstObject.subviews.firstObject;
    if (showView == nil) {return;}
    if (_Ve_desc == nil) {
        _Ve_desc = JEVe(JR(6, 6, 115.5/2, 42/2), [UIColor Light:kRGBA(255, 255, 255, 0.8) dark:kRGBA(0, 0, 0, 0.8)], showView).rad_(3);
        UIColor *clr = [UIColor Light:UIColor.darkGrayColor dark:UIColor.lightGrayColor];
        _Img_ = JEBtnSys(JR(5,(_Ve_desc.height - 15.5)/2 + 0.25,16.5,15.5),nil,nil,clr,nil,nil,JEBundleImg(@"ic_livePhoto"),0,_Ve_desc);
        _La_desc = JELab(JR(23.5,0,_Ve_desc.width - 24,_Ve_desc.height),@"实况".loc,@14,clr,(0),_Ve_desc);
    }
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle{
    _playing = _Ve_desc.hidden = YES;
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle{
    _playing = _Ve_desc.hidden = NO;
}

@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEShowImg   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JEShowImg{
    __weak UIView *_Ve_from;
    BOOL _dissmissed;
    CGRect _oldFrame;
    CGRect _showFrame;
    UIVisualEffectView *_Ve_effect;
    YYAnimatedImageView  *_ImgV;
    JEButton *_Btn_action;
    
    JELivePhotoView *_photoView;
}

- (void)dealloc{ jkDeallocLog}

+ (instancetype)ShowImgFrom:(UIImageView*)view{
    return [JEShowImg ShowImgFrom:view trueImg:nil];
}

+ (instancetype)ShowImgFrom:(UIImageView*)view trueImg:(UIImage*)trueImg {
    return [JEShowImg ShowImgFrom:view trueImg:trueImg action:JEShowImgActionType_share];
}

+ (instancetype)ShowImgFrom:(UIImageView*)from trueImg:(UIImage*)trueImg action:(JEShowImgActionType_)action{
    if (from.image == nil) {return nil;}
    UIImage *img = trueImg;
    if (trueImg == nil && [from isKindOfClass:[UIImageView class]] ) {
        img = from.image;
    }
    if (img == nil) {return nil;}
    JEShowImg *view = [[JEShowImg alloc] initWithFrame:JR(0, 0, kSW, kSH) from:from trueImg:trueImg action:action].addTo(JEApp.window);
    return view;
}

+ (instancetype)ShowLivePhoto:(id)livePhoto{
    JEShowImg *view = [[JEShowImg alloc] initWithFrame:JR(0, 0, kSW, kSH) from:nil trueImg:livePhoto action:JEShowImgActionType_none].addTo(JEApp.window);
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame from:(UIImageView*)from trueImg:(UIImage*)trueImg action:(JEShowImgActionType_)actionType{
    self = [super initWithFrame:frame];

    _Ve_effect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]].addTo(self);
    _Ve_effect.frame = self.bounds;
    _Ve_effect.alpha = 0;
      
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissImageTap)];
    tapGes.delegate = (id<UIGestureRecognizerDelegate>)self;
    tapGes.delaysTouchesBegan = YES;
    [self addGestureRecognizer:tapGes];
    
    if ([trueImg isKindOfClass:PHLivePhoto.class]) {
        self.alpha = 0;
        _photoView = [[JELivePhotoView alloc]initWithFrame:CGRectMake(0, 0,kSW,kSH)].addTo(self);
        _photoView.livePhoto = (id)trueImg;
        _photoView.contentMode = UIViewContentModeScaleAspectFit;
        [_photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleUndefined];
    }else{
        _Ve_from = from;
        _Ve_from.alpha = 0;
        _oldFrame = [from convertRect:from.bounds toView:JEApp.window];
        
        _ImgV = [[YYAnimatedImageView alloc] initWithFrame:_oldFrame].addTo(self);
        _ImgV.image = trueImg ? : from.image;
        _ImgV.rad = _Ve_from.rad;
        _ImgV.contentMode = from.contentMode;
        _ImgV.userInteractionEnabled = YES;
        _ImgV.clipsToBounds  = from.clipsToBounds;
        
        UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
        pinGes.delegate = (id<UIGestureRecognizerDelegate>)self;
        [_ImgV addGestureRecognizer:pinGes];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        [_ImgV addGestureRecognizer:panGestureRecognizer];
        
        if (actionType == JEShowImgActionType_share) {
            UIImage *image = JEBundleImg(@"ic_navAction");
            _Btn_action = JEBtnSys(JR(kSW - 23 - 16,ScreenStatusBarH + 9,23,26),nil,@0,JEShare.navBarItemClr ? : Clr_blue,self,@selector(JEShowImgShareBtnClick:),image,0,self).touchs(15,15,15,15);
        }
        
        if (actionType == JEShowImgActionType_delete) {
            UIImage *image = JEBundleImg(@"ic_delete");
            _Btn_action = JEBtnSys(JR(kSW - 23 - 16,ScreenStatusBarH + 9,23,26),nil,@0,JEShare.navBarItemClr ? : Clr_blue,self,@selector(JEShowImgDeleteBtnClick),image,0,self).touchs(15,15,15,15);
        }
        
    }
    
    CGFloat h = _ImgV.image.size.height/_ImgV.image.size.width*ScreenWidth;
    CGRect rect;
    if (h > kSH) {
        rect = CGRectMake(0,0, kSW, kSH);
    }else{
        rect = CGRectMake(0,(kSH - h)/2 , kSW, h);
    }
    [UIView animateWithDuration:jkDuration delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self->_ImgV.frame = rect;
        self->_showFrame = self->_ImgV.frame;
        self.alpha = 1;
        self->_Ve_effect.alpha = 1;
        self->_ImgV.rad = 0;
    } completion:nil];

    return self;
}

- (void)JEShowImgShareBtnClick:(JEButton *)sender{
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[_ImgV.image] applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed && activityError == nil) {[JEApp.window.rootViewController showHUD:nil type:HUDMarkTypeSuccess];}
    };
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.sourceView = sender;
    }
    [JEApp.window.rootViewController presentViewController:activityViewController animated:YES completion:nil];
}

- (void)JEShowImgDeleteBtnClick{
    [self dismissImageTap];
    delay(jkDuration, ^{
        !self->_deleteActionClick ?:self->_deleteActionClick((id)self->_Ve_from);
    });
}

- (void)dismissImageTap{
    if (_photoView && _photoView.playing) { return;}
    if (_dissmissed) {return;}_dissmissed = YES;
    [_ImgV stopAnimating];
    
    [UIView animateWithDuration:jkDuration delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self->_ImgV.frame = self->_oldFrame;
        self->_ImgV.rad = self->_Ve_from.rad;
        self->_Btn_action.alpha = self->_Ve_effect.alpha = 0;
        self->_photoView.alpha = 0;
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
    if (ges.view.transform.a <= 50 || ges.scale < 1) {
        ges.view.transform = CGAffineTransformScale(ges.view.transform, ges.scale, ges.scale);
        ges.scale = 1;
    }
    if (ges.view.transform.a < 1) {
        ges.view.transform = CGAffineTransformMake(1, ges.view.transform.b, ges.view.transform.c, 1, ges.view.transform.tx, ges.view.transform.ty);
    }
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateChanged){
        [UIView animateWithDuration:0.2 animations:^{
            if (ges.view.width < self->_showFrame.size.width) {ges.view.frame = self->_showFrame;}
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
    ges.view.center = CGPointMake(ges.view.center.x + translation.x  * (A > 10 ? (A - 10)*0.3 : 1),
                                         ges.view.center.y + translation.y  * (A > 10 ? (A - 10)*0.3 : 1));
    [ges setTranslation:CGPointZero inView:JEApp.window];
    
    if (ges.state == UIGestureRecognizerStateChanged && ges.view.transform.a == 1) {
        CGFloat centerY = ges.view.centerY - _showFrame.origin.y - _showFrame.size.height/2;
        if (centerY > 0) {
            CGFloat max = kSH*0.6;
            CGFloat pro = MIN(centerY, max)/max;
            _Ve_effect.alpha = 1 - pro;
        }else{
            _Ve_effect.alpha = 1;
        }
    }
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        if (self->_Ve_effect.alpha <= 0.8) {
            [self dismissImageTap];
            return;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self->_Ve_effect.alpha = 1;
            if (ges.view.x > 0 ) {ges.view.x = 0;}
            if (ges.view.right <= ScreenWidth) { ges.view.right = ScreenWidth;}
            if (ges.view.transform.a != 1) {
                if ((ges.view.y <= 0 && ges.view.height <= ScreenHeight) ||(ges.view.height >= ScreenHeight && ges.view.y >= 0)   ) {
                    ges.view.y = 0;
                }
            }else{
                if (ges.view.y != self->_showFrame.origin.y) {
                    ges.view.y = self->_showFrame.origin.y;
                }
            }
            if ((ges.view.bottom > ScreenHeight && ges.view.height < ScreenHeight) || (ges.view.height > ScreenHeight && ges.view.bottom < ScreenHeight)) { ges.view.bottom = ScreenHeight;}
        }];
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
