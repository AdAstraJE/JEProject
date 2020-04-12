
#import "UIButton+JE.h"
#import "NSString+JE.h"
#import "UIImage+JE.h"
#import "UIView+JE.h"
#import "UIColor+JE.h"
#import <objc/runtime.h>

static CGFloat const jkAlpha_bg = 0.618;///< 背景时 点击高亮的透明度
static CGFloat const jkAlpha_simple = 0.3;///< 单图片、文字 或 边框 点击高亮透明度
static CGFloat const jkAlpha_disable = 0.5;///< 跟系统自动处理图片的效果一样

@implementation UIButton (JE)
@dynamic bcImg;

+ (instancetype)Frame:(CGRect)frame title:(NSString*)title font:(id)font color:(UIColor*)clr rad:(CGFloat)rad tar:(id)target sel:(SEL)action img:(id)img{
    UIButton *_ = [[self alloc] initWithFrame:frame];
    [_ setTitle:title forState:UIControlStateNormal];
    if ([font isKindOfClass:NSNumber.class]) {
        _.titleLabel.font = [UIFont systemFontOfSize:((NSNumber*)font).floatValue];
    }else if ([font isKindOfClass:UIFont.class]){
        _.titleLabel.font = font;
    }
    if (target) { [_ addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];}
    
    
    if (clr) {
        [_ je_resetTitleClr:clr];
    }else{
        if (![img isKindOfClass:UIColor.class]) {
            [_ je_resetTitleClr:UIColor.je_txt];
        }
    }

    //倒角只是背景图片的倒角
    if (rad != 0 && !([img isKindOfClass:UIColor.class] || [img isKindOfClass:NSArray.class])) {
        _.rad = rad;
    }
    
    UIImage *image;
    
    if ([img isKindOfClass:UIColor.class]) {
        [_ je_addBgImg:(UIColor *)img rad:rad];
        [_ setTitleColor:((UIColor *)img).alpha_(jkAlpha_bg) forState:UIControlStateHighlighted];
    }
    else if ([img isKindOfClass:NSArray.class]){
        image = [UIImage je_gradualColors:img size:frame.size type:ImageJEGradualType2];
        if (rad != 0) {image = [image imageByRoundCornerRadius:rad];}
        [_ setBackgroundImage:image forState:UIControlStateNormal];
        [_ setBackgroundImage:image.alpha(jkAlpha_bg) forState:UIControlStateHighlighted];
        if (clr) {[_ setTitleColor:clr.alpha_(jkAlpha_bg) forState:UIControlStateHighlighted];}
    }
    else if ([img isKindOfClass:NSString.class] || [img isKindOfClass:UIImage.class]){
        image = ([img isKindOfClass:NSString.class] ? [UIImage imageNamed:img] : img);
        if (title) {
            _.adjustsImageWhenHighlighted = NO;
            [_ je_resetImg:image];
        }else{
            [_ setImage:image forState:(UIControlStateNormal)];
        }
    }
   
    return _;
}

+ (instancetype)System:(CGRect)frame title:(NSString*)title font:(id)font color:(UIColor*)clr rad:(CGFloat)rad tar:(id)target sel:(SEL)action img:(id)img{
    UIButton *_ = [self buttonWithType:(UIButtonTypeSystem)];
    _.frame = frame;
    [_ setTitle:title forState:UIControlStateNormal];
    _.tintColor = clr;
    if ([font isKindOfClass:NSNumber.class]) {
        _.titleLabel.font = [UIFont systemFontOfSize:((NSNumber*)font).floatValue];
    }else if ([font isKindOfClass:UIFont.class]){
        _.titleLabel.font = font;
    }
    if (target) { [_ addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];}
    
    
    if (rad != 0) { _.rad = rad;}
    UIImage *image;
    if ([img isKindOfClass:NSString.class]){image = [UIImage imageNamed:img];}
    if ([img isKindOfClass:UIImage.class]) {image = img;}
    if (image) {
        [_ setImage:image forState:(UIControlStateNormal)];
    }
    
    return _;
}

- (void)setBcImg:(UIColor *)bcImg{
    [self je_addBgImg:bcImg rad:self.rad];
}

- (NSString *)text{
    return [self titleForState:UIControlStateNormal];
}

- (void)setText:(NSString *)text{
    [self setTitle:text forState:UIControlStateNormal];
}

- (void)je_addBgImg:(UIColor *)color rad:(CGFloat)rad{
    UIImage *image;
    if ([color isKindOfClass:NSArray.class]) {
        image = [UIImage je_gradualColors:(id)color size:self.size type:ImageJEGradualType2];
    }else{
        image = [UIImage je_clr:color size:self.size];
    }
    if (rad != 0) {image = [image imageByRoundCornerRadius:rad];}
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image.alpha(jkAlpha_bg) forState:UIControlStateHighlighted];
}

- (void)je_addBorderLineImg:(UIColor *)clr lineWidth:(CGFloat)width rad:(CGFloat)rad bgClr:(UIColor *)bgClr{
    UIImage *bgImg = [UIImage je_clr:bgClr size:self.size];
    bgImg = [bgImg imageByRoundCornerRadius:rad corners:UIRectCornerAllCorners borderWidth:width borderColor:clr borderLineJoin:kCGLineJoinRound];
    [self setBackgroundImage:bgImg forState:UIControlStateNormal];
    [self setBackgroundImage:bgImg.alpha(jkAlpha_simple) forState:UIControlStateHighlighted];
}

- (void)je_resetTitleClr:(UIColor *)clr{
    [self setTitleColor:clr forState:UIControlStateNormal];
    [self setTitleColor:clr.alpha_(clr.alpha*jkAlpha_disable) forState:UIControlStateDisabled];
    [self setTitleColor:clr.alpha_(clr.alpha*jkAlpha_simple) forState:UIControlStateHighlighted];
}

- (void)je_resetImg:(UIImage *)img{
    if (img) {
        [self setImage:img forState:UIControlStateNormal];
        [self setImage:img.alpha(jkAlpha_simple) forState:UIControlStateHighlighted];
    }
}

- (instancetype)sizeThatWidth{
    CGRect old = self.frame;
    old.size.width = [self sizeThatFits:CGSizeZero].width;
    self.frame = old;
    return self;
}

- (instancetype)je_paragraph:(CGFloat)para str:(NSString*)str state:(UIControlState)state{
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

- (__kindof UIButton *)click:(void (^)(__kindof UIButton *sender))block{
    objc_setAssociatedObject(self, UIButtonBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(je_btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)je_btnClick:(UIButton *)btn{
    void (^block)(__kindof UIButton *) = objc_getAssociatedObject(self, UIButtonBlockKey);
    !block ? : block(self);
}

@end
