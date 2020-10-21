
//   JEAutoLayout 魔改简化版 -- 源自SDAutoLayout （2020.4.10）  from https://github.com/gsdios/SDAutoLayout

#import "UIView+JEAutoLayout.h"
#import <objc/runtime.h>
#import "UIView+JE.h"

#define __Name(...)    (__VA_ARGS__ ? @#__VA_ARGS__ : @#__VA_ARGS__)

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JELOViewFrame)   🔷🔷🔷🔷🔷🔷🔷🔷
@interface UIView (JELOViewFrame)

@property (nonatomic) CGFloat joWidth;
@property (nonatomic) CGFloat joHeight;
@property (nonatomic, strong) NSNumber * _Nullable lockWidth;
@property (nonatomic, strong) NSNumber * _Nullable lockHeight;

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JELayoutModItem   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JELayoutItem : NSObject

@property (nonatomic, weak) UIView * _Nullable toView;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat offset;

@end

@implementation JELayoutItem

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JELayoutMod ()   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JELayoutModel ()

@property (nonatomic, strong) JELayoutItem *it_width;///< item_width
@property (nonatomic, strong) JELayoutItem *it_height;
@property (nonatomic, strong) JELayoutItem *it_left;
@property (nonatomic, strong) JELayoutItem *it_top;
@property (nonatomic, strong) JELayoutItem *it_right;
@property (nonatomic, strong) JELayoutItem *it_bottom;
@property (nonatomic, strong) NSNumber *it_centerX;
@property (nonatomic, strong) NSNumber *it_centerY;

@property (nonatomic, strong) NSNumber *it_maxWidth;
@property (nonatomic, strong) NSNumber *it_maxHeight;
@property (nonatomic, strong) NSNumber *it_minWidth;
@property (nonatomic, strong) NSNumber *it_minHeight;

@property (nonatomic, strong) JELayoutItem *it_w_rate;
@property (nonatomic, strong) JELayoutItem *it_h_rate;
@property (nonatomic, strong) NSNumber *it_w_rateBy_h;
@property (nonatomic, strong) NSNumber *it_h_rateBy_w;


@property (nonatomic, strong) JELayoutItem *it_sameLeft;
@property (nonatomic, strong) JELayoutItem *it_sameRight;
@property (nonatomic, strong) JELayoutItem *it_sameTop;
@property (nonatomic, strong) JELayoutItem *it_sameBottom;
@property (nonatomic, strong) JELayoutItem *it_sameCenterX;
@property (nonatomic, strong) JELayoutItem *it_sameCenterY;
@property (nonatomic, strong) JELayoutItem *it_lastItem;

@property (nonatomic, assign) BOOL     it_subviewSameWidth;
@property (nonatomic, strong) NSNumber *it_autoWidth;
@property (nonatomic, strong) NSNumber *it_autoHeight;

@property (nonatomic, assign) BOOL it_h_lock_w;
@property (nonatomic, assign) BOOL it_w_lock_h;

@end


@implementation JELayoutModel

- (JOViewValue)left_  { return [self marginToView:__Name(_it_left)];}
- (JOViewValue)right_ { return [self marginToView:__Name(_it_right)];}
- (JOViewValue)top_   { return [self marginToView:__Name(_it_top)];}
- (JOViewValue)bottom_{ return [self marginToView:__Name(_it_bottom)];}
- (JOViewValue)marginToView:(NSString *)key{
    return ^(UIView *toView, CGFloat value) {
        JELayoutItem *item = [self valueForKey:key];
        if (item == nil) {
            item = [[JELayoutItem alloc] init];
            [self setValue:item forKey:key];
        }
        item.value = value;
        item.toView = toView;
        return self;
    };
}

