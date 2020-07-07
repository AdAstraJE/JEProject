
#import "JEButton.h"
#import "JEKit.h"

static NSInteger const jkActWH = 20;///< UIActivityIndicatorView width height
static NSInteger const jkActTitleLeftMargin = 8;///<

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  JEButton  🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEButton ()

@property (nonatomic,strong) UIImageView *coverView;

@end

@implementation JEButton{
    UIColor *_normalTitleColor;///< 记录loading前按钮文字颜色
}

- (instancetype)sizeThatWidth{
    CGRect old = self.frame;
    old.size.width = [self sizeThatFits:CGSizeZero].width + _imageTitleSpace;
    self.frame = old;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    return self;
}

JEButton * JEBtn(CGRect rect,NSString *title,id fnt,UIColor *clr,id target,SEL action,id img,CGFloat rad,__kindof UIView *addTo){
    JEButton *_ = [JEButton Frame:rect title:title font:fnt color:clr rad:rad tar:target sel:action img:img];
    if ([addTo isKindOfClass:UIVisualEffectView.class]) {
        addTo = ((UIVisualEffectView *)addTo).contentView;
    }
    if (addTo) {[addTo addSubview:_];}
    return _;
}

JEButton * JEBtnSys(CGRect rect,NSString *title,id fnt,UIColor *clr,id target,SEL action,id img,CGFloat rad,__kindof UIView *addTo){
    JEButton *_ = [JEButton System:rect title:title font:fnt color:clr rad:rad tar:target sel:action img:img];
    if ([addTo isKindOfClass:UIVisualEffectView.class]) {
        addTo = ((UIVisualEffectView *)addTo).contentView;
    }
    if (addTo) {[addTo addSubview:_];}
    return _;
}

- (void)setLoc:(NSString *)loc{
    [self setTitle:loc.loc forState:UIControlStateNormal];
}

- (JEButton *(^)(CGFloat, CGFloat, CGFloat, CGFloat))touchs{
    return  ^JEButton * (CGFloat top,CGFloat left,CGFloat bottom,CGFloat right) {
        self->_moreTouchMargin = CGRectMake(left, top, right, bottom);
        return self;
    };
}

- (UIImageView *)coverView {
    if(_coverView == nil) {
        UIImageView *_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width/self.transform.a, self.height/self.transform.a)];
        _.userInteractionEnabled = YES;
        UIImage *image = [self backgroundImageForState:UIControlStateNormal];
//        if (image == nil && ([self imageForState:(UIControlStateNormal)] == nil)) {
//            image = UIImage.clr(Clr_white);
//        }
        _.image = image;
        _.bor = self.bor;
        _.borCol = self.borCol;
        [self addSubview:(_coverView = _)];
    }
    return _coverView;
}

- (UIActivityIndicatorView *)Act_{
    if (_Act_ == nil) {
        [self layoutIfNeeded];
        UIActivityIndicatorView *_ = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _.y = (self.height/self.transform.a - jkActWH)/2;
        _.color = _normalTitleColor = [self titleColorForState:UIControlStateNormal];
        _Act_ = _;
    }
    return _Act_;
}

- (void)coverLoading{
    [self startAnimatingCover:YES];
}

- (void)loading{
    [self startAnimatingCover:NO];
}

- (void)startAnimatingCover:(BOOL)cover{
    if (_Act_.isAnimating) {
        return;
    }
    [self.Act_ startAnimating];
    if (self.userInteractionEnabled) {
        self.userInteractionEnabled = _enableInLoading;
    }
    if (!_enableInLoading) {
        [self setTitleColor:_normalTitleColor.abe(1,(1 - 0.618)) forState:UIControlStateNormal];
    }
    
    if (cover) {
        [self.coverView addSubview:_Act_];
        _coverView.frame = self.bounds;
        _coverView.hidden = NO;
        _Act_.origin = CGPointMake((self.width/self.transform.a - jkActWH)/2, (self.height/self.transform.a - jkActWH)/2);
    }else{
        [self addSubview:_Act_];
        [self reloadActX];
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    if (_Act_.isAnimating && _coverView == nil) {
       [self reloadActX];
    }
    if (_edgeInsetsStyle) { [self setEdgeInsetsStyle:_edgeInsetsStyle];}
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    if (_edgeInsetsStyle != 0) { [self setEdgeInsetsStyle:_edgeInsetsStyle];}
}

- (void)reloadActX{
    [self layoutIfNeeded];
    _Act_.x = self.titleLabel.x - jkActWH - jkActTitleLeftMargin;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_Act_.isAnimating) {
        self.imageView.hidden = YES;
        _coverView ? (self.titleLabel.hidden = YES) : [self reloadActX];
    }
}

