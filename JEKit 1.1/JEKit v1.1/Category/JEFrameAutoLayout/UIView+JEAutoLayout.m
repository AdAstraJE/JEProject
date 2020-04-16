
//   JEAutoLayout 魔改简化版 -- 源自SDAutoLayout （2020.4.10）  from https://github.com/gsdios/SDAutoLayout

#import "UIView+JEAutoLayout.h"
#import <objc/runtime.h>
#import "UIView+JE.h"

#define __Name(...)    (__VA_ARGS__ ? @#__VA_ARGS__ : @#__VA_ARGS__)

@interface NSObject (JELOSwizzling)

@end

@implementation NSObject (JELOSwizzling)

+ (BOOL)jo_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,originalSel,class_getMethodImplementation(self, originalSel),method_getTypeEncoding(originalMethod));
    class_addMethod(self,newSel,class_getMethodImplementation(self, newSel),method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),class_getInstanceMethod(self, newSel));
    return YES;
}

@end


@interface UIView (JELOChangeFrame)

@property (nonatomic) CGFloat width_jo;
@property (nonatomic) CGFloat height_jo;

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JELayoutModItem   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation JELayoutItem

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JELayoutMod ()   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JELayoutMod ()

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

@property (nonatomic, strong) NSNumber *it_autoWidth;
@property (nonatomic, strong) NSNumber *it_autoHeight;

@property (nonatomic, assign) BOOL it_widthEqualHeight;
@property (nonatomic, assign) BOOL it_heightEqualWidth;


@end


@implementation JELayoutMod

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
        self->_me.fixedWidth = @(v);
        if (self->_it_width == nil) {self->_it_width = [[JELayoutItem alloc] init];}
        self->_it_width.value = v;
        return self;
    };
}

- (JOValue)h{
    return  ^(CGFloat v) {
        self->_me.fixedHeight = @(v);
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
        self->_it_heightEqualWidth = YES;
        self->_me.width_jo = self->_me.width_jo;
        return self;
    };
}