- (JOValue)left         { return ^(CGFloat v) {return self.left_(self.me.superview,v);};}
- (JOValue)right        { return ^(CGFloat v) {return self.right_(self.me.superview,v);};}
- (JOValue)top          { return ^(CGFloat v) {return self.top_(self.me.superview,v);};}
- (JOValue)bottom       { return ^(CGFloat v) {return self.bottom_(self.me.superview,v);};}
- (JOValue)lr           { return ^(CGFloat v) {return self.left(v).right(v);};}
- (JOValue)tb           { return ^(CGFloat v) {return self.top(v).bottom(v);};}
- (JOValue)tb_l         { return ^(CGFloat v) {return self.tb(0).left(v);};}
- (JOValue)tb_r         { return ^(CGFloat v) {return self.tb(0).right(v);};}
- (JOEndValue)lrt0_h    { return ^(CGFloat v) {return self.lr(0).top(0).h(v).me;};}
- (JOEndValue)lrb0_h    { return ^(CGFloat v) {return self.lr(0).bottom(0).h(v).me;};}
- (JOEndValue)insets    { return ^(CGFloat v) {return self.top(v).left(v).bottom(v).right(v).me;};}
- (JO4Value)inset       { return ^(CGFloat t, CGFloat l, CGFloat b, CGFloat r) {return self.top(t).left(l).bottom(b).right(r).me;};}


- (JOValue)x            { return ^(CGFloat v) {self->_me.x = v;return self;};}
- (JOValue)y            { return ^(CGFloat v) {self->_me.y  = v;return self;};}

- (JOValue)w{
    return ^(CGFloat v) {
        self->_me.lockWidth = @(v);
        if (self->_it_width == nil) {self->_it_width = [[JELayoutItem alloc] init];}
        self->_it_width.value = v;
        return self;
    };
}

- (JOValue)h{
    return  ^(CGFloat v) {
        self->_me.lockHeight = @(v);
        if (self->_it_height == nil) {self->_it_height = [[JELayoutItem alloc] init];}
        self->_it_height.value = v;
        return self;
    };
}

- (JO2Value)wh          { return ^(CGFloat w,CGFloat h) {return self.w(w).h(h);};}

- (JOViewValue)w_rate{
    return ^(UIView *view, CGFloat value) {
        if (self->_it_w_rate == nil) {self->_it_w_rate = [[JELayoutItem alloc] init];}
        self->_it_w_rate.value = value;
        self->_it_w_rate.toView = view;
        return self;
    };
}

- (JOViewValue)h_rate{
    return ^(UIView *view, CGFloat value) {
        if (self->_it_h_rate == nil) {self->_it_h_rate = [[JELayoutItem alloc] init];}
        self->_it_h_rate.toView = view;
        self->_it_h_rate.value = value;
        return self;
    };
}

- (JOSet)w_lock_h{
    return ^() {
        self->_it_w_lock_h = YES;
        self->_me.joWidth = self->_me.joWidth;
        return self;
    };
}

- (JOSet)h_lock_w{
    return ^() {
        self->_it_h_lock_w = YES;
        self->_me.joHeight = self->_me.joHeight;
        return self;
    };
}

- (JOValue)h_rateBy_w   { return ^(CGFloat v) {self->_it_h_rateBy_w = @(v);return self;};}
- (JOValue)w_rateBy_h   { return ^(CGFloat v) {self->_it_w_rateBy_h = @(v);return self;};}
- (JOValue)maxW         { return ^(CGFloat v) {self->_it_maxWidth = @(v);return self;};}
- (JOValue)maxH         { return ^(CGFloat v) {self->_it_maxHeight = @(v);return self;};}
- (JOValue)minW         { return ^(CGFloat v) {self->_it_minWidth = @(v);return self;};}
- (JOValue)minH         { return ^(CGFloat v) {self->_it_minHeight = @(v);return self;};}
- (JOValue)centerXIs    { return ^(CGFloat v) {self->_it_centerX = @(v);return self;};}
- (JOValue)centerYIs    { return ^(CGFloat v) {self->_it_centerY = @(v);return self;};}


