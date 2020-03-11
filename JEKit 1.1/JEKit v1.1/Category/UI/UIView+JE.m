
#import "UIView+JE.h"
#import "UIImageView+JE.h"
#import <objc/runtime.h>

#define SetFrame(...)   CGRect frame = self.frame; (__VA_ARGS__); self.frame = frame

@implementation UIView (JE)

UIView * JEVe(CGRect rect,UIColor *clr,__kindof UIView *addTo){
    UIView *_ = [UIView Frame:rect color:clr];
    if ([addTo isKindOfClass:UIVisualEffectView.class]) {addTo = ((UIVisualEffectView *)addTo).contentView;}
    if (addTo) { [addTo addSubview:_]; }
    return _;
}

UIVisualEffectView * JEEFVe(CGRect rect,UIBlurEffectStyle style,__kindof UIView *addTo){
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *_ = [[UIVisualEffectView alloc] initWithEffect:effect];
    _.frame = rect;
    if ([addTo isKindOfClass:UIVisualEffectView.class]) {addTo = ((UIVisualEffectView *)addTo).contentView;}
    if (addTo) { [addTo addSubview:_]; }
    return _;
}

+ (__kindof UIView *)Frame:(CGRect)frame color:(UIColor*)color{
    UIView *_ = [[self alloc]initWithFrame:frame];
    _.backgroundColor = color;
    return _;
}

+ (void)Center:(CGRect)inRect img:(__kindof UIImageView *)imgV gap:(CGFloat)gap la:(__kindof UILabel *)la in:(__kindof UIView*)inView{
    CGRect old = la.frame;
    old.size.width = [la sizeThatFits:CGSizeZero].width;
    la.frame = old;
    if (imgV) {[inView addSubview:imgV];}
    if (la) {[inView addSubview:la];}
    
    CGFloat contentW = imgV.width + la.width + gap;
    imgV.x = inRect.origin.x + (inRect.size.width - contentW)/2;
    imgV.y = inRect.origin.y + (inRect.size.height - imgV.height)/2;
    la.x = imgV.right + gap;
    la.y = inRect.origin.y;
    la.height = inRect.size.height;
}


- (__kindof UIView *)copyView{
    UIView *view = nil;
    @try {
        view = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        
    }
    return view;  
}

- (CGFloat)x{return                 CGRectGetMinX(self.frame);}
- (void)setX:(CGFloat)x{            SetFrame(frame.origin.x = x);}

- (CGFloat)y{return                 CGRectGetMinY(self.frame);}
- (void)setY:(CGFloat)y{            SetFrame(frame.origin.y = y);}

///边框宽
- (CGFloat)bor{ return self.layer.borderWidth;}
- (void)setBor:(CGFloat)bor{
    self.layer.borderWidth = bor;
}

///边框颜色
- (UIColor *)borCol{return [UIColor colorWithCGColor:self.layer.borderColor];}
- (void)setBorCol:(UIColor *)borCol{
    self.layer.borderColor = borCol.CGColor;
}

///倒角
- (CGFloat)rad{ return self.layer.cornerRadius;}
- (void)setRad:(CGFloat)rad{
    self.layer.cornerRadius = rad;
    self.layer.masksToBounds = YES;
}

///变圆 视图性能相对差一些 ，但现在的硬件情况 ,+用的view不多的基本没影响
- (BOOL)beRound{
    [self layoutIfNeeded];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.height/2;
    return YES;
}
- (void)setBeRound:(BOOL)beRound{
    [self layoutIfNeeded];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.height/2;
}

- (__kindof UIView *)makeCenter:(__kindof UIImageView *)imgV la:(__kindof UILabel *)la gap:(CGFloat)gap{
    [UIView Center:self.frame img:imgV gap:gap la:la in:nil];
    return self;
}

/// mask layer 部分倒角
- (void)je_corner:(UIRectCorner)corner rad:(CGFloat)rad{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(rad, rad)].CGPath;
    self.layer.mask = layer;
}

/// mask 为三角形
- (__kindof UIView *)je_triangle{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.width/2, 0)];
    [path addLineToPoint:CGPointMake(0, self.height)];
    [path addLineToPoint:CGPointMake(self.width, self.height)];
    [path closePath];
    layer.path = path.CGPath;
    //    layer.frame = self.bounds;
    //    layer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(rad, rad)].CGPath;
    self.layer.mask = layer;
    return self;
}

- (void)addShdow{
    [self layoutIfNeeded];
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.height - 1, self.width, 1)].CGPath;
}

- (__kindof UIView *)je_shadowRad:(CGFloat)rad edge:(CGFloat)edge clr:(UIColor *)clr{
    [self layoutIfNeeded];
    self.layer.shadowOffset = CGSizeMake(-edge, -edge);
    self.layer.shadowColor = clr ? clr.CGColor : [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.cornerRadius = rad;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, self.width + fabs(edge)*2, self.height + fabs(edge)*2) cornerRadius:rad].CGPath;
    return self;
}