- (JOSet)h_lock_w{
    return ^() {
        self->_it_widthEqualHeight = YES;
        self->_me.height_jo = self->_me.height_jo;
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

- (JELayoutMod *(^)(CGFloat))offset{ return ^(CGFloat offset) {self->_it_lastItem.offset = offset;return self;};}

- (JOViewValue)lead     { return ^(UIView *view, CGFloat value) {return self.leftSameTo(view).offset(value);};}
- (JOViewValue)trall    { return ^(UIView *view, CGFloat value) {return self.rightSameTo(view).offset(-value);};}
- (JOSet)inCenterX      { return ^() {return self.centerXSameTo(self.me.superview);};}
- (JOSet)inCenterY      { return ^() {return self.centerYSameTo(self.me.superview);};}

- (JOValue)autoW        { return ^(CGFloat v) {self->_it_autoWidth = @(v);return self;};}
- (JOValue)autoH        { return ^(CGFloat v) {self->_it_autoHeight = @(v);return self;};}

@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JELOAutoHeightWidth)   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation UIView (JELOAutoHeightWidth)

- (JELayoutTool *)jo_tool{
    JELayoutTool *manager = objc_getAssociatedObject(self, _cmd);
    if (!manager) {manager = [[JELayoutTool alloc] init];
        objc_setAssociatedObject(self, _cmd, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return manager;
}

- (void)setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin{
    if (!bottomView) return;
    [self setupAutoHeightWithBottomViewsArray:@[bottomView] bottomMargin:bottomMargin];
}

- (void)setupAutoWidthWithRightView:(UIView *)rightView rightMargin:(CGFloat)rightMargin{
    if (!rightView) return;
    self.jo_rightViews = @[rightView];
    self.jo_rightViewRightMargin = rightMargin;
}

- (void)setupAutoHeightWithBottomViewsArray:(NSArray *)bottomViewsArray bottomMargin:(CGFloat)bottomMargin{
    if (!bottomViewsArray) return;
    [self.jo_bottomViews removeAllObjects];
    [self.jo_bottomViews addObjectsFromArray:bottomViewsArray];
    self.jo_bottomViewBottomMargin = bottomMargin;
}

- (void)updateLayout{
    [self.superview layoutSubviews];
}

- (NSMutableArray *)jo_bottomViews{
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        objc_setAssociatedObject(self, _cmd, [[NSMutableArray alloc] init], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (NSArray *)jo_rightViews{
    return [[self jo_tool] rightViewsArray];
}

- (void)setJo_rightViews:(NSArray *)jo_rightViews{
    [[self jo_tool] setRightViewsArray:jo_rightViews];
}

- (CGFloat)jo_bottomViewBottomMargin{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setJo_bottomViewBottomMargin:(CGFloat)jo_bottomViewBottomMargin{
    objc_setAssociatedObject(self, @selector(jo_bottomViewBottomMargin), @(jo_bottomViewBottomMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJo_rightViewRightMargin:(CGFloat)jo_rightViewRightMargin{
    [[self jo_tool] setRightViewRightMargin:jo_rightViewRightMargin];
}

- (CGFloat)jo_rightViewRightMargin{
    return [[self jo_tool] rightViewRightMargin];
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JELayoutExtention)   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation UIView (JELOExtention)

- (void (^)(CGRect))didFinishAutoLayoutBlock{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDidFinishAutoLayoutBlock:(void (^)(CGRect))didFinishAutoLayoutBlock{
    objc_setAssociatedObject(self, @selector(didFinishAutoLayoutBlock), didFinishAutoLayoutBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)fixedWidth{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedWidth:(NSNumber *)fixedWidth{
    if (fixedWidth != nil) {
        self.width_jo = [fixedWidth floatValue];
    }
    objc_setAssociatedObject(self, @selector(fixedWidth), fixedWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)fixedHeight{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedHeight:(NSNumber *)fixedHeight{
    if (fixedHeight != nil) {
        self.height_jo = [fixedHeight floatValue];
    }
    objc_setAssociatedObject(self, @selector(fixedHeight), fixedHeight, OBJC_ASSOCIATION_RETAIN);
}


- (NSNumber *)jo_rad{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJo_rad:(NSNumber *)jo_cornerRadius{
    objc_setAssociatedObject(self, @selector(jo_rad), jo_cornerRadius, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)jo_radWRate{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJo_radWRate:(NSNumber *)jo_cornerRadiusFromWidthRatio{
    objc_setAssociatedObject(self, @selector(jo_radWRate), jo_cornerRadiusFromWidthRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)jo_radHRate{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJo_radHRate:(NSNumber *)jo_cornerRadiusFromHeightRatio{
    objc_setAssociatedObject(self, @selector(jo_radHRate), jo_cornerRadiusFromHeightRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)jo_equalWidthSubviews{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJo_equalWidthSubviews:(NSArray *)jo_equalWidthSubviews{
    objc_setAssociatedObject(self, @selector(jo_equalWidthSubviews), jo_equalWidthSubviews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (SDAutoFlowItems)   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation UIView (JELOFlowItems)

- (void)setupAutoWidthFlowItems:(NSArray *)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount verticalMargin:(CGFloat)verticalMargin horizontalMargin:(CGFloat)horizontalMagin verticalEdgeInset:(CGFloat)vInset horizontalEdgeInset:(CGFloat)hInset{
    self.jo_tool.flowItems = viewsArray;
    self.jo_tool.perRowItemsCount = perRowItemsCount;
    self.jo_tool.verticalMargin = verticalMargin;
    self.jo_tool.horizontalMargin = horizontalMagin;
    self.verticalEdgeInset = vInset;
    self.horizontalEdgeInset = hInset;
    
    self.jo_tool.lastWidth = 0;
    
    if (viewsArray.count) {
        [self setupAutoHeightWithBottomView:viewsArray.lastObject bottomMargin:vInset];
    } else {
        [self.jo_bottomViews removeAllObjects];
    }
}

- (void)clearAutoWidthFlowItemsSettings{
    [self setupAutoWidthFlowItems:nil withPerRowItemsCount:0 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
}

- (void)setupAutoMarginFlowItems:(NSArray *)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount itemWidth:(CGFloat)itemWidth verticalMargin:(CGFloat)verticalMargin verticalEdgeInset:(CGFloat)vInset horizontalEdgeInset:(CGFloat)hInset{
    self.jo_tool.shouldShowAsAutoMarginViews = YES;
    self.jo_tool.flowItemWidth = itemWidth;
    [self setupAutoWidthFlowItems:viewsArray withPerRowItemsCount:perRowItemsCount verticalMargin:verticalMargin horizontalMargin:0 verticalEdgeInset:vInset horizontalEdgeInset:hInset];
}

- (void)clearAutoMarginFlowItemsSettings{
    [self setupAutoMarginFlowItems:nil withPerRowItemsCount:0 itemWidth:0 verticalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
}

- (void)setHorizontalEdgeInset:(CGFloat)horizontalEdgeInset{
    self.jo_tool.horizontalEdgeInset = horizontalEdgeInset;
}

- (CGFloat)horizontalEdgeInset{
    return self.jo_tool.horizontalEdgeInset;
}

- (void)setVerticalEdgeInset:(CGFloat)verticalEdgeInset{
    self.jo_tool.verticalEdgeInset = verticalEdgeInset;
}

- (CGFloat)verticalEdgeInset{
    return self.jo_tool.verticalEdgeInset;
}

@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIScrollView (JELOAutoContentSize)   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation UIScrollView (JELOAutoContentSize)

- (void)setupAutoContentSizeWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin{
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:bottomMargin];
}

- (void)setupAutoContentSizeWithRightView:(UIView *)rightView rightMargin:(CGFloat)rightMargin{
    if (!rightView) return;
    
    self.jo_rightViews = @[rightView];
    self.jo_rightViewRightMargin = rightMargin;
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
    // 如果程序崩溃在这行代码说明是你的label在执行“setText”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“setText”方法
    [self jelo_setText:text];
    [self updateLayout];
//    if (self.ownLayoutModel.it_autoWidth != nil) {
//        [self sizeToFit];
//    } else if (self.ownLayoutModel.it_h_rateBy_w != nil) {
//        self.size = CGSizeZero;
//    }
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
    if (self == [UIView class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self jo_swizzleInstanceMethod:@selector(layoutSubviews) with:@selector(jelo_layoutSubviews)];
        });
    }
}

#pragma mark - properties

- (NSMutableArray *)autoLayoutModelsArray{
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (JELayoutMod *)ownLayoutModel{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOwnLayoutModel:(JELayoutMod *)ownLayoutModel{
    objc_setAssociatedObject(self, @selector(ownLayoutModel), ownLayoutModel, OBJC_ASSOCIATION_RETAIN);
}

- (JELayoutMod *)jo{
    NSAssert(self.superview, @">>>>>>>>>在加入父view之后才可以做自动布局设置");
    JELayoutMod *model = [self ownLayoutModel];
    if (!model) {
        model = [[JELayoutMod alloc] init];
        model.me = self;
        [self setOwnLayoutModel:model];
        [self.superview.autoLayoutModelsArray addObject:model];
    }
    
    return model;
}

- (JELayoutMod *)jo_resetLayout{
    JELayoutMod *model = [self ownLayoutModel];
    JELayoutMod *newModel = [[JELayoutMod alloc] init];
    newModel.me = self;
    [self jo_clearViewFrameCache];
    NSInteger index = 0;
    if (model) {
        index = [self.superview.autoLayoutModelsArray indexOfObject:model];
        [self.superview.autoLayoutModelsArray replaceObjectAtIndex:index withObject:newModel];
    } else {
        [self.superview.autoLayoutModelsArray addObject:newModel];
    }
    [self setOwnLayoutModel:newModel];
    [self jo_clearExtraAutoLayoutItems];
    return newModel;
}

- (JELayoutMod *)jo_resetNewLayout{
    [self jo_clearAutoLayoutSettings];
    [self jo_clearExtraAutoLayoutItems];
    return [self jo];
}

- (BOOL)jo_closeAutoLayout{
    return self.jo_tool.jo_closeAutoLayout;
}

- (void)setJo_closeAutoLayout:(BOOL)jo_closeAutoLayout{
    self.jo_tool.jo_closeAutoLayout = jo_closeAutoLayout;
}

- (void)removeFromSuperviewAndClearAutoLayoutSettings{
    [self jo_clearAutoLayoutSettings];
    [self removeFromSuperview];
}

- (void)jo_clearAutoLayoutSettings{
    JELayoutMod *model = [self ownLayoutModel];
    if (model) {
        [self.superview.autoLayoutModelsArray removeObject:model];
        [self setOwnLayoutModel:nil];
    }
    [self jo_clearExtraAutoLayoutItems];
}

- (void)jo_clearExtraAutoLayoutItems{
    if (self.ownLayoutModel.it_h_rateBy_w != nil) {
        self.ownLayoutModel.it_h_rateBy_w = nil;
    }
    self.fixedHeight = nil;
    self.fixedWidth = nil;
}

- (void)jo_clearViewFrameCache{
    self.frame = CGRectZero;
}

- (void)jo_clearSubviewsAutoLayoutFrameCaches{
    if (self.autoLayoutModelsArray.count == 0) return;
    
    [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(JELayoutMod *model, NSUInteger idx, BOOL *stop) {
        model.me.frame = CGRectZero;
    }];
}

- (void)jelo_layoutSubviews{
    // 如果程序崩溃在这行代码说明是你的view在执行“layoutSubvies”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“layoutSubvies”方法
    [self jelo_layoutSubviews];
    
    [self jo_layoutSubviewsHandle];
}

- (void)jo_layoutSubviewsHandle{
    if (self.jo_equalWidthSubviews.count) {
        __block CGFloat totalMargin = 0;
        [self.jo_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            JELayoutMod *model = view.jo;
            CGFloat left = model.it_left ? model.it_left.value : model.me.x;
            totalMargin += (left + model.it_right.value);
        }];
        CGFloat averageWidth = (self.width_jo - totalMargin) / self.jo_equalWidthSubviews.count;
        [self.jo_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            view.width_jo = averageWidth;
            view.fixedWidth = @(averageWidth);
        }];
    }
    
    if (self.jo_tool.flowItems.count && (self.jo_tool.lastWidth != self.width_jo)) {
        
        self.jo_tool.lastWidth = self.width_jo;
        
        NSInteger perRowItemsCount = self.jo_tool.perRowItemsCount;
        CGFloat horizontalMargin = 0;
        CGFloat w = 0;
        if (self.jo_tool.shouldShowAsAutoMarginViews) {
            w = self.jo_tool.flowItemWidth;
            long itemsCount = self.jo_tool.perRowItemsCount;
            if (itemsCount > 1) {
                horizontalMargin = (self.width_jo - (self.horizontalEdgeInset * 2) - itemsCount * w) / (itemsCount - 1);
            }
        } else {
            horizontalMargin = self.jo_tool.horizontalMargin;
            w = (self.width_jo - (self.horizontalEdgeInset * 2) - (perRowItemsCount - 1) * horizontalMargin) / perRowItemsCount;
        }
        CGFloat verticalMargin = self.jo_tool.verticalMargin;
        
        __block UIView *referencedView = self;
        [self.jo_tool.flowItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if (idx < perRowItemsCount) {
                if (idx == 0) {
                    view.jo
                    .left_(referencedView, self.horizontalEdgeInset)
                    .top_(referencedView, self.verticalEdgeInset)
                    .w(w);
                } else {
                    view.jo
                    .left_(referencedView, horizontalMargin)
                    .topSameTo(referencedView)
                    .w(w);
                }
                referencedView = view;
            } else {
                referencedView = self.jo_tool.flowItems[idx - perRowItemsCount];
                view.jo
                .leftSameTo(referencedView)
                .w(w)
                .top_(referencedView, verticalMargin);
            }
        }];
    }
    
    if (self.autoLayoutModelsArray.count) {
        
        NSMutableArray *caches = nil;
        
        [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(JELayoutMod *model, NSUInteger idx, BOOL *stop) {
            if (idx < caches.count) {
                CGRect originalFrame = model.me.frame;
                CGRect newFrame = [[caches objectAtIndex:idx] CGRectValue];
                if (CGRectEqualToRect(originalFrame, newFrame)) {
                    [model.me setNeedsLayout];
                } else {
                    model.me.frame = newFrame;
                }
                [self setupCornerRadiusWithView:model.me model:model];
                model.me.jo_tool.hasSetFrameWithCache = YES;
            } else {
                if (model.me.jo_tool.hasSetFrameWithCache) {
                    model.me.jo_tool.hasSetFrameWithCache = NO;
                }
                [self jo_resizeWithModel:model];
            }
        }];
    }
    
    if (![self isKindOfClass:[UITableViewCell class]] && (self.jo_bottomViews.count || self.jo_rightViews.count)) {
        if (self.jo_tool.hasSetFrameWithCache) {
            self.jo_tool.hasSetFrameWithCache = NO;
            return;
        }
        CGFloat contentHeight = 0;
        CGFloat contentWidth = 0;
        if (self.jo_bottomViews) {
            CGFloat height = 0;
            for (UIView *view in self.jo_bottomViews) {
                height = MAX(height, view.bottom);
            }
            contentHeight = height + self.jo_bottomViewBottomMargin;
        }
        if (self.jo_rightViews) {
            CGFloat width = 0;
            for (UIView *view in self.jo_rightViews) {
                width = MAX(width, view.right);
            }
            contentWidth = width + self.jo_rightViewRightMargin;
        }
        if ([self isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self;
            CGSize contentSize = scrollView.contentSize;
            if (contentHeight > 0) {
                contentSize.height = contentHeight;
            }
            if (contentWidth > 0) {
                contentSize.width = contentWidth;
            }
            if (contentSize.width <= 0) {
                contentSize.width = scrollView.width_jo;
            }
            if (!CGSizeEqualToSize(contentSize, scrollView.contentSize)) {
                scrollView.contentSize = contentSize;
            }
        } else {
            if (self.jo_bottomViews.count && (floorf(contentHeight) != floorf(self.height_jo))) {
                self.height_jo = contentHeight;
                self.fixedHeight = @(self.height_jo);
            }
            
            if (self.jo_rightViews.count && (floorf(contentWidth) != floorf(self.width_jo))) {
                self.width_jo = contentWidth;
                self.fixedWidth = @(self.width_jo);
            }
        }
        
        JELayoutMod *model = self.ownLayoutModel;
        
        if (![self isKindOfClass:[UIScrollView class]] && self.jo_rightViews.count && (model.it_right || model.it_sameRight || model.it_centerX || model.it_sameCenterX)) {
            self.fixedWidth = @(self.width_jo);
            if (model.it_right || model.it_sameRight) {
                [self layoutRightWithView:self model:model];
            } else {
                [self layoutLeftWithView:self model:model];
            }
            self.fixedWidth = nil;
        }
        
        if (![self isKindOfClass:[UIScrollView class]] && self.jo_bottomViews.count && (model.it_bottom || model.it_sameBottom || model.it_centerY || model.it_sameCenterY)) {
            self.fixedHeight = @(self.height_jo);
            if (model.it_bottom || model.it_sameBottom) {
                [self layoutBottomWithView:self model:model];
            } else {
                [self layoutTopWithView:self model:model];
            }
            self.fixedHeight = nil;
        }
        
        if (self.didFinishAutoLayoutBlock) {
            self.didFinishAutoLayoutBlock(self.frame);
        }
    }
}

- (void)jo_resizeWithModel:(JELayoutMod *)model{
    UIView *view = model.me;
    
    if (!view || view.jo_closeAutoLayout) return;
    
    if (model.it_autoWidth != nil && (model.right_ || model.rightSameTo)) { // 靠右布局前提设置
        [self layoutAutoWidthWidthView:view model:model];
        view.fixedWidth = @(view.width_jo);
    }
    
    [self layoutWidthWithView:view model:model];
    
    [self layoutHeightWithView:view model:model];
    
    [self layoutLeftWithView:view model:model];
    
    [self layoutRightWithView:view model:model];
    
    if (model.it_h_rateBy_w && view.width_jo > 0 && (model.bottomSameTo || model.bottom_)) { // 底部布局前提设置
        [self layoutAutoHeightWidthView:view model:model];
        view.fixedHeight = @(view.height_jo);
    }
    
    if (model.it_w_rateBy_h != nil) {
        view.fixedWidth = @(view.height_jo * model.it_w_rateBy_h.floatValue);
    }
    
    
    [self layoutTopWithView:view model:model];
    
    [self layoutBottomWithView:view model:model];
    
    if ((model.it_centerX || model.it_sameCenterX) && view.fixedWidth == nil) {
        [self layoutLeftWithView:view model:model];
    }
    
    if ((model.it_centerY || model.it_sameCenterY) && view.fixedHeight == nil) {
        [self layoutTopWithView:view model:model];
    }
    
    if (model.it_autoWidth != nil) {
        [self layoutAutoWidthWidthView:view model:model];
    }
    
    if (model.it_maxWidth && [model.it_maxWidth floatValue] < view.width_jo) {
        view.width_jo = [model.it_maxWidth floatValue];
    }
    
    if (model.it_minWidth && [model.it_minWidth floatValue] > view.width_jo) {
        view.width_jo = [model.it_minWidth floatValue];
    }
    
    if ((model.it_h_rateBy_w && view.width_jo > 0) || (model.it_autoHeight != nil)) {
        [self layoutAutoHeightWidthView:view model:model];
    }
    
    if (model.it_maxHeight && [model.it_maxHeight floatValue] < view.height_jo) {
        view.height_jo = [model.it_maxHeight floatValue];
    }
    
    if (model.it_minHeight && [model.it_minHeight floatValue] > view.height_jo) {
        view.height_jo = [model.it_minHeight floatValue];
    }
    
    if (model.it_widthEqualHeight) {
        view.width_jo = view.height_jo;
    }
    
    if (model.it_heightEqualWidth) {
        view.height_jo = view.width_jo;
    }
    
    if (view.didFinishAutoLayoutBlock) {
        view.didFinishAutoLayoutBlock(view.frame);
    }
    
    if (view.jo_bottomViews.count || view.jo_rightViews.count) {
        [view layoutSubviews];
    }
    
    [self setupCornerRadiusWithView:view model:model];
}

- (void)layoutAutoHeightWidthView:(UIView *)view model:(JELayoutMod *)model{
    if (model.it_h_rateBy_w.floatValue > 0) {
        view.height_jo = view.width_jo * model.it_h_rateBy_w.floatValue;
        return;
    }
    
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        CGSize size = [label sizeThatFits:CGSizeMake(label.width, model.it_maxHeight.floatValue)];
        label.height_jo = size.height + model.it_autoHeight.floatValue;
    } else {
        view.height_jo = 0;
    }
   
}

- (void)layoutAutoWidthWidthView:(UIView *)view model:(JELayoutMod *)model{
    if ([view isKindOfClass:UILabel.class] || [view isKindOfClass:UIButton.class]) {
        CGSize size = [view sizeThatFits:CGSizeMake(model.it_maxWidth.floatValue, view.height)];
        view.width_jo = size.width + model.it_autoWidth.floatValue;
    }
}

- (void)layoutWidthWithView:(UIView *)view model:(JELayoutMod *)model{
    if (model.it_width) {
        view.width_jo = model.it_width.value;
        view.fixedWidth = @(view.width_jo);
    } else if (model.it_w_rate) {
        view.width_jo = model.it_w_rate.toView.width_jo * model.it_w_rate.value;
        view.fixedWidth = @(view.width_jo);
    }
}

- (void)layoutHeightWithView:(UIView *)view model:(JELayoutMod *)model{
    if (model.it_height) {
        view.height_jo = model.it_height.value;
        view.fixedHeight = @(view.height_jo);
    } else if (model.it_h_rate) {
        view.height_jo = model.it_h_rate.value * model.it_h_rate.toView.height_jo;
        view.fixedHeight = @(view.height_jo);
    }
}

- (void)layoutLeftWithView:(UIView *)view model:(JELayoutMod *)model{
    if (model.it_left) {
        if (view.superview == model.it_left.toView) {
            if (view.fixedWidth == nil) { // view.autoLeft && view.autoRight
                view.width_jo = view.right - model.it_left.value;
            }
            view.x = model.it_left.value;
        } else {
            if (view.fixedWidth == nil) { // view.autoLeft && view.autoRight
                view.width_jo = view.right - model.it_left.toView.right - model.it_left.value;
            }
            view.x = model.it_left.toView.right + model.it_left.value;
        }
        
    } else if (model.it_sameLeft) {
        if (view.fixedWidth == nil) {
            if (model.me == view.superview) {
                view.width_jo = view.right - (0 + model.it_sameLeft.offset);
            } else {
                view.width_jo = view.right  - (model.it_sameLeft.toView.x + model.it_sameLeft.offset);
            }
        }
        if (view.superview == model.it_sameLeft.toView) {
            view.x = 0 + model.it_sameLeft.offset;
        } else {
            view.x = model.it_sameLeft.toView.x + model.it_sameLeft.offset;
        }
    } else if (model.it_sameCenterX) {
        if (view.superview == model.it_sameCenterX.toView) {
            view.centerX = model.it_sameCenterX.toView.width_jo * 0.5 + model.it_sameCenterX.offset;
        } else {
            view.centerX = model.it_sameCenterX.toView.centerX + model.it_sameCenterX.offset;
        }
    } else if (model.it_centerX != nil) {
        view.centerX = [model.it_centerX floatValue];
    }
}

- (void)layoutRightWithView:(UIView *)view model:(JELayoutMod *)model{
    if (model.it_right) {
        if (view.superview == model.it_right.toView) {
            if (view.fixedWidth == nil) { // view.autoLeft && view.autoRight
                view.width_jo = model.it_right.toView.width_jo - view.x - model.it_right.value;
            }
            view.right = model.it_right.toView.width_jo - model.it_right.value;
        } else {
            if (view.fixedWidth == nil) { // view.autoLeft && view.autoRight
                view.width_jo =  model.it_right.toView.x - view.x - model.it_right.value;
            }
            view.right = model.it_right.toView.x - model.it_right.value;
        }
    } else if (model.it_sameRight) {
        if (view.fixedWidth == nil) {
            if (model.it_sameRight.toView == view.superview) {
                view.width_jo = model.it_sameRight.toView.width_jo - view.x + model.it_sameRight.offset;
            } else {
                view.width_jo = model.it_sameRight.toView.right - view.x + model.it_sameRight.offset;
            }
        }
        
        view.right = model.it_sameRight.toView.right + model.it_sameRight.offset;
        if (view.superview == model.it_sameRight.toView) {
            view.right = model.it_sameRight.toView.width_jo + model.it_sameRight.offset;
        }
    }
}

- (void)layoutTopWithView:(UIView *)view model:(JELayoutMod *)model{
    if (model.it_top) {
        if (view.superview == model.it_top.toView) {
            if (view.fixedHeight == nil) { // view.autoTop && view.autoBottom && view.bottom
                view.height_jo = view.bottom - model.it_top.value;
            }
            view.y = model.it_top.value;
        } else {
            if (view.fixedHeight == nil) { // view.autoTop && view.autoBottom && view.bottom
                view.height_jo = view.bottom - model.it_top.toView.bottom - model.it_top.value;
            }
            view.y = model.it_top.toView.bottom + model.it_top.value;
        }
    } else if (model.it_sameTop) {
        if (view.superview == model.it_sameTop.toView) {
            if (view.fixedHeight == nil) {
                view.height_jo = view.bottom - model.it_sameTop.offset;
            }
            view.y = 0 + model.it_sameTop.offset;
        } else {
            if (view.fixedHeight == nil) {
                view.height_jo = view.bottom - (model.it_sameTop.toView.y + model.it_sameTop.offset);
            }
            view.y = model.it_sameTop.toView.y + model.it_sameTop.offset;
        }
    } else if (model.it_sameCenterY) {
        if (view.superview == model.it_sameCenterY.toView) {
            view.centerY = model.it_sameCenterY.toView.height_jo * 0.5 + model.it_sameCenterY.offset;
        } else {
            view.centerY = model.it_sameCenterY.toView.centerY + model.it_sameCenterY.offset;
        }
    } else if (model.it_centerY != nil) {
        view.centerY = [model.it_centerY floatValue];
    }
}

- (void)layoutBottomWithView:(UIView *)view model:(JELayoutMod *)model{
    if (model.it_bottom) {
        if (view.superview == model.it_bottom.toView) {
            if (view.fixedHeight == nil) {
                view.height_jo = view.superview.height_jo - view.y - model.it_bottom.value;
            }
            view.bottom = model.it_bottom.toView.height_jo - model.it_bottom.value;
        } else {
            if (view.fixedHeight == nil) {
                view.height_jo = model.it_bottom.toView.y - view.y - model.it_bottom.value;
            }
            view.bottom = model.it_bottom.toView.y - model.it_bottom.value;
        }
        
    } else if (model.it_sameBottom) {
        if (view.superview == model.it_sameBottom.toView) {
            if (view.fixedHeight == nil) {
                view.height_jo = view.superview.height_jo - view.y + model.it_sameBottom.offset;
            }
            view.bottom = model.it_sameBottom.toView.height_jo + model.it_sameBottom.offset;
        } else {
            if (view.fixedHeight == nil) {
                view.height_jo = model.it_sameBottom.toView.bottom - view.y + model.it_sameBottom.offset;
            }
            view.bottom = model.it_sameBottom.toView.bottom + model.it_sameBottom.offset;
        }
    }
    if (model.it_widthEqualHeight && view.fixedHeight == nil) {
        [self layoutRightWithView:view model:model];
    }
}


- (void)setupCornerRadiusWithView:(UIView *)view model:(JELayoutMod *)model{
    CGFloat cornerRadius = view.layer.cornerRadius;
    CGFloat newCornerRadius = 0;
    
    if (view.jo_rad && (cornerRadius != [view.jo_rad floatValue])) {
        newCornerRadius = [view.jo_rad floatValue];
    } else if (view.jo_radWRate && (cornerRadius != [view.jo_radWRate floatValue] * view.width_jo)) {
        newCornerRadius = view.width_jo * [view.jo_radWRate floatValue];
    } else if (view.jo_radHRate && (cornerRadius != view.height_jo * [view.jo_radHRate floatValue])) {
        newCornerRadius = view.height_jo * [view.jo_radHRate floatValue];
    }
    
    if (newCornerRadius > 0) {
        view.layer.cornerRadius = newCornerRadius;
        view.clipsToBounds = YES;
    }
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JELOChangeFrame)   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation UIView (JELOChangeFrame)

- (CGFloat)width_jo {return self.frame.size.width;}

- (void)setWidth_jo:(CGFloat)width_jo {
    if (self.ownLayoutModel.it_widthEqualHeight) {if (width_jo != self.height_jo) return;}
    
    CGRect frame = self.frame;
    frame.size.width = width_jo;
    self.frame = frame;
    if (self.ownLayoutModel.it_heightEqualWidth) {
        self.height_jo = width_jo;
    }
}

- (CGFloat)height_jo {return self.frame.size.height;}

- (void)setHeight_jo:(CGFloat)height_jo {
    if (self.ownLayoutModel.it_heightEqualWidth) {if (height_jo != self.width_jo) return;}
    
    CGRect frame = self.frame;
    frame.size.height = height_jo;
    self.frame = frame;
    if (self.ownLayoutModel.it_widthEqualHeight) {
        self.width_jo = height_jo;
    }
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JELayoutTool   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation JELayoutTool

@end