- (JOView)leftSameTo    { return [self marginSameToView:__Name(_it_sameLeft)];}
- (JOView)rightSameTo   { return [self marginSameToView:__Name(_it_sameRight)];}
- (JOView)topSameTo     { return [self marginSameToView:__Name(_it_sameTop)];}
- (JOView)bottomSameTo  { return [self marginSameToView:__Name(_it_sameBottom)];}
- (JOView)centerXSameTo { return [self marginSameToView:__Name(_it_sameCenterX)];}
- (JOView)centerYSameTo { return [self marginSameToView:__Name(_it_sameCenterY)];}
- (JOView)marginSameToView:(NSString *)key{
    return ^(UIView *view) {
        JELayoutItem *item = [self valueForKey:key];
        if (item == nil) {
            item = [[JELayoutItem alloc] init];
            [self setValue:item forKey:key];
        }
        item.toView = view;
        self->_it_lastItem = item;
        return self;
    };
}

- (JELayoutModel *(^)(CGFloat))offset{ return ^(CGFloat offset) {self->_it_lastItem.offset = offset;return self;};}

- (JOViewValue)lead     { return ^(UIView *view, CGFloat value) {return self.leftSameTo(view).offset(value);};}
- (JOViewValue)trall    { return ^(UIView *view, CGFloat value) {return self.rightSameTo(view).offset(-value);};}
- (JOSet)inCenterX      { return ^() {return self.centerXSameTo(self.me.superview);};}
- (JOSet)inCenterY      { return ^() {return self.centerYSameTo(self.me.superview);};}

- (JOSet)subviewSameW   { return ^() {self->_it_subviewSameWidth = YES;return self;};}

- (JOValue)autoW        { return ^(CGFloat v) {self->_it_autoWidth = @(v);return self;};}
- (JOValue)autoH        { return ^(CGFloat v) {self->_it_autoHeight = @(v);return self;};}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JELOViewFrame)   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation UIView (JELOViewFrame)

+ (BOOL)jo_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (originalMethod == nil || newMethod == nil) return NO;
    
    class_addMethod(self,originalSel,class_getMethodImplementation(self, originalSel),method_getTypeEncoding(originalMethod));
    class_addMethod(self,newSel,class_getMethodImplementation(self, newSel),method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),class_getInstanceMethod(self, newSel));
    return YES;
}

- (CGFloat)joWidth {return self.frame.size.width;}
- (void)setJoWidth:(CGFloat)width_jo {
    if (self.jo_layoutMod.it_h_lock_w) {if (width_jo != self.joHeight) return;}
    
    CGRect frame = self.frame;
    frame.size.width = width_jo;
    self.frame = frame;
    if (self.jo_layoutMod.it_w_lock_h) {
        self.joHeight = width_jo;
    }
}

- (CGFloat)joHeight {return self.frame.size.height;}
- (void)setJoHeight:(CGFloat)height_jo {
    if (self.jo_layoutMod.it_w_lock_h) {if (height_jo != self.joWidth) return;}
    
    CGRect frame = self.frame;
    frame.size.height = height_jo;
    self.frame = frame;
    if (self.jo_layoutMod.it_h_lock_w) {
        self.joWidth = height_jo;
    }
}

- (NSNumber *)lockWidth{return objc_getAssociatedObject(self, _cmd);}
- (void)setLockWidth:(NSNumber *)fixedWidth{
    if (fixedWidth != nil) {self.joWidth = [fixedWidth floatValue];}
    objc_setAssociatedObject(self, @selector(lockWidth), fixedWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)lockHeight{return objc_getAssociatedObject(self, _cmd);}
- (void)setLockHeight:(NSNumber *)fixedHeight{
    if (fixedHeight != nil) {self.joHeight = [fixedHeight floatValue];}
    objc_setAssociatedObject(self, @selector(lockHeight), fixedHeight, OBJC_ASSOCIATION_RETAIN);
}

@end

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UILabel (JELOLabel)   🔷🔷🔷🔷🔷🔷🔷🔷
@interface UILabel (JELOLabel)
@end
@implementation UILabel (JELOLabel)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jo_swizzleInstanceMethod:@selector(setText:) with:@selector(jelo_setText:)];
    });
}
- (void)jelo_setText:(NSString *)text{
    // 如果程序崩溃 检查你的“setText”方法
    [self jelo_setText:text];
    if (self.superview && self.jo_layoutMod) {
        [self updateLayout];
    }
}