- (void)stopLoading{
    if (!_Act_.isAnimating) {
        return;
    }
    
    self.imageView.hidden = self.titleLabel.hidden = NO;
    [self setTitleColor:_normalTitleColor forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
    [_Act_ stopAnimating];
    _coverView.hidden = YES;
}

//添加边界 点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    CGRect bouds = CGRectMake(self.bounds.origin.x - _moreTouchMargin.origin.x,
                              self.bounds.origin.y - _moreTouchMargin.origin.y,
                              self.bounds.size.width + _moreTouchMargin.size.width + _moreTouchMargin.origin.x,
                              self.bounds.size.height + _moreTouchMargin.size.height + _moreTouchMargin.origin.y);
    BOOL contain = CGRectContainsPoint(bouds,point);
    return contain;
}


- (JEButton *(^)(JEBtnStyle, CGFloat))style{
    return  ^JEButton * (JEBtnStyle style,CGFloat imgGap) {
        self.imageTitleSpace = imgGap;
        self.edgeInsetsStyle = style;
        return self;
    };
}

- (void)setImageTitleSpace:(CGFloat)imageTitleSpace{
    _imageTitleSpace = imageTitleSpace;
    [self setEdgeInsetsStyle:_edgeInsetsStyle];
}

- (void)setFrame:(CGRect)frame{
    CGRect oldFrame = self.frame;
    
    [super setFrame:frame];
    if (oldFrame.size.width != frame.size.width || oldFrame.size.height != frame.size.height) {
        [self setEdgeInsetsStyle:_edgeInsetsStyle];
    }
}

- (void)setEdgeInsetsStyle:(JEBtnStyle)edgeInsetsStyle {
    [self setTitleEdgeInsets:UIEdgeInsetsZero];
    [self setImageEdgeInsets:UIEdgeInsetsZero];
    
    [self layoutIfNeeded];
    
    _edgeInsetsStyle = edgeInsetsStyle;
    CGFloat space = self.imageTitleSpace;
    CGFloat imageViewWidth = CGRectGetWidth(self.imageView.frame);
    CGFloat labelWidth = CGRectGetWidth(self.titleLabel.frame);
    
    if (labelWidth == 0) {
        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
        labelWidth  = titleSize.width;
    }
    
    CGFloat imageInsetsTop = 0.0f;
    CGFloat imageInsetsLeft = 0.0f;
    CGFloat imageInsetsBottom = 0.0f;
    CGFloat imageInsetsRight = 0.0f;
    
    CGFloat titleInsetsTop = 0.0f;
    CGFloat titleInsetsLeft = 0.0f;
    CGFloat titleInsetsBottom = 0.0f;
    CGFloat titleInsetsRight = 0.0f;
    
    switch (edgeInsetsStyle) {
        case JEBtnStyleRight: {
            space = space * 0.5;
            
            imageInsetsLeft = labelWidth + space;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = - (imageViewWidth + space);
            titleInsetsRight = -titleInsetsLeft;
            if (space == 0) {
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }
        }
            break;
            
        case JEBtnStyleLeft:{
            space = space * 0.5;
            
            imageInsetsLeft = -space;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = space;
            titleInsetsRight = -titleInsetsLeft;
            if (space == 0) {
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }
        }
            break;
        case JEBtnStyleBottom:{
            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
            CGFloat buttonHeight = CGRectGetHeight(self.frame);
            CGFloat boundsCentery = (imageHeight + space + labelHeight) * 0.5;
            
            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
            
            CGFloat imageBottomY = CGRectGetMaxY(self.imageView.frame);
            CGFloat titleTopY = CGRectGetMinY(self.titleLabel.frame);
            
            imageInsetsTop = buttonHeight - (buttonHeight * 0.5 - boundsCentery) - imageBottomY;
            imageInsetsLeft = centerX_button - centerX_image;
            imageInsetsRight = - imageInsetsLeft;
            imageInsetsBottom = - imageInsetsTop;
            
            titleInsetsTop = (buttonHeight * 0.5 - boundsCentery) - titleTopY;
            titleInsetsLeft = - (centerX_titleLabel - centerX_button);
            titleInsetsRight = - titleInsetsLeft;
            titleInsetsBottom = - titleInsetsTop;
            
        }
            break;
        case JEBtnStyleTop:{
            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
            CGFloat buttonHeight = CGRectGetHeight(self.frame);
            CGFloat boundsCentery = (imageHeight + space + labelHeight) * 0.5;
            
            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
            
            CGFloat imageTopY = CGRectGetMinY(self.imageView.frame);
            CGFloat titleBottom = CGRectGetMaxY(self.titleLabel.frame);
            
            imageInsetsTop = (buttonHeight * 0.5 - boundsCentery) - imageTopY;
            imageInsetsLeft = centerX_button - centerX_image;
            imageInsetsRight = - imageInsetsLeft;
            imageInsetsBottom = - imageInsetsTop;
            
            titleInsetsTop = buttonHeight - (buttonHeight * 0.5 - boundsCentery) - titleBottom;
            titleInsetsLeft = - (centerX_titleLabel - centerX_button);
            titleInsetsRight = - titleInsetsLeft;
            titleInsetsBottom = - titleInsetsTop;
        }
            break;
            
        default:
            break;
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageInsetsTop, imageInsetsLeft, imageInsetsBottom, imageInsetsRight);
    self.titleEdgeInsets = UIEdgeInsetsMake(titleInsetsTop, titleInsetsLeft, titleInsetsBottom, titleInsetsRight);
}

