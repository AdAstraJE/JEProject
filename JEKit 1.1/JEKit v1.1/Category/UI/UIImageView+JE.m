
#import "UIImageView+JE.h"
#import "NSString+JE.h"
#import "UIView+JE.h"
#import "JEShowImg.h"
#import "UIImage+JE.h"

@implementation UIImageView (JE)

UIImageView * JEImg(CGRect rect,id img,__kindof UIView *addTo){
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    UIImage *image;
    if ([img isKindOfClass:[NSString class]]) { image = [UIImage imageNamed:img];}
    else if ([img isKindOfClass:[UIImage class]]){image = img; }
    else if ([img isKindOfClass:[UIColor class]]){image = UIImage.clr(img); }
    if (image) { imgView.image = image;}
    
    if ([addTo isKindOfClass:UIVisualEffectView.class]) {
        addTo = ((UIVisualEffectView *)addTo).contentView;
    }
    if (addTo) {  [addTo addSubview:imgView];}
    return imgView;
}

UIImageView * JEImg_(CGSize size,id img){
    return JEImg(CGRectMake(0, 0, size.width, size.height), img, nil);
}

+ (instancetype)F:(CGRect)frame name:(NSString*)name{
    return JEImg(frame, name, nil);
}

+ (instancetype)F:(CGRect)frame image:(UIImage*)image{
    return JEImg(frame, image, nil);
}

+ (instancetype)F:(CGRect)frame mode:(UIViewContentMode)mode{
    UIImageView *_ = [[self alloc]initWithFrame:frame];
    _.contentMode = mode;
    //    [_ setContentScaleFactor:[[UIScreen mainScreen] scale]];
    //    _.contentMode = UIViewContentModeScaleAspectFill;
    //    _.clipsToBounds  = YES;
    return _;
}

- (__kindof UIImageView * (^)(UIViewContentMode mode))mode_{ return ^id (NSInteger mode){self.contentMode = mode;return self;};}

/** 加个点击显示 放大图片 */
- (void)tapToshowImg{
    [self tapGesture:^(UIGestureRecognizer *ges) {
        [JEShowImg ShowImgFrom:(UIImageView*)ges.view];
    }];
}

@end