@end

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIButton (JELOButton)   🔷🔷🔷🔷🔷🔷🔷🔷
@interface UIButton (JELOButton)
@end
@implementation UIButton (JELOButton)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jo_swizzleInstanceMethod:@selector(setTitle:forState:) with:@selector(jelo_setTitle:forState:)];
    });
}
- (void)jelo_setTitle:(NSString *)title forState:(UIControlState)state{
    [self jelo_setTitle:title forState:state];
    [self updateLayout];
}
@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JEAutoLayout)   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation UIView (JEAutoLayout)

+ (void)load{
    if (self == UIView.class) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self jo_swizzleInstanceMethod:@selector(layoutSubviews) with:@selector(jelo_layoutSubviews)];
        });
    }
}

#pragma mark - properties

- (void (^)(CGRect))didFinishAutoLayoutBlock{return objc_getAssociatedObject(self, _cmd);}
- (void)setDidFinishAutoLayoutBlock:(void (^)(CGRect))didFinishAutoLayoutBlock{
    objc_setAssociatedObject(self, @selector(didFinishAutoLayoutBlock), didFinishAutoLayoutBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableArray <JELayoutModel *> *)layoutMods{
    if (objc_getAssociatedObject(self, _cmd) == nil) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }return objc_getAssociatedObject(self, _cmd);
}

