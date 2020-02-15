
#import "JEShowImg.h"
#import "JEKit.h"
#import "YYAnimatedImageView.h"
#import <PhotosUI/PhotosUI.h>

static CGFloat const jkDuration = 0.2;///<


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷    JELivePhotoView   🔷🔷🔷🔷🔷🔷🔷🔷

@interface JELivePhotoView : PHLivePhotoView
@property (nonatomic,assign) BOOL playing;///<
@end

@implementation JELivePhotoView{
    UIView *_Ve_desc;
    UIImageView *_Img_;
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
        _Ve_desc = JEVe(JR(6, 6, 115.5/2, 42/2), nil, showView).rad_(3);
        
        _Img_ = JEImg(JR(5,(_Ve_desc.height - 15.5)/2 + 0.25,16.5,15.5),nil,_Ve_desc);
        _La_desc = JELab(JR(23.5,0,_Ve_desc.width - 24,_Ve_desc.height),@"实况".loc,@14,UIColor.darkGrayColor,(0),_Ve_desc);
        
        [self handelStyleDark];
    }
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle{
    _playing = _Ve_desc.hidden = YES;
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle{
    _playing = _Ve_desc.hidden = NO;
}

#pragma mark - StyleDark 黑暗模式
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self handelStyleDark];
}

- (void)handelStyleDark{
    BOOL dark = NO;
    if (@available(iOS 13.0, *)) {dark = (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);}
    _Ve_desc.backgroundColor = dark ? kRGBA(0, 0, 0, 0.8) : kRGBA(255, 255, 255, 0.8);
    UIColor *clr = dark ? UIColor.lightGrayColor : UIColor.darkGrayColor;
    _La_desc.textColor = clr;
    _Img_.image = JEBundleImg(@"ic_livePhoto").clr(clr);
}

@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JEShowImg   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JEShowImg{
    __weak UIView *_Ve_from;
    
    CGRect _oldframe;
    CGRect _original;
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
    return [JEShowImg ShowImgFrom:view trueImg:trueImg action:YES];
}

+ (instancetype)ShowImgFrom:(UIImageView*)from trueImg:(UIImage*)trueImg action:(BOOL)action{
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
    JEShowImg *view = [[JEShowImg alloc] initWithFrame:JR(0, 0, kSW, kSH) from:nil trueImg:livePhoto action:NO].addTo(JEApp.window);
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame from:(UIImageView*)from trueImg:(UIImage*)trueImg action:(BOOL)action{
    self = [super initWithFrame:frame];
    self.alpha = 0;

    _Ve_effect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]].addTo(self);
    _Ve_effect.frame = self.bounds;
      
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideImage)];
    tapGes.delegate = (id<UIGestureRecognizerDelegate>)self;
    tapGes.delaysTouchesBegan = YES;
    [self addGestureRecognizer:tapGes];
    
    if ([trueImg isKindOfClass:PHLivePhoto.class]) {
        _photoView = [[JELivePhotoView alloc]initWithFrame:CGRectMake(0, 0,kSW,kSH)].addTo(self);
        _photoView.livePhoto = (id)trueImg;
        _photoView.contentMode = UIViewContentModeScaleAspectFit;
        [_photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleUndefined];
    }else{
        _Ve_from = from;
        _oldframe = [from convertRect:from.bounds toView:JEApp.window];
        
        _ImgV = [[YYAnimatedImageView alloc] initWithFrame:_oldframe].addTo(self);
        _ImgV.image = trueImg ? : from.image;
        
        _ImgV.contentMode = from.contentMode;
        _ImgV.userInteractionEnabled = YES;
        _ImgV.clipsToBounds  = from.clipsToBounds;
        
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
 
        _original = _ImgV.frame;
    }
    
    [UIView animateWithDuration:jkDuration delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self->_ImgV.frame = CGRectMake(0,(ScreenHeight - self->_ImgV.image.size.height*ScreenWidth/self->_ImgV.image.size.width)/2 , ScreenWidth, self->_ImgV.image.size.height*ScreenWidth/self->_ImgV.image.size.width);
        self.alpha = 1;
        self->_Ve_from.alpha = 0;
    } completion:nil];

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
    if (_photoView && _photoView.playing) { return;}
    [UIView animateWithDuration:jkDuration delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self->_ImgV.frame = self->_oldframe;
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