#pragma mark - StyleDark 深色模式
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    if (self.buttonType == UIButtonTypeCustom) {
        UIColor *clr = [self titleColorForState:(UIControlStateNormal)];
        [self setTitleColor:clr.alpha_(clr.alpha*0.3) forState:UIControlStateHighlighted];
    }
}

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  JEFrameBtn 完全设定图片文字位置  🔷🔷🔷🔷🔷🔷🔷🔷

@implementation JEFrameBtn

- (instancetype)initWithFrame:(CGRect)frame imgF:(CGRect)imgf titF:(CGRect)titf  title:(NSString*)title font:(id)font color:(UIColor*)titleColor rad:(CGFloat)rad tar:(id)target sel:(SEL)action img:(id)img system:(BOOL)system{
    if (system) {
        self = [[self class] System:frame title:title font:font color:titleColor rad:rad tar:target sel:action img:img];
    }else{
        self = [[self class] Frame:frame title:title font:font color:titleColor rad:rad tar:target sel:action img:img];
    }
    
    self.imgf = imgf;
    self.titf = titf;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    if (img) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeCenter UIViewContentModeScaleAspectFit
    }
    
    return self;
}


/// 设置文本和图片距离文本的水平位置 UIControlStateNormal
- (void)resetTitle:(NSString*)title imgMargin:(CGFloat)margin{
    [self setTitle:title forState:UIControlStateNormal];
    self.imgf = CGRectMake((self.width/2 + [self.currentTitle widthWithFont:self.titleLabel.font height:self.height]/2) + margin , self.imgf.origin.y, self.imgf.size.width, self.imgf.size.height);
    if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
        CGFloat titlex = [self.currentTitle widthWithFont:self.titleLabel.font height:self.height];
        self.imgf = CGRectMake((titlex > self.titf.size.width ? self.titf.size.width : titlex) + margin , self.imgf.origin.y, self.imgf.size.width, self.imgf.size.height);
    }
}

/// 覆盖父类在highlighted时的所有操作
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
}

/// 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return _imgf;
}

/// 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (!CGRectEqualToRect(_titf, CGRectZero)){
        return _titf;
    }
    return contentRect;
}

@end