- (JELayoutModel *)jo_layoutMod{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJolayoutMod:(JELayoutModel *)ownLayoutModel{
    objc_setAssociatedObject(self, @selector(jo_layoutMod), ownLayoutModel, OBJC_ASSOCIATION_RETAIN);
}

- (JELayoutModel *)jo{
    NSAssert(self.superview, @">>>>>>>>>在加入父view之后才可以做自动布局设置");
    JELayoutModel *jo = [self jo_layoutMod];
    if (jo == nil) {
        jo = [[JELayoutModel alloc] init];
        jo.me = self;
        [self setJolayoutMod:jo];
        [self.superview.layoutMods addObject:jo];
    }
    return jo;
}

- (JELayoutModel *)jo_reset{
    JELayoutModel *old_jo = [self jo_layoutMod];
    JELayoutModel *new_jo = [[JELayoutModel alloc] init];
    new_jo.me = self;
    if (old_jo) {
        if ([self.superview.layoutMods containsObject:old_jo]) {
            [self.superview.layoutMods replaceObjectAtIndex:[self.superview.layoutMods indexOfObject:old_jo] withObject:new_jo];
        }else{
            [self.superview.layoutMods addObject:new_jo];
        }
    }else{
        [self.superview.layoutMods addObject:new_jo];
    }
    [self setJolayoutMod:new_jo];
    self.lockHeight = nil;
    self.lockWidth = nil;
    return new_jo;
}

- (void)updateLayout{
    [self.superview layoutSubviews];
}

#pragma mark -  🍀 jelo_layoutSubviews
- (void)jelo_layoutSubviews{
    // 如果程序崩溃在这行 检查你的“layoutSubvies”方法
    [self jelo_layoutSubviews];
    [self jo_layoutSubviewsHandle];
}

- (void)jo_layoutSubviewsHandle{
    JELayoutModel *jo = self.jo_layoutMod;
    if (jo.it_subviewSameWidth) {
        __block CGFloat totalMargin = 0;
        for (JELayoutModel *mod in self.layoutMods) {
            CGFloat left = mod.left ? mod.it_left.value : mod.me.left;
            totalMargin += (left + mod.it_right.value);
        }
        CGFloat avgWidth = (self.width - totalMargin)/((float)self.subviews.count);
        for (JELayoutModel *mod in self.layoutMods) {
            mod.me.width = avgWidth;
            mod.me.lockWidth = @(avgWidth);
        }
    }
    
    for (JELayoutModel *mod in self.layoutMods) {
        [self resizeEachModel:mod];
    }
    
    BOOL willAutoWidth = (![self isKindOfClass:UILabel.class] && ![self isKindOfClass:UIButton.class] && jo.it_autoWidth != nil);
    BOOL willAutoHeight = (![self isKindOfClass:UILabel.class] && ![self isKindOfClass:UIButton.class] && jo.it_autoHeight != nil);
    if (willAutoWidth || willAutoHeight) {
        CGFloat Awidth = 0,Aheight = 0;
        for (UIView *v in self.subviews) {Awidth = MAX(Awidth, v.right);Aheight = MAX(Aheight, v.bottom);}
      
        if ([self isKindOfClass:UIScrollView.class]) {
            UIScrollView *scr = (UIScrollView *)self;
            CGSize cz =  CGSizeMake((Awidth > 0 ? Awidth : scr.contentSize.width), (Aheight > 0 ? Aheight : scr.contentSize.height));
            if (!CGSizeEqualToSize(cz, scr.contentSize)) {
                scr.contentSize = cz;
            }
        }else{
            if (willAutoWidth) {
                self.joWidth = Awidth + jo.it_autoWidth.floatValue;
                (jo.it_right || jo.it_sameRight) ? [self layout_right:self model:jo] : [self layout_left:self model:jo];
            }
            if (willAutoHeight) {
                self.joHeight = Aheight + jo.it_autoHeight.floatValue;
                (jo.it_bottom || jo.it_sameBottom) ? [self layout_bottom:self model:jo] : [self layout_top:self model:jo];
            }
        }
        
    }
}

- (void)resizeEachModel:(JELayoutModel *)jo{
    UIView *v = jo.me;
    
    if (v == nil || jo.close) return;
    
    if (jo.it_autoWidth != nil && (jo.right_ || jo.rightSameTo)) { // 靠右布局前提设置
        [self layout_autoWidth:v model:jo];
        v.lockWidth = @(v.joWidth);
    }
    
    [self layout_width :v model:jo];
    [self layout_height:v model:jo];
    [self layout_left  :v model:jo];
    [self layout_right :v model:jo];
    
    // 底部布局前提设置
    if (jo.it_autoHeight != nil || ((jo.it_h_rateBy_w && v.joWidth > 0) && (jo.bottomSameTo || jo.bottom_))) {
        [self layout_autoHeight:v model:jo];
        v.lockHeight = @(v.joHeight);
    }
    
    if (jo.it_w_rateBy_h != nil) {
        v.lockWidth = @(v.joHeight*jo.it_w_rateBy_h.floatValue);
    }
    
    [self layout_top:v model:jo];
    [self layout_bottom:v model:jo];
    
    if ((jo.it_centerX || jo.it_sameCenterX) && v.lockWidth == nil) {
        [self layout_left:v model:jo];
    }
    if ((jo.it_centerY || jo.it_sameCenterY) && v.lockHeight == nil) {
        [self layout_top:v model:jo];
    }
    if (jo.it_autoWidth != nil) {
        [self layout_autoWidth:v model:jo];
    }
    if (jo.it_maxWidth && jo.it_maxWidth.floatValue < v.joWidth) {
        v.joWidth = jo.it_maxWidth.floatValue;
    }
    if (jo.it_minWidth && jo.it_minWidth.floatValue > v.joWidth) {
        v.joWidth = jo.it_minWidth.floatValue;
    }
    if (jo.it_maxHeight && jo.it_maxHeight.floatValue < v.joHeight) {
        v.joHeight = jo.it_maxHeight.floatValue;
    }
    if (jo.it_minHeight && jo.it_minHeight.floatValue > v.joHeight) {
        v.joHeight = jo.it_minHeight.floatValue;
    }
    if (jo.it_h_lock_w) {v.joWidth = v.joHeight;}
    if (jo.it_w_lock_h) {v.joHeight = v.joWidth;}
    if (v.didFinishAutoLayoutBlock) {v.didFinishAutoLayoutBlock(v.frame);}
}

- (void)layout_autoWidth:(UIView *)view model:(JELayoutModel *)jo{
    if ([view isKindOfClass:UILabel.class] || [view isKindOfClass:UIButton.class]) {
        CGSize size = [view sizeThatFits:CGSizeMake(jo.it_maxWidth.floatValue, view.height)];
        view.joWidth = size.width + jo.it_autoWidth.floatValue;
    }
}

- (void)layout_autoHeight:(UIView *)view model:(JELayoutModel *)jo{
    if (jo.it_h_rateBy_w.floatValue > 0) {
        view.joHeight = view.joWidth * jo.it_h_rateBy_w.floatValue;
        return;
    }
    
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        CGSize size = [label sizeThatFits:CGSizeMake(label.width, jo.it_maxHeight.floatValue)];
        label.joHeight = size.height + jo.it_autoHeight.floatValue;
    }else{
        view.joHeight = 0;
    }
}