- (void)removeWithClass:(Class)classV{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:classV]) {
            [view removeFromSuperview];
        }
    }
}

//调试
- (void)je_Debug:(UIColor *)color width:(CGFloat)width{
#ifdef DEBUG
    if (color == nil) {
        [self border:[UIColor colorWithRed:(arc4random()%255)/255.0f green:(arc4random()%255)/255.0f blue:(arc4random()%255)/255.0f alpha:1] width:width];
        return;
    }
    [self border:color width:width];
#endif
}

///添加边框
- (void)border:(UIColor *)color width:(CGFloat)width;{
    if (color != nil) {
        self.layer.borderColor = color.CGColor;
    }
    self.layer.borderWidth = width;
}

- (__kindof UILabel *)labelWithTag:(NSInteger)tag{
    return [self viewWithTag:tag];
}

- (__kindof UIButton *)buttonWithTag:(NSInteger)tag{
    return [self viewWithTag:tag];
}

- (__kindof UIImageView *)ImageViewWithTag:(NSInteger)tag{
    return [self viewWithTag:tag];
}

- (__kindof UITableView*)superTableView{
    return [self superView:UITableView.class];
}

- (__kindof UICollectionView *)superCollectionView{
    return [self superView:UICollectionView.class];
}

- (__kindof UIView *)superView:(Class)class{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:class]) {
            return (id)nextResponder;
        }
    }
    return nil;
}

- (__kindof UIViewController*)superVC{
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    return nil;
}

- (__kindof UIView *)find:(NSString *)className{
    for (__kindof UIView * _Nonnull obj in self.subviews) {
        if ([obj isKindOfClass:NSClassFromString(className)]) {
            return obj;
        }
        return [obj find:className];
    }
    return nil;
}

#pragma mark - 手势

static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;
static char kActionHandlerLongPressBlockKey;
static char kActionHandlerLongPressGestureKey;
static char kActionHandlerRotateBlockKey;
static char kActionHandlerRotateGestureKey;

///单点击手势
- (void)tapGesture:(void (^)(UIGestureRecognizer *ges))block{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    if (!gesture){
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateRecognized){
        void (^block)(UIGestureRecognizer *) = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
        if (block){ block(gesture); }
    }
}

///长按手势
- (void)longPressGestrue:(void (^)(UIGestureRecognizer *ges))block{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerLongPressGestureKey);
    if (!gesture)  {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        void (^block)(UIGestureRecognizer *) = objc_getAssociatedObject(self, &kActionHandlerLongPressBlockKey);
        if (block){  block(gesture);}
    }
}

///旋转手势
- (void)rotateGesture:(void (^)(UIGestureRecognizer *ges))block{
    self.userInteractionEnabled = YES;
    UIRotationGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerRotateGestureKey);
    if (!gesture){
        gesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForRotateGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerRotateGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerRotateBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForRotateGesture:(UIRotationGestureRecognizer*)gesture{
    UIView *view = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, gesture.rotation);
        [gesture setRotation:0];
        
        void (^block)(UIGestureRecognizer *) = objc_getAssociatedObject(self, &kActionHandlerRotateBlockKey);
        if (block){ block(gesture); }
    }
}



- (__kindof UIView * (^)(NSInteger tag))tag_{ return ^id (NSInteger tag){self.tag = tag;return self;};}
- (__kindof UIView * (^)(NSInteger rad))rad_{return ^id (NSInteger rad){ self.rad = rad;return self;};}
- (__kindof UIView *(^)(__kindof UIView *))addTo{
    return ^id (UIView *view){
        if ([view isKindOfClass:UIVisualEffectView.class]) {view = ((UIVisualEffectView *)view).contentView;}
        if(view){ [view addSubview:self];}
        return self;
    };
}
- (__kindof UIView *(^)(__kindof UIView *))insertTo{
    return ^id (UIView *view){
        if ([view isKindOfClass:UIVisualEffectView.class]) {view = ((UIVisualEffectView *)view).contentView;}
        if(view){ [view insertSubview:self atIndex:0];}
        return self;
    };
}

- (__kindof UIView *(^)(CGRect))jeFrame{return ^id (CGRect rect){ self.frame = rect;return self;};}

- (__kindof UIView * (^)(CGFloat x))jeX{ return ^id (CGFloat x){self.x = x;return self;};}
- (__kindof UIView * (^)(CGFloat y))jeY{ return ^id (CGFloat y){self.y = y;return self;};}
- (__kindof UIView * (^)(CGFloat w))jeW{ return ^id (CGFloat w){self.width = w;return self;};}
- (__kindof UIView * (^)(CGFloat h))jeH{ return ^id (CGFloat h){self.height = h;return self;};}

@end


