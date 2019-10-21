
#import "UIButton+JE.h"
#import "NSString+JE.h"
#import "UIImage+JE.h"
#import "UIView+JE.h"
#import "UIColor+JE.h"
#import <objc/runtime.h>

static CGFloat const jkAbeAlpha = 0.85;///< 透明度差值百分比   系统=0.53
static CGFloat const jkAbeAlphaSystem = 0.53;///< 透明度差值百分比   系统=0.53
static CGFloat const jkWhiteAbeAlpha = 0.96;///< 白色透明度差值百分比

@implementation UIButton (JE)
@dynamic bcImg,bcImg_h;

+ (instancetype)Frame:(CGRect)frame title:(NSString*)title font:(id)font color:(UIColor*)titleColor rad:(CGFloat)rad tar:(id)target sel:(SEL)action img:(id)img{
    UIButton *_ = [[self alloc]initWithFrame:frame];
    [_ setTitle:title forState:UIControlStateNormal];
    
    if ([font isKindOfClass:[NSNumber class]]) {
        _.titleLabel.font = [UIFont systemFontOfSize:((NSNumber*)font).floatValue];
    }else if ([font isKindOfClass:[UIFont class]]){
        _.titleLabel.font = font;
    }
    
    if (titleColor == nil) {  titleColor = [UIColor whiteColor];}
    
    if (titleColor) {
        [_ setTitleColor:titleColor forState:UIControlStateNormal];
        if ([img isKindOfClass:[UIImage class]] || [img isKindOfClass:[NSString class]]) {
            [_ setTitleColor:[titleColor je_Abe:jkAbeAlphaSystem Alpha:1] forState:UIControlStateHighlighted];
        }else{
            [_ setTitleColor:[titleColor je_Abe:1 Alpha:jkAbeAlphaSystem] forState:UIControlStateHighlighted];
        }
    }
    
    if (rad != 0 && ![img isKindOfClass:[UIColor class]]) {
        _.rad = rad;
    }
    
    if (target) {
        [_ addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([img isKindOfClass:[UIColor class]]) {
        (rad != 0) ? [_ je_addBackImg:img rad:rad] : (_.bcImg = img);
    }else if ([img isKindOfClass:[NSString class]]){
        [_ setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    }else if ([img isKindOfClass:[UIImage class]]){
        [_ setImage:img forState:UIControlStateNormal];
    }else if ([img isKindOfClass:[NSArray class]]){
        [_ setBackgroundImage:[UIImage je_GradualColors:img size:frame.size type:ImageJEGradualType2] forState:UIControlStateNormal];
    }
    
    return _;
}

//默认 [self setBackgroundImage:[UIImage je_ColoreImage:color] forState:UIControlStateNormal];
- (void)setBcImg:(UIColor *)bcImg{
//    [self setBackgroundImage:[UIImage je_ColoreImage:bcImg] forState:UIControlStateNormal];
//    BOOL white = (bcImg == [UIColor whiteColor]);
//    self.bcImg_h = [bcImg je_Abe:(white ? jkWhiteAbeAlpha : 1) Alpha:(white ? 1 : jkAbeAlpha)];
    [self je_addBackImg:bcImg rad:self.rad];
}

- (void)setBcImg_h:(UIColor *)bcImg_h{
    [self setBackgroundImage:[UIImage je_ColoreImage:bcImg_h] forState:UIControlStateHighlighted];
}

- (NSString *)text{
    return [self titleForState:UIControlStateNormal];
}

- (void)setText:(NSString *)text{
    [self setTitle:text forState:UIControlStateNormal];
}

/** 添加线条倒角线框图片 */
- (void)je_addImgByRadius:(CGFloat)rad color:(UIColor *)color lineWidth:(CGFloat)width{
    [self je_addImgByRadius:rad color:color lineWidth:width bcColor:[UIColor whiteColor]];
}

- (void)je_addImgByRadius:(CGFloat)rad color:(UIColor *)color lineWidth:(CGFloat)width bcColor:(UIColor *)bcColor{
    UIImage *clearImage = [UIImage je_ColoreImage:bcColor ? : [UIColor clearColor] size:self.size];
    UIImage *normal = [clearImage addCorner:rad corners:(UIRectCornerAllCorners) borderWidth:width borderColor:color borderLineJoin:(kCGLineJoinRound)];
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    
    if (bcColor) {
        UIImage *hImage = [UIImage je_ColoreImage:[bcColor je_Abe:((bcColor == [UIColor whiteColor]) ? jkWhiteAbeAlpha : jkAbeAlpha) Alpha:jkAbeAlpha] size:self.size];
        UIImage *highlighted = [hImage addCorner:rad corners:(UIRectCornerAllCorners) borderWidth:width borderColor:[color je_Abe:1 Alpha:jkAbeAlpha] borderLineJoin:(kCGLineJoinRound)];
        [self setBackgroundImage:highlighted forState:UIControlStateHighlighted];
        if (bcColor == [UIColor whiteColor]) {
            [self setTitleColor:color forState:(UIControlStateHighlighted)];
        }
    }
    
}

/** 添加倒角纯色背景图 */
- (void)je_addBackImg:(UIColor *)color rad:(CGFloat)rad{
    UIImage *image = [UIImage je_ColoreImage:color size:self.size];
    image = [image imageByRoundCornerRadius:rad];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:[image imageWithColor:[color je_Abe:((color == [UIColor whiteColor]) ? jkWhiteAbeAlpha : jkAbeAlpha) Alpha:1]] forState:UIControlStateHighlighted];
}

/** 适应当前宽 */
- (instancetype)sizeThatWidth{
    CGRect old = self.frame;
    old.size.width = [self sizeThatFits:CGSizeZero].width;
    self.frame = old;
    return self;
}

- (instancetype)paragraph:(CGFloat)para str:(NSString*)str state:(UIControlState)state{
    if (str == nil) {
        return nil;
    }
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:para];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attribute.length)];
    [self setAttributedTitle:attribute forState:state];
    return self;
}


/** 倒计时 总秒数 按钮文本后缀 结束时的回调*/
- (void)je_countDowns:(NSInteger)timeLine suffix:(NSString *)suffix end:(void(^)(void))block{
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行一次
    
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ((self.enabled = (timeOut <= 0))) {//倒计时结束，关闭
                dispatch_source_cancel(_timer);
                if (block) {  block();}
            } else {
                [self setTitle:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%0.1d", (int)timeOut--],suffix] forState:UIControlStateNormal];
            }
        });
    });
    
    dispatch_resume(_timer);
}


static const void *UIButtonBlockKey = &UIButtonBlockKey;

- (__kindof UIButton *)click:(je_btnClickBlock)block{
    objc_setAssociatedObject(self, UIButtonBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(je_btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)je_btnClick:(UIButton *)btn{
    je_btnClickBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    !block ? : block(self);
}

@end