- (void)layout_width:(UIView *)view model:(JELayoutModel *)jo{
    if (jo.it_width) {
        view.joWidth = jo.it_width.value;
        view.lockWidth = @(view.joWidth);
    } else if (jo.it_w_rate) {
        view.joWidth = jo.it_w_rate.toView.joWidth * jo.it_w_rate.value;
        view.lockWidth = @(view.joWidth);
    }
}

- (void)layout_height:(UIView *)view model:(JELayoutModel *)jo{
    if (jo.it_height) {
        view.joHeight = jo.it_height.value;
        view.lockHeight = @(view.joHeight);
    } else if (jo.it_h_rate) {
        view.joHeight = jo.it_h_rate.value * jo.it_h_rate.toView.joHeight;
        view.lockHeight = @(view.joHeight);
    }
}

- (void)layout_left:(UIView *)view model:(JELayoutModel *)jo{
    if (jo.it_left) {
        if (view.superview == jo.it_left.toView) {
            if (view.lockWidth == nil) { // view.autoLeft && view.autoRight
                view.joWidth = view.right - jo.it_left.value;
            }
            view.x = jo.it_left.value;
        } else {
            if (view.lockWidth == nil) { // view.autoLeft && view.autoRight
                view.joWidth = view.right - jo.it_left.toView.right - jo.it_left.value;
            }
            view.x = jo.it_left.toView.right + jo.it_left.value;
        }
        
    } else if (jo.it_sameLeft) {
        if (view.lockWidth == nil) {
            if (jo.me == view.superview) {
                view.joWidth = view.right - (0 + jo.it_sameLeft.offset);
            } else {
                view.joWidth = view.right  - (jo.it_sameLeft.toView.x + jo.it_sameLeft.offset);
            }
        }
        if (view.superview == jo.it_sameLeft.toView) {
            view.x = 0 + jo.it_sameLeft.offset;
        } else {
            view.x = jo.it_sameLeft.toView.x + jo.it_sameLeft.offset;
        }
    } else if (jo.it_sameCenterX) {
        if (view.superview == jo.it_sameCenterX.toView) {
            view.centerX = jo.it_sameCenterX.toView.joWidth * 0.5 + jo.it_sameCenterX.offset;
        } else {
            view.centerX = jo.it_sameCenterX.toView.centerX + jo.it_sameCenterX.offset;
        }
    } else if (jo.it_centerX != nil) {
        view.centerX = [jo.it_centerX floatValue];
    }
}

