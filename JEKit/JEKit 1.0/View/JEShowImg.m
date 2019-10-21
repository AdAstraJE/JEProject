
#import "JEShowImg.h"
#import "JEKit.h"

static CGRect _oldframe;
static CGRect _original;
static UIView *_Ve_back;
static UIImageView  *_Img;

@implementation JEShowImg

+ (void)showImgFrom:(UIImageView*)view{
    [JEShowImg showImgFrom:view tureImg:nil];
}

+ (void)showImgFrom:(UIImageView*)view tureImg:(UIImage*)tureimg {
    [JEShowImg showImgFrom:view tureImg:tureimg showSave:YES];
}

+ (void)showImgFrom:(UIImageView*)fview tureImg:(UIImage*)tureimg showSave:(BOOL)save{
    _Ve_back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _Ve_back.backgroundColor = kRGBA(0, 0, 0, 0.6);
    UIImage *img = tureimg;
    if (tureimg == nil && [fview isKindOfClass:[UIImageView class]] ) {
        img = fview.image;
    }
    if (img == nil) {return;}
    
    _Img = [[UIImageView alloc]initWithFrame:(_oldframe = [fview convertRect:fview.bounds toView:JEApp.window.rootViewController.view])];
    _Img.contentMode = fview.contentMode;
    _Img.userInteractionEnabled = YES;
    _Img.image = img;
    [_Ve_back addSubview:_Img];
    [JEApp.window.rootViewController.view addSubview:_Ve_back];
    
    UITapGestureRecognizer  *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage)];
    singleTapGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [_Ve_back addGestureRecognizer: singleTapGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pinchGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    panGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [_Img addGestureRecognizer:pinchGestureRecognizer];
    [_Img addGestureRecognizer:panGestureRecognizer];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _Img.frame = CGRectMake(0,(ScreenHeight - _Img.image.size.height*ScreenWidth/_Img.image.size.width)/2 , ScreenWidth, _Img.image.size.height*ScreenWidth/_Img.image.size.width);
        _Ve_back.alpha = 1;
    } completion:nil];
    
    _original = _Img.frame;
    
    [_Ve_back addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imgLongTap:)]];
}

+ (void)imgLongTap:(UILongPressGestureRecognizer*)gesture{
    if (_Img.image == nil || gesture.state == UIGestureRecognizerStateEnded) {
        return;
    }
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[_Img.image] applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            [JEApp.window.rootViewController showHUD:nil type:HUDMarkTypeSuccess];
        }
    };
    [JEApp.window.rootViewController presentViewController:activityViewController animated:YES completion:nil];
}

+(void)hideImage{
    [UIView animateWithDuration:0.25 animations:^{
        //        _Img.frame = _oldframe;//回到原来的位置
        _Ve_back.alpha = _Img.alpha = 0;
    } completion:^(BOOL finished) {
        [_Ve_back removeFromSuperview];
        [_Img removeFromSuperview];
    }];
    
}

#pragma mark - 手势操作

+ (void)handlePinch:(UIPinchGestureRecognizer*)recognizer{
    if (recognizer.view.frame.size.width <= ScreenWidth && recognizer.scale < 1) {
        return;
    }
    if (recognizer.view.transform.a <= 15 || recognizer.scale < 1) {
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateChanged){
        [UIView animateWithDuration:0.2 animations:^{
            if (recognizer.view.width < _original.size.width) {recognizer.view.frame = _original;}
            if (recognizer.view.x > 0 ) {recognizer.view.x = 0;}
            if (recognizer.view.right < ScreenWidth) { recognizer.view.right = ScreenWidth;}
            if ((recognizer.view.y < 0 && recognizer.view.height < ScreenHeight) ||(recognizer.view.height > ScreenHeight && recognizer.view.y > 0)   ) { recognizer.view.y = 0;}
            if ((recognizer.view.bottom > ScreenHeight && recognizer.view.height < ScreenHeight) || (recognizer.view.height > ScreenHeight && recognizer.view.bottom < ScreenHeight)) { recognizer.view.bottom = ScreenHeight;}
        }];
    }
}

+ (void)handlePan:(UIPanGestureRecognizer*)recognizer{
    CGFloat A = recognizer.view.transform.a;
    CGPoint translation = [recognizer translationInView:JEApp.window];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x  * (A > 10 ? (A - 10)*0.8 : 1),
                                         recognizer.view.center.y + translation.y  * (A > 10 ? (A - 10)*0.8 : 1));
    [recognizer setTranslation:CGPointZero inView:JEApp.window];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            if (recognizer.view.x > 0 ) {recognizer.view.x = 0;}
            if (recognizer.view.right <= ScreenWidth) { recognizer.view.right = ScreenWidth;}
            if ((recognizer.view.y <= 0 && recognizer.view.height <= ScreenHeight) ||(recognizer.view.height >= ScreenHeight && recognizer.view.y >= 0)   ) { recognizer.view.y = 0;}
            if ((recognizer.view.bottom > ScreenHeight && recognizer.view.height < ScreenHeight) || (recognizer.view.height > ScreenHeight && recognizer.view.bottom < ScreenHeight)) { recognizer.view.bottom = ScreenHeight;}
        }];
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


@end