- (void)layout_right:(UIView *)view model:(JELayoutModel *)jo{
    if (jo.it_right) {
        if (view.superview == jo.it_right.toView) {
            if (view.lockWidth == nil) { // view.autoLeft && view.autoRight
                view.joWidth = jo.it_right.toView.joWidth - view.x - jo.it_right.value;
            }
            view.right = jo.it_right.toView.joWidth - jo.it_right.value;
        } else {
            if (view.lockWidth == nil) { // view.autoLeft && view.autoRight
                view.joWidth =  jo.it_right.toView.x - view.x - jo.it_right.value;
            }
            view.right = jo.it_right.toView.x - jo.it_right.value;
        }
    } else if (jo.it_sameRight) {
        if (view.lockWidth == nil) {
            if (jo.it_sameRight.toView == view.superview) {
                view.joWidth = jo.it_sameRight.toView.joWidth - view.x + jo.it_sameRight.offset;
            } else {
                view.joWidth = jo.it_sameRight.toView.right - view.x + jo.it_sameRight.offset;
            }
        }
        
        view.right = jo.it_sameRight.toView.right + jo.it_sameRight.offset;
        if (view.superview == jo.it_sameRight.toView) {
            view.right = jo.it_sameRight.toView.joWidth + jo.it_sameRight.offset;
        }
    }
}

- (void)layout_top:(UIView *)view model:(JELayoutModel *)jo{
    if (jo.it_top) {
        if (view.superview == jo.it_top.toView) {
            if (view.lockHeight == nil) { // view.autoTop && view.autoBottom && view.bottom
                view.joHeight = view.bottom - jo.it_top.value;
            }
            view.y = jo.it_top.value;
        } else {
            if (view.lockHeight == nil) { // view.autoTop && view.autoBottom && view.bottom
                view.joHeight = view.bottom - jo.it_top.toView.bottom - jo.it_top.value;
            }
            view.y = jo.it_top.toView.bottom + jo.it_top.value;
        }
    } else if (jo.it_sameTop) {
        if (view.superview == jo.it_sameTop.toView) {
            if (view.lockHeight == nil) {
                view.joHeight = view.bottom - jo.it_sameTop.offset;
            }
            view.y = 0 + jo.it_sameTop.offset;
        } else {
            if (view.lockHeight == nil) {
                view.joHeight = view.bottom - (jo.it_sameTop.toView.y + jo.it_sameTop.offset);
            }
            view.y = jo.it_sameTop.toView.y + jo.it_sameTop.offset;
        }
    } else if (jo.it_sameCenterY) {
        if (view.superview == jo.it_sameCenterY.toView) {
            view.centerY = jo.it_sameCenterY.toView.joHeight * 0.5 + jo.it_sameCenterY.offset;
        } else {
            view.centerY = jo.it_sameCenterY.toView.centerY + jo.it_sameCenterY.offset;
        }
    } else if (jo.it_centerY != nil) {
        view.centerY = [jo.it_centerY floatValue];
    }
}

- (void)layout_bottom:(UIView *)view model:(JELayoutModel *)jo{
    if (jo.it_bottom) {
        if (view.superview == jo.it_bottom.toView) {
            if (view.lockHeight == nil) {
                view.joHeight = view.superview.joHeight - view.y - jo.it_bottom.value;
            }
            view.bottom = jo.it_bottom.toView.joHeight - jo.it_bottom.value;
        } else {
            if (view.lockHeight == nil) {
                view.joHeight = jo.it_bottom.toView.y - view.y - jo.it_bottom.value;
            }
            view.bottom = jo.it_bottom.toView.y - jo.it_bottom.value;
        }
        
    } else if (jo.it_sameBottom) {
        if (view.superview == jo.it_sameBottom.toView) {
            if (view.lockHeight == nil) {
                view.joHeight = view.superview.joHeight - view.y + jo.it_sameBottom.offset;
            }
            view.bottom = jo.it_sameBottom.toView.joHeight + jo.it_sameBottom.offset;
        } else {
            if (view.lockHeight == nil) {
                view.joHeight = jo.it_sameBottom.toView.bottom - view.y + jo.it_sameBottom.offset;
            }
            view.bottom = jo.it_sameBottom.toView.bottom + jo.it_sameBottom.offset;
        }
    }
    if (jo.it_h_lock_w && view.lockHeight == nil) {
        [self layout_right:view model:jo];
    }
}

@end


