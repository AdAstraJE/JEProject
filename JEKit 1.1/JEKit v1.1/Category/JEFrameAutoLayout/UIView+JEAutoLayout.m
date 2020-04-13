
#import "UIView+JEAutoLayout.h"
#import <objc/runtime.h>

#define __Name(...)    (__VA_ARGS__ ? @#__VA_ARGS__ : @#__VA_ARGS__)

Class cellContVClass(){
    static UITableViewCell *tempCell;
    
    if (!tempCell) {
        tempCell = [UITableViewCell new];
    }
    return [tempCell.contentView class];
}

@interface NSObject (SDALSwizzling)

+ (void)sdal_exchengeMethods:(NSArray<NSString *> *)selectorStingArr prefix:(NSString *)prefix;

@end

@implementation NSObject (SDALSwizzling)

+ (void)sdal_exchengeMethods:(NSArray<NSString *> *)selectorStingArr prefix:(NSString *)prefix {
    if (!prefix) {
        prefix = @"sd_";
    }
    [selectorStingArr enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
        NSString *mySelString = [prefix stringByAppendingString:selString];
        Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
        Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
        
        const char *types = method_getTypeEncoding(originalMethod);
        if (class_addMethod(self, NSSelectorFromString(selString), method_getImplementation(myMethod), types)) {
            class_replaceMethod(self, NSSelectorFromString(mySelString), method_getImplementation(originalMethod), types);
        } else {
            method_exchangeImplementations(originalMethod, myMethod);
        }
    }];
}

@end

@interface SDAutoLayoutModel ()

@property (nonatomic, strong) SDAutoLayoutModelItem *widthItem;
@property (nonatomic, strong) SDAutoLayoutModelItem *heightItem;
@property (nonatomic, strong) SDAutoLayoutModelItem *leftItem;
@property (nonatomic, strong) SDAutoLayoutModelItem *topItem;
@property (nonatomic, strong) SDAutoLayoutModelItem *rightItem;
@property (nonatomic, strong) SDAutoLayoutModelItem *bottomItem;
@property (nonatomic, strong) NSNumber *centerX;
@property (nonatomic, strong) NSNumber *centerY;

@property (nonatomic, strong) NSNumber *maxWidth;
@property (nonatomic, strong) NSNumber *maxHeight;
@property (nonatomic, strong) NSNumber *minWidth;
@property (nonatomic, strong) NSNumber *minHeight;

@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_width;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_height;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_left;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_top;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_right;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_bottom;

@property (nonatomic, strong) SDAutoLayoutModelItem *equalLeft;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalRight;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalTop;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalBottom;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalCenterX;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalCenterY;

@property (nonatomic, strong) SDAutoLayoutModelItem *widthEqualHeight;
@property (nonatomic, strong) SDAutoLayoutModelItem *heightEqualWidth;

@property (nonatomic, strong) SDAutoLayoutModelItem *lastModelItem;

@end

@implementation SDAutoLayoutModel

@synthesize left_ = _left_;
@synthesize right_ = _right_;
@synthesize top_ = _top_;
@synthesize bottom_ = _bottom_;
@synthesize width = _width;
@synthesize height = _height;
@synthesize wRate = _wRate;
@synthesize hRate = _hRate;
@synthesize leftEqualToView = _leftEqualToView;
@synthesize rightEqualToView = _rightEqualToView;
@synthesize topTo = _topTo;
@synthesize bottomTo = _bottomTo;
@synthesize centerXTo = _centerXTo;
@synthesize centerYTo = _centerYTo;
@synthesize x = _x;
@synthesize y = _y;
@synthesize centerXIs = _centerXIs;
@synthesize centerYIs = _centerYIs;
@synthesize autoHeightRatio = _autoHeightRatio;
@synthesize autoWidthRatio = _autoWidthRatio;
@synthesize spaceToSuperView = _spaceToSuperView;
@synthesize maxWidthIs = _maxWidthIs;
@synthesize maxHeightIs = _maxHeightIs;
@synthesize minWidthIs = _minWidthIs;
@synthesize minHeightIs = _minHeightIs;
@synthesize widthEqualToHeight = _widthEqualToHeight;
@synthesize heightEqualToWidth = _heightEqualToWidth;
@synthesize offset = _offset;

- (MarginToView)left_{
    if (!_left_) {_left_ = [self marginToViewblockWithKey:__Name(_leftItem)];}
    return _left_;
}

- (MarginToView)right_{
    if (!_right_) {_right_ = [self marginToViewblockWithKey:__Name(_rightItem)];}
    return _right_;
}

- (MarginToView)top_{
    if (!_top_) {_top_ = [self marginToViewblockWithKey:__Name(_topItem)];}
    return _top_;
}

- (MarginToView)bottom_{
    if (!_bottom_) {_bottom_ = [self marginToViewblockWithKey:__Name(_bottomItem)];}
    return _bottom_;
}

- (Margin)left{
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {UIView *superView = weakSelf.me.superview;return weakSelf.left_(superView,value);};
}

- (Margin)right{
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {UIView *superView = weakSelf.me.superview;return weakSelf.right_(superView,value);};
}

- (Margin)top{
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {UIView *superView = weakSelf.me.superview;return weakSelf.top_(superView,value);};
}

- (Margin)bottom{
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {UIView *superView = weakSelf.me.superview;return weakSelf.bottom_(superView,value);};
}

- (MarginToView)marginToViewblockWithKey:(NSString *)key{
    __weak typeof(self) weakSelf = self;
    return ^(id viewOrViewsArray, CGFloat value) {
        SDAutoLayoutModelItem *item = [SDAutoLayoutModelItem new];
        item.value = @(value);
        if ([viewOrViewsArray isKindOfClass:[UIView class]]) {
            item.refView = viewOrViewsArray;
        } else if ([viewOrViewsArray isKindOfClass:[NSArray class]]) {
            item.refViewsArray = [viewOrViewsArray copy];
        }
        [weakSelf setValue:item forKey:key];
        return weakSelf;
    };
}

- (WidthHeight)width{
    if (!_width) {
        __weak typeof(self) weakSelf = self;
        _width = ^(CGFloat value) {
            weakSelf.me.fixedWidth = @(value);
            SDAutoLayoutModelItem *widthItem = [SDAutoLayoutModelItem new];
            widthItem.value = @(value);
            weakSelf.widthItem = widthItem;
            return weakSelf;
        };
    }
    return _width;
}

- (WidthHeight)height{
    if (!_height) {
        __weak typeof(self) weakSelf = self;
        _height = ^(CGFloat value) {
            weakSelf.me.fixedHeight = @(value);
            SDAutoLayoutModelItem *heightItem = [SDAutoLayoutModelItem new];
            heightItem.value = @(value);
            weakSelf.heightItem = heightItem;
            return weakSelf;
        };
    }
    return _height;
}

- (WH)WH{
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat w,CGFloat h) {
        weakSelf.width(w);
        weakSelf.height(h);
        return weakSelf;
    };
}

- (WidthHeightEqualToView)wRate{
    if (!_wRate) {
        __weak typeof(self) weakSelf = self;
        _wRate = ^(UIView *view, CGFloat value) {
            weakSelf.ratio_width = [SDAutoLayoutModelItem new];
            weakSelf.ratio_width.value = @(value);
            weakSelf.ratio_width.refView = view;
            return weakSelf;
        };
    }
    return _wRate;
}

- (WidthHeightEqualToView)hRate{
    if (!_hRate) {
        __weak typeof(self) weakSelf = self;
        _hRate = ^(UIView *view, CGFloat value) {
            weakSelf.ratio_height = [SDAutoLayoutModelItem new];
            weakSelf.ratio_height.refView = view;
            weakSelf.ratio_height.value = @(value);
            return weakSelf;
        };
    }
    return _hRate;
}

- (WidthHeight)maxWidthIs{
    if (!_maxWidthIs) {
        _maxWidthIs = [self limitingWidthHeightWithKey:@"maxWidth"];
    }
    return _maxWidthIs;
}

- (WidthHeight)maxHeightIs{
    if (!_maxHeightIs) {
        _maxHeightIs = [self limitingWidthHeightWithKey:@"maxHeight"];
    }
    return _maxHeightIs;
}

- (WidthHeight)minWidthIs{
    if (!_minWidthIs) {
        _minWidthIs = [self limitingWidthHeightWithKey:@"minWidth"];
    }
    return _minWidthIs;
}

- (WidthHeight)minHeightIs{
    if (!_minHeightIs) {
        _minHeightIs = [self limitingWidthHeightWithKey:@"minHeight"];
    }
    return _minHeightIs;
}


- (WidthHeight)limitingWidthHeightWithKey:(NSString *)key{
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {
        [weakSelf setValue:@(value) forKey:key];
        return weakSelf;
    };
}

- (MarginEqualToView)marginEqualToViewBlockWithKey:(NSString *)key{
    __weak typeof(self) weakSelf = self;
    return ^(UIView *view) {
        SDAutoLayoutModelItem *item = [SDAutoLayoutModelItem new];
        item.refView = view;
        [weakSelf setValue:item forKey:key];
        weakSelf.lastModelItem = item;
        if ([view isKindOfClass:cellContVClass()] && ([key containsString:@"equalCenterY"] || [key containsString:@"equalBottom"])) {
            view.shouldReadjustFrameBeforeStoreCache = YES;
        }
        return weakSelf;
    };
}

- (MarginEqualToView)leftEqualToView{
    if (!_leftEqualToView) {_leftEqualToView = [self marginEqualToViewBlockWithKey:__Name(_equalLeft)];}
    return _leftEqualToView;
}

- (MarginEqualToView)rightEqualToView{
    if (!_rightEqualToView) {_rightEqualToView = [self marginEqualToViewBlockWithKey:__Name(_equalRight)];}
    return _rightEqualToView;
}

- (MarginEqualToView)topTo{
    if (!_topTo) {_topTo = [self marginEqualToViewBlockWithKey:__Name(_equalTop)];}
    return _topTo;
}

- (MarginEqualToView)bottomTo{
    if (!_bottomTo) {_bottomTo = [self marginEqualToViewBlockWithKey:__Name(_equalBottom)];}
    return _bottomTo;
}

- (MarginEqualToView)centerXTo{
    if (!_centerXTo) {_centerXTo = [self marginEqualToViewBlockWithKey:__Name(_equalCenterX)];}
    return _centerXTo;
}

- (InCenter)inCenterX{
    __weak typeof(self) weakSelf = self;
    return ^() {
        self.centerXTo(weakSelf.me.superview);
        return self;
    };
}

- (InCenter)inCenterY{
    __weak typeof(self) weakSelf = self;
    return ^() {
        self.centerYTo(weakSelf.me.superview);
        return self;
    };
}

- (MarginEqualToView)centerYTo{
    if (!_centerYTo) {_centerYTo = [self marginEqualToViewBlockWithKey:__Name(_equalCenterY)];}
    return _centerYTo;
}

- (LeadTralling)lead{
    __weak typeof(self) weakSelf = self;
    return ^(UIView *view, CGFloat value) {
        weakSelf.leftEqualToView(view);weakSelf.offset(value);
        return weakSelf;
    };
}

- (LeadTralling)trall{
    __weak typeof(self) weakSelf = self;
    return ^(UIView *view, CGFloat value) {
        weakSelf.rightEqualToView(view);weakSelf.offset(-value);
        return weakSelf;
    };
}

- (Margin)marginBlockWithKey:(NSString *)key{
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat value) {
        
        if ([key isEqualToString:@"x"]) {
            weakSelf.me.left_sd = value;
        } else if ([key isEqualToString:@"y"]) {
            weakSelf.me.top_sd = value;
        } else if ([key isEqualToString:@"centerX"]) {
            weakSelf.centerX = @(value);
        } else if ([key isEqualToString:@"centerY"]) {
            weakSelf.centerY = @(value);
        }
        
        return weakSelf;
    };
}

- (Margin)x{
    if (!_x) {_x = [self marginBlockWithKey:@"x"];}
    return _x;
}

- (Margin)y
{
    if (!_y) {
        _y = [self marginBlockWithKey:@"y"];
    }
    return _y;
}

- (Margin)centerXIs
{
    if (!_centerXIs) {
        _centerXIs = [self marginBlockWithKey:@"centerX"];
    }
    return _centerXIs;
}

- (Margin)centerYIs
{
    if (!_centerYIs) {
        _centerYIs = [self marginBlockWithKey:@"centerY"];
    }
    return _centerYIs;
}

- (AutoHeightWidth)autoHeightRatio
{
    __weak typeof(self) weakSelf = self;
    
    if (!_autoHeightRatio) {
        _autoHeightRatio = ^(CGFloat ratioaValue) {
            weakSelf.me.autoHeightRatioValue = @(ratioaValue);
            return weakSelf;
        };
    }
    return _autoHeightRatio;
}

- (AutoHeightWidth)autoWidthRatio
{
    __weak typeof(self) weakSelf = self;
    
    if (!_autoWidthRatio) {
        _autoWidthRatio = ^(CGFloat ratioaValue) {
            weakSelf.me.autoWidthRatioValue = @(ratioaValue);
            return weakSelf;
        };
    }
    return _autoWidthRatio;
}

- (SpaceToSuperView)spaceToSuperView
{
    __weak typeof(self) weakSelf = self;
    
    if (!_spaceToSuperView) {
        _spaceToSuperView = ^(UIEdgeInsets insets) {
            UIView *superView = weakSelf.me.superview;
            if (superView) {
                weakSelf.me.sd_layout
                .left_(superView, insets.left)
                .top_(superView, insets.top)
                .right_(superView, insets.right)
                .bottom_(superView, insets.bottom);
            }
        };
    }
    return _spaceToSuperView;
}

- (SameWidthHeight)widthEqualToHeight{
    __weak typeof(self) weakSelf = self;
    
    if (!_widthEqualToHeight) {
        _widthEqualToHeight = ^() {
            weakSelf.widthEqualHeight = [SDAutoLayoutModelItem new];
            weakSelf.lastModelItem = weakSelf.widthEqualHeight;
            // 主动触发一次赋值操作
            weakSelf.me.height_sd = weakSelf.me.height_sd;
            return weakSelf;
        };
    }
    return _widthEqualToHeight;
}

- (SameWidthHeight)heightEqualToWidth{
    __weak typeof(self) weakSelf = self;
    
    if (!_heightEqualToWidth) {
        _heightEqualToWidth = ^() {
            weakSelf.heightEqualWidth = [SDAutoLayoutModelItem new];
            weakSelf.lastModelItem = weakSelf.heightEqualWidth;
            // 主动触发一次赋值操作
            weakSelf.me.width_sd = weakSelf.me.width_sd;
            return weakSelf;
        };
    }
    return _heightEqualToWidth;
}

- (SDAutoLayoutModel *(^)(CGFloat))offset
{
    __weak typeof(self) weakSelf = self;
    if (!_offset) {
        _offset = ^(CGFloat offset) {
            weakSelf.lastModelItem.offset = offset;
            return weakSelf;
        };
    }
    return _offset;
}

- (__kindof UIView * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))inset{
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
        self.spaceToSuperView(UIEdgeInsetsMake(top, left, bottom, right));
        return weakSelf.me;
    };
}

- (__kindof UIView *)bounds{
    self.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    return _me;
}

@end


@implementation UIView (SDAutoHeightWidth)

- (SDUIViewCategoryManager *)sd_categoryManager
{
    SDUIViewCategoryManager *manager = objc_getAssociatedObject(self, _cmd);
    if (!manager) {
        objc_setAssociatedObject(self, _cmd, [SDUIViewCategoryManager new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin
{
    if (!bottomView) return;
    
    [self setupAutoHeightWithBottomViewsArray:@[bottomView] bottomMargin:bottomMargin];
}

- (void)setupAutoWidthWithRightView:(UIView *)rightView rightMargin:(CGFloat)rightMargin
{
    if (!rightView) return;
    
    self.sd_rightViewsArray = @[rightView];
    self.sd_rightViewRightMargin = rightMargin;
}

- (void)setupAutoHeightWithBottomViewsArray:(NSArray *)bottomViewsArray bottomMargin:(CGFloat)bottomMargin
{
    if (!bottomViewsArray) return;
    
    // 清空之前的view
    [self.sd_bottomViewsArray removeAllObjects];
    [self.sd_bottomViewsArray addObjectsFromArray:bottomViewsArray];
    self.sd_bottomViewBottomMargin = bottomMargin;
}

- (void)clearAutoHeigtSettings
{
    [self.sd_bottomViewsArray removeAllObjects];
}

- (void)clearAutoWidthSettings
{
    self.sd_rightViewsArray = nil;
}

- (void)updateLayout
{
    [self.superview layoutSubviews];
}

- (void)updateLayoutWithCellContentView:(UIView *)cellContentView
{
    if (cellContentView.sd_indexPath) {
        [cellContentView sd_clearSubviewsAutoLayoutFrameCaches];
    }
    [self updateLayout];
}

- (CGFloat)autoHeight
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setAutoHeight:(CGFloat)autoHeight
{
    objc_setAssociatedObject(self, @selector(autoHeight), @(autoHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)sd_bottomViewsArray
{
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (NSArray *)sd_rightViewsArray
{
    return [[self sd_categoryManager] rightViewsArray];
}

- (void)setSd_rightViewsArray:(NSArray *)sd_rightViewsArray
{
    [[self sd_categoryManager] setRightViewsArray:sd_rightViewsArray];
}

- (CGFloat)sd_bottomViewBottomMargin
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSd_bottomViewBottomMargin:(CGFloat)sd_bottomViewBottomMargin
{
    objc_setAssociatedObject(self, @selector(sd_bottomViewBottomMargin), @(sd_bottomViewBottomMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSd_rightViewRightMargin:(CGFloat)sd_rightViewRightMargin
{
    [[self sd_categoryManager] setRightViewRightMargin:sd_rightViewRightMargin];
}

- (CGFloat)sd_rightViewRightMargin
{
    return [[self sd_categoryManager] rightViewRightMargin];
}

@end

@implementation UIView (SDLayoutExtention)

- (void (^)(CGRect))didFinishAutoLayoutBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDidFinishAutoLayoutBlock:(void (^)(CGRect))didFinishAutoLayoutBlock
{
    objc_setAssociatedObject(self, @selector(didFinishAutoLayoutBlock), didFinishAutoLayoutBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)sd_cornerRadius
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadius:(NSNumber *)sd_cornerRadius
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadius), sd_cornerRadius, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)sd_cornerRadiusFromWidthRatio
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadiusFromWidthRatio:(NSNumber *)sd_cornerRadiusFromWidthRatio
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadiusFromWidthRatio), sd_cornerRadiusFromWidthRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)sd_cornerRadiusFromHeightRatio
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadiusFromHeightRatio:(NSNumber *)sd_cornerRadiusFromHeightRatio
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadiusFromHeightRatio), sd_cornerRadiusFromHeightRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)sd_equalWidthSubviews
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_equalWidthSubviews:(NSArray *)sd_equalWidthSubviews
{
    objc_setAssociatedObject(self, @selector(sd_equalWidthSubviews), sd_equalWidthSubviews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sd_addSubviews:(NSArray *)subviews
{
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[UIView class]]) {
            [self addSubview:view];
        }
    }];
}

@end

@implementation UIView (SDAutoFlowItems)

- (void)setupAutoWidthFlowItems:(NSArray *)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount verticalMargin:(CGFloat)verticalMargin horizontalMargin:(CGFloat)horizontalMagin verticalEdgeInset:(CGFloat)vInset horizontalEdgeInset:(CGFloat)hInset
{
    self.sd_categoryManager.flowItems = viewsArray;
    self.sd_categoryManager.perRowItemsCount = perRowItemsCount;
    self.sd_categoryManager.verticalMargin = verticalMargin;
    self.sd_categoryManager.horizontalMargin = horizontalMagin;
    self.verticalEdgeInset = vInset;
    self.horizontalEdgeInset = hInset;
    
    self.sd_categoryManager.lastWidth = 0;
    
    if (viewsArray.count) {
        [self setupAutoHeightWithBottomView:viewsArray.lastObject bottomMargin:vInset];
    } else {
        [self clearAutoHeigtSettings];
    }
}

- (void)clearAutoWidthFlowItemsSettings
{
    [self setupAutoWidthFlowItems:nil withPerRowItemsCount:0 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
}

- (void)setupAutoMarginFlowItems:(NSArray *)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount itemWidth:(CGFloat)itemWidth verticalMargin:(CGFloat)verticalMargin verticalEdgeInset:(CGFloat)vInset horizontalEdgeInset:(CGFloat)hInset
{
    self.sd_categoryManager.shouldShowAsAutoMarginViews = YES;
    self.sd_categoryManager.flowItemWidth = itemWidth;
    [self setupAutoWidthFlowItems:viewsArray withPerRowItemsCount:perRowItemsCount verticalMargin:verticalMargin horizontalMargin:0 verticalEdgeInset:vInset horizontalEdgeInset:hInset];
}

- (void)clearAutoMarginFlowItemsSettings
{
    [self setupAutoMarginFlowItems:nil withPerRowItemsCount:0 itemWidth:0 verticalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
}

- (void)setHorizontalEdgeInset:(CGFloat)horizontalEdgeInset
{
    self.sd_categoryManager.horizontalEdgeInset = horizontalEdgeInset;
}

- (CGFloat)horizontalEdgeInset
{
    return self.sd_categoryManager.horizontalEdgeInset;
}

- (void)setVerticalEdgeInset:(CGFloat)verticalEdgeInset
{
    self.sd_categoryManager.verticalEdgeInset = verticalEdgeInset;
}

- (CGFloat)verticalEdgeInset
{
    return self.sd_categoryManager.verticalEdgeInset;
}

@end

@implementation UIScrollView (SDAutoContentSize)

- (void)setupAutoContentSizeWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin
{
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:bottomMargin];
}

- (void)setupAutoContentSizeWithRightView:(UIView *)rightView rightMargin:(CGFloat)rightMargin
{
    if (!rightView) return;
    
    self.sd_rightViewsArray = @[rightView];
    self.sd_rightViewRightMargin = rightMargin;
}

@end

@implementation UILabel (SDLabelAutoResize)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sdal_exchengeMethods:@[@"setText:"] prefix:nil];
    });
}

- (void)sd_setText:(NSString *)text
{
    // 如果程序崩溃在这行代码说明是你的label在执行“setText”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“setText”方法
    [self sd_setText:text];
    
    
    if (self.sd_maxWidth) {
        [self sizeToFit];
    } else if (self.autoHeightRatioValue) {
        self.size_sd = CGSizeZero;
    }
}

- (BOOL)isAttributedContent
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsAttributedContent:(BOOL)isAttributedContent
{
    objc_setAssociatedObject(self, @selector(isAttributedContent), @(isAttributedContent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSingleLineAutoResizeWithMaxWidth:(CGFloat)maxWidth
{
    self.sd_maxWidth = @(maxWidth);
}

- (void)setMaxNumberOfLinesToShow:(NSInteger)lineCount
{
    NSAssert(self.ownLayoutModel, @"请在布局完成之后再做此步设置！");
    if (lineCount > 0) {
        if (self.isAttributedContent) {
            NSDictionary *attrs = [self.attributedText attributesAtIndex:0 effectiveRange:nil];
            NSMutableParagraphStyle *paragraphStyle = attrs[NSParagraphStyleAttributeName];
            self.sd_layout.maxHeightIs((self.font.lineHeight) * lineCount + paragraphStyle.lineSpacing * (lineCount - 1) + 0.1);
        } else {
            self.sd_layout.maxHeightIs(self.font.lineHeight * lineCount + 0.1);
        }
    } else {
        self.sd_layout.maxHeightIs(MAXFLOAT);
    }
}

@end



@implementation SDAutoLayoutModelItem

- (instancetype)init
{
    if (self = [super init]) {
        _offset = 0;
    }
    return self;
}

@end


@implementation UIView (JEAutoLayout)

+ (void)load
{
    if (self == [UIView class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self sdal_exchengeMethods:@[@"layoutSubviews"] prefix:nil];
        });
    }
}

#pragma mark - properties

- (NSMutableArray *)autoLayoutModelsArray
{
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (NSNumber *)fixedWidth
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedWidth:(NSNumber *)fixedWidth
{
    if (fixedWidth) {
        self.width_sd = [fixedWidth floatValue];
    }
    objc_setAssociatedObject(self, @selector(fixedWidth), fixedWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)fixedHeight
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedHeight:(NSNumber *)fixedHeight
{
    if (fixedHeight) {
        self.height_sd = [fixedHeight floatValue];
    }
    objc_setAssociatedObject(self, @selector(fixedHeight), fixedHeight, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)autoHeightRatioValue
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAutoHeightRatioValue:(NSNumber *)autoHeightRatioValue
{
    objc_setAssociatedObject(self, @selector(autoHeightRatioValue), autoHeightRatioValue, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)autoWidthRatioValue
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAutoWidthRatioValue:(NSNumber *)autoWidthRatioValue
{
    objc_setAssociatedObject(self, @selector(autoWidthRatioValue), autoWidthRatioValue, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)sd_maxWidth
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_maxWidth:(NSNumber *)sd_maxWidth
{
    objc_setAssociatedObject(self, @selector(sd_maxWidth), sd_maxWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)useCellFrameCacheWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableview
{
    self.sd_indexPath = indexPath;
    self.sd_tableView = tableview;
}

- (UITableView *)sd_tableView
{
    return self.sd_categoryManager.sd_tableView;
}

- (void)setSd_tableView:(UITableView *)sd_tableView
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        [(UITableViewCell *)self contentView].sd_tableView = sd_tableView;
    }
    self.sd_categoryManager.sd_tableView = sd_tableView;
}

- (NSIndexPath *)sd_indexPath
{
    return self.sd_categoryManager.sd_indexPath;
}

- (void)setSd_indexPath:(NSIndexPath *)sd_indexPath
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        [(UITableViewCell *)self contentView].sd_indexPath = sd_indexPath;
    }
    self.sd_categoryManager.sd_indexPath = sd_indexPath;
}

- (SDAutoLayoutModel *)ownLayoutModel
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOwnLayoutModel:(SDAutoLayoutModel *)ownLayoutModel
{
    objc_setAssociatedObject(self, @selector(ownLayoutModel), ownLayoutModel, OBJC_ASSOCIATION_RETAIN);
}

- (SDAutoLayoutModel *)jo{return self.sd_layout;}
- (SDAutoLayoutModel *)sd_layout{
    NSAssert(self.superview, @">>>>>>>>>在加入父view之后才可以做自动布局设置");
    SDAutoLayoutModel *model = [self ownLayoutModel];
    if (!model) {
        model = [SDAutoLayoutModel new];
        model.me = self;
        [self setOwnLayoutModel:model];
        [self.superview.autoLayoutModelsArray addObject:model];
    }
    
    return model;
}

- (SDAutoLayoutModel *)sd_resetLayout
{
    /*
     * 方案待定
     [self sd_clearAutoLayoutSettings];
     return [self sd_layout];
     */
    
    SDAutoLayoutModel *model = [self ownLayoutModel];
    SDAutoLayoutModel *newModel = [SDAutoLayoutModel new];
    newModel.me = self;
    [self sd_clearViewFrameCache];
    NSInteger index = 0;
    if (model) {
        index = [self.superview.autoLayoutModelsArray indexOfObject:model];
        [self.superview.autoLayoutModelsArray replaceObjectAtIndex:index withObject:newModel];
    } else {
        [self.superview.autoLayoutModelsArray addObject:newModel];
    }
    [self setOwnLayoutModel:newModel];
    [self sd_clearExtraAutoLayoutItems];
    return newModel;
}

- (SDAutoLayoutModel *)sd_resetNewLayout
{
    [self sd_clearAutoLayoutSettings];
    [self sd_clearExtraAutoLayoutItems];
    return [self sd_layout];
}

- (BOOL)sd_isClosingAutoLayout
{
    return self.sd_categoryManager.sd_isClosingAutoLayout;
}

- (void)setSd_closeAutoLayout:(BOOL)sd_closeAutoLayout
{
    self.sd_categoryManager.sd_closeAutoLayout = sd_closeAutoLayout;
}

- (void)removeFromSuperviewAndClearAutoLayoutSettings
{
    [self sd_clearAutoLayoutSettings];
    [self removeFromSuperview];
}

- (void)sd_clearAutoLayoutSettings
{
    SDAutoLayoutModel *model = [self ownLayoutModel];
    if (model) {
        [self.superview.autoLayoutModelsArray removeObject:model];
        [self setOwnLayoutModel:nil];
    }
    [self sd_clearExtraAutoLayoutItems];
}

- (void)sd_clearExtraAutoLayoutItems
{
    if (self.autoHeightRatioValue) {
        self.autoHeightRatioValue = nil;
    }
    self.fixedHeight = nil;
    self.fixedWidth = nil;
}

- (void)sd_clearViewFrameCache
{
    self.frame = CGRectZero;
}

- (void)sd_clearSubviewsAutoLayoutFrameCaches
{
    if (self.autoLayoutModelsArray.count == 0) return;
    
    [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(SDAutoLayoutModel *model, NSUInteger idx, BOOL *stop) {
        model.me.frame = CGRectZero;
    }];
}

- (void)sd_layoutSubviews
{
    // 如果程序崩溃在这行代码说明是你的view在执行“layoutSubvies”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“layoutSubvies”方法
    [self sd_layoutSubviews];
    
    [self sd_layoutSubviewsHandle];
}

- (void)sd_layoutSubviewsHandle{

    if (self.sd_equalWidthSubviews.count) {
        __block CGFloat totalMargin = 0;
        [self.sd_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            SDAutoLayoutModel *model = view.sd_layout;
            CGFloat left = model.leftItem ? [model.leftItem.value floatValue] : model.me.left_sd;
            totalMargin += (left + [model.rightItem.value floatValue]);
        }];
        CGFloat averageWidth = (self.width_sd - totalMargin) / self.sd_equalWidthSubviews.count;
        [self.sd_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            view.width_sd = averageWidth;
            view.fixedWidth = @(averageWidth);
        }];
    }
    
    if (self.sd_categoryManager.flowItems.count && (self.sd_categoryManager.lastWidth != self.width_sd)) {
        
        self.sd_categoryManager.lastWidth = self.width_sd;
        
        NSInteger perRowItemsCount = self.sd_categoryManager.perRowItemsCount;
        CGFloat horizontalMargin = 0;
        CGFloat w = 0;
        if (self.sd_categoryManager.shouldShowAsAutoMarginViews) {
            w = self.sd_categoryManager.flowItemWidth;
            long itemsCount = self.sd_categoryManager.perRowItemsCount;
            if (itemsCount > 1) {
                horizontalMargin = (self.width_sd - (self.horizontalEdgeInset * 2) - itemsCount * w) / (itemsCount - 1);
            }
        } else {
            horizontalMargin = self.sd_categoryManager.horizontalMargin;
            w = (self.width_sd - (self.horizontalEdgeInset * 2) - (perRowItemsCount - 1) * horizontalMargin) / perRowItemsCount;
        }
        CGFloat verticalMargin = self.sd_categoryManager.verticalMargin;
        
        __block UIView *referencedView = self;
        [self.sd_categoryManager.flowItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if (idx < perRowItemsCount) {
                if (idx == 0) {
                    /* 保留
                    BOOL shouldShowAsAutoMarginViews = self.sd_categoryManager.shouldShowAsAutoMarginViews;
                     */
                    view.sd_layout
                    .left_(referencedView, self.horizontalEdgeInset)
                    .top_(referencedView, self.verticalEdgeInset)
                    .width(w);
                } else {
                    view.sd_layout
                    .left_(referencedView, horizontalMargin)
                    .topTo(referencedView)
                    .width(w);
                }
                referencedView = view;
            } else {
                referencedView = self.sd_categoryManager.flowItems[idx - perRowItemsCount];
                view.sd_layout
                .leftEqualToView(referencedView)
                .width(w)
                .top_(referencedView, verticalMargin);
            }
        }];
    }
    
    if (self.autoLayoutModelsArray.count) {
        
        NSMutableArray *caches = nil;
        
        [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(SDAutoLayoutModel *model, NSUInteger idx, BOOL *stop) {
            if (idx < caches.count) {
                CGRect originalFrame = model.me.frame;
                CGRect newFrame = [[caches objectAtIndex:idx] CGRectValue];
                if (CGRectEqualToRect(originalFrame, newFrame)) {
                    [model.me setNeedsLayout];
                } else {
                    model.me.frame = newFrame;
                }
                [self setupCornerRadiusWithView:model.me model:model];
                model.me.sd_categoryManager.hasSetFrameWithCache = YES;
            } else {
                if (model.me.sd_categoryManager.hasSetFrameWithCache) {
                    model.me.sd_categoryManager.hasSetFrameWithCache = NO;
                }
                [self sd_resizeWithModel:model];
            }
        }];
    }
    
    if (![self isKindOfClass:[UITableViewCell class]] && (self.sd_bottomViewsArray.count || self.sd_rightViewsArray.count)) {
        if (self.sd_categoryManager.hasSetFrameWithCache) {
            self.sd_categoryManager.hasSetFrameWithCache = NO;
            return;
        }
        CGFloat contentHeight = 0;
        CGFloat contentWidth = 0;
        if (self.sd_bottomViewsArray) {
            CGFloat height = 0;
            for (UIView *view in self.sd_bottomViewsArray) {
                height = MAX(height, view.bottom_sd);
            }
            contentHeight = height + self.sd_bottomViewBottomMargin;
        }
        if (self.sd_rightViewsArray) {
            CGFloat width = 0;
            for (UIView *view in self.sd_rightViewsArray) {
                width = MAX(width, view.right_sd);
            }
            contentWidth = width + self.sd_rightViewRightMargin;
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
                contentSize.width = scrollView.width_sd;
            }
            if (!CGSizeEqualToSize(contentSize, scrollView.contentSize)) {
                scrollView.contentSize = contentSize;
            }
        } else {
            if (self.sd_bottomViewsArray.count && (floorf(contentHeight) != floorf(self.height_sd))) {
                self.height_sd = contentHeight;
                self.fixedHeight = @(self.height_sd);
            }
            
            if (self.sd_rightViewsArray.count && (floorf(contentWidth) != floorf(self.width_sd))) {
                self.width_sd = contentWidth;
                self.fixedWidth = @(self.width_sd);
            }
        }
        
        SDAutoLayoutModel *model = self.ownLayoutModel;
        
        if (![self isKindOfClass:[UIScrollView class]] && self.sd_rightViewsArray.count && (model.rightItem || model.equalRight || model.centerX || model.equalCenterX)) {
            self.fixedWidth = @(self.width_sd);
            if (model.rightItem || model.equalRight) {
                [self layoutRightWithView:self model:model];
            } else {
                [self layoutLeftWithView:self model:model];
            }
            self.fixedWidth = nil;
        }
        
        if (![self isKindOfClass:[UIScrollView class]] && self.sd_bottomViewsArray.count && (model.bottomItem || model.equalBottom || model.centerY || model.equalCenterY)) {
            self.fixedHeight = @(self.height_sd);
            if (model.bottomItem || model.equalBottom) {
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

- (void)sd_resizeWithModel:(SDAutoLayoutModel *)model
{
    UIView *view = model.me;
    
    if (!view || view.sd_isClosingAutoLayout) return;
    
    if (view.sd_maxWidth && (model.right_ || model.rightEqualToView)) { // 靠右布局前提设置
        [self layoutAutoWidthWidthView:view model:model];
        view.fixedWidth = @(view.width_sd);
    }
    
    [self layoutWidthWithView:view model:model];
    
    [self layoutHeightWithView:view model:model];
    
    [self layoutLeftWithView:view model:model];
    
    [self layoutRightWithView:view model:model];
    
    if (view.autoHeightRatioValue && view.width_sd > 0 && (model.bottomTo || model.bottom_)) { // 底部布局前提设置
        [self layoutAutoHeightWidthView:view model:model];
        view.fixedHeight = @(view.height_sd);
    }
    
    if (view.autoWidthRatioValue) {
        view.fixedWidth = @(view.height_sd * [view.autoWidthRatioValue floatValue]);
    }
    
    
    [self layoutTopWithView:view model:model];
    
    [self layoutBottomWithView:view model:model];
    
    if ((model.centerX || model.equalCenterX) && !view.fixedWidth) {
        [self layoutLeftWithView:view model:model];
    }
    
    if ((model.centerY || model.equalCenterY) && !view.fixedHeight) {
        [self layoutTopWithView:view model:model];
    }
    
    if (view.sd_maxWidth) {
        [self layoutAutoWidthWidthView:view model:model];
    }
    
    if (model.maxWidth && [model.maxWidth floatValue] < view.width_sd) {
        view.width_sd = [model.maxWidth floatValue];
    }
    
    if (model.minWidth && [model.minWidth floatValue] > view.width_sd) {
        view.width_sd = [model.minWidth floatValue];
    }
    
    if (view.autoHeightRatioValue && view.width_sd > 0) {
        [self layoutAutoHeightWidthView:view model:model];
    }
    
    if (model.maxHeight && [model.maxHeight floatValue] < view.height_sd) {
        view.height_sd = [model.maxHeight floatValue];
    }
    
    if (model.minHeight && [model.minHeight floatValue] > view.height_sd) {
        view.height_sd = [model.minHeight floatValue];
    }
    
    if (model.widthEqualHeight) {
        view.width_sd = view.height_sd;
    }
    
    if (model.heightEqualWidth) {
        view.height_sd = view.width_sd;
    }
    
    if (view.didFinishAutoLayoutBlock) {
        view.didFinishAutoLayoutBlock(view.frame);
    }
    
    if (view.sd_bottomViewsArray.count || view.sd_rightViewsArray.count) {
        [view layoutSubviews];
    }
    
    [self setupCornerRadiusWithView:view model:model];
}

- (void)layoutAutoHeightWidthView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if ([view.autoHeightRatioValue floatValue] > 0) {
        view.height_sd = view.width_sd * [view.autoHeightRatioValue floatValue];
    } else {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.numberOfLines = 0;
            if (label.text.length) {
                if (!label.isAttributedContent) {
                    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(label.width_sd, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                    label.height_sd = rect.size.height + 0.1;
                } else {
                    [label sizeToFit];
                    if (label.sd_maxWidth && label.width_sd > [label.sd_maxWidth floatValue]) {
                        label.width_sd = [label.sd_maxWidth floatValue];
                    }
                }
            } else {
                label.height_sd = 0;
            }
        } else {
            view.height_sd = 0;
        }
    }
}

- (void)layoutAutoWidthWidthView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        CGFloat width = [view.sd_maxWidth floatValue] > 0 ? [view.sd_maxWidth floatValue] : MAXFLOAT;
        label.numberOfLines = 1;
        if (label.text.length) {
            if (!label.isAttributedContent) {
                CGRect rect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.height_sd) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                if (rect.size.width > width) {
                    rect.size.width = width;
                }
                label.width_sd = rect.size.width + 0.1;
            } else{
                [label sizeToFit];
                if (label.width_sd > width) {
                    label.width_sd = width;
                }
            }
        } else {
            label.size_sd = CGSizeZero;
        }
    }
}

- (void)layoutWidthWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.widthItem) {
        view.width_sd = [model.widthItem.value floatValue];
        view.fixedWidth = @(view.width_sd);
    } else if (model.ratio_width) {
        view.width_sd = model.ratio_width.refView.width_sd * [model.ratio_width.value floatValue];
        view.fixedWidth = @(view.width_sd);
    }
}

- (void)layoutHeightWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.heightItem) {
        view.height_sd = [model.heightItem.value floatValue];
        view.fixedHeight = @(view.height_sd);
    } else if (model.ratio_height) {
        view.height_sd = [model.ratio_height.value floatValue] * model.ratio_height.refView.height_sd;
        view.fixedHeight = @(view.height_sd);
    }
}

- (void)layoutLeftWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.leftItem) {
        if (view.superview == model.leftItem.refView) {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd = view.right_sd - [model.leftItem.value floatValue];
            }
            view.left_sd = [model.leftItem.value floatValue];
        } else {
            if (model.leftItem.refViewsArray.count) {
                CGFloat lastRefRight = 0;
                for (UIView *ref in model.leftItem.refViewsArray) {
                    if ([ref isKindOfClass:[UIView class]] && ref.right_sd > lastRefRight) {
                        model.leftItem.refView = ref;
                        lastRefRight = ref.right_sd;
                    }
                }
            }
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd = view.right_sd - model.leftItem.refView.right_sd - [model.leftItem.value floatValue];
            }
            view.left_sd = model.leftItem.refView.right_sd + [model.leftItem.value floatValue];
        }
        
    } else if (model.equalLeft) {
        if (!view.fixedWidth) {
            if (model.me == view.superview) {
                view.width_sd = view.right_sd - (0 + model.equalLeft.offset);
            } else {
                view.width_sd = view.right_sd  - (model.equalLeft.refView.left_sd + model.equalLeft.offset);
            }
        }
        if (view.superview == model.equalLeft.refView) {
            view.left_sd = 0 + model.equalLeft.offset;
        } else {
            view.left_sd = model.equalLeft.refView.left_sd + model.equalLeft.offset;
        }
    } else if (model.equalCenterX) {
        if (view.superview == model.equalCenterX.refView) {
            view.centerX_sd = model.equalCenterX.refView.width_sd * 0.5 + model.equalCenterX.offset;
        } else {
            view.centerX_sd = model.equalCenterX.refView.centerX_sd + model.equalCenterX.offset;
        }
    } else if (model.centerX) {
        view.centerX_sd = [model.centerX floatValue];
    }
}

- (void)layoutRightWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.rightItem) {
        if (view.superview == model.rightItem.refView) {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd = model.rightItem.refView.width_sd - view.left_sd - [model.rightItem.value floatValue];
            }
            view.right_sd = model.rightItem.refView.width_sd - [model.rightItem.value floatValue];
        } else {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_sd =  model.rightItem.refView.left_sd - view.left_sd - [model.rightItem.value floatValue];
            }
            view.right_sd = model.rightItem.refView.left_sd - [model.rightItem.value floatValue];
        }
    } else if (model.equalRight) {
        if (!view.fixedWidth) {
            if (model.equalRight.refView == view.superview) {
                view.width_sd = model.equalRight.refView.width_sd - view.left_sd + model.equalRight.offset;
            } else {
                view.width_sd = model.equalRight.refView.right_sd - view.left_sd + model.equalRight.offset;
            }
        }
        
        view.right_sd = model.equalRight.refView.right_sd + model.equalRight.offset;
        if (view.superview == model.equalRight.refView) {
            view.right_sd = model.equalRight.refView.width_sd + model.equalRight.offset;
        }
        
    }
}

- (void)layoutTopWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.topItem) {
        if (view.superview == model.topItem.refView) {
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height_sd = view.bottom_sd - [model.topItem.value floatValue];
            }
            view.top_sd = [model.topItem.value floatValue];
        } else {
            if (model.topItem.refViewsArray.count) {
                CGFloat lastRefBottom = 0;
                for (UIView *ref in model.topItem.refViewsArray) {
                    if ([ref isKindOfClass:[UIView class]] && ref.bottom_sd > lastRefBottom) {
                        model.topItem.refView = ref;
                        lastRefBottom = ref.bottom_sd;
                    }
                }
            }
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height_sd = view.bottom_sd - model.topItem.refView.bottom_sd - [model.topItem.value floatValue];
            }
            view.top_sd = model.topItem.refView.bottom_sd + [model.topItem.value floatValue];
        }
    } else if (model.equalTop) {
        if (view.superview == model.equalTop.refView) {
            if (!view.fixedHeight) {
                view.height_sd = view.bottom_sd - model.equalTop.offset;
            }
            view.top_sd = 0 + model.equalTop.offset;
        } else {
            if (!view.fixedHeight) {
                view.height_sd = view.bottom_sd - (model.equalTop.refView.top_sd + model.equalTop.offset);
            }
            view.top_sd = model.equalTop.refView.top_sd + model.equalTop.offset;
        }
    } else if (model.equalCenterY) {
        if (view.superview == model.equalCenterY.refView) {
            view.centerY_sd = model.equalCenterY.refView.height_sd * 0.5 + model.equalCenterY.offset;
        } else {
            view.centerY_sd = model.equalCenterY.refView.centerY_sd + model.equalCenterY.offset;
        }
    } else if (model.centerY) {
        view.centerY_sd = [model.centerY floatValue];
    }
}

- (void)layoutBottomWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    if (model.bottomItem) {
        if (view.superview == model.bottomItem.refView) {
            if (!view.fixedHeight) {
                view.height_sd = view.superview.height_sd - view.top_sd - [model.bottomItem.value floatValue];
            }
            view.bottom_sd = model.bottomItem.refView.height_sd - [model.bottomItem.value floatValue];
        } else {
            if (!view.fixedHeight) {
                view.height_sd = model.bottomItem.refView.top_sd - view.top_sd - [model.bottomItem.value floatValue];
            }
            view.bottom_sd = model.bottomItem.refView.top_sd - [model.bottomItem.value floatValue];
        }
        
    } else if (model.equalBottom) {
        if (view.superview == model.equalBottom.refView) {
            if (!view.fixedHeight) {
                view.height_sd = view.superview.height_sd - view.top_sd + model.equalBottom.offset;
            }
            view.bottom_sd = model.equalBottom.refView.height_sd + model.equalBottom.offset;
        } else {
            if (!view.fixedHeight) {
                view.height_sd = model.equalBottom.refView.bottom_sd - view.top_sd + model.equalBottom.offset;
            }
            view.bottom_sd = model.equalBottom.refView.bottom_sd + model.equalBottom.offset;
        }
    }
    if (model.widthEqualHeight && !view.fixedHeight) {
        [self layoutRightWithView:view model:model];
    }
}


- (void)setupCornerRadiusWithView:(UIView *)view model:(SDAutoLayoutModel *)model
{
    CGFloat cornerRadius = view.layer.cornerRadius;
    CGFloat newCornerRadius = 0;
    
    if (view.sd_cornerRadius && (cornerRadius != [view.sd_cornerRadius floatValue])) {
        newCornerRadius = [view.sd_cornerRadius floatValue];
    } else if (view.sd_cornerRadiusFromWidthRatio && (cornerRadius != [view.sd_cornerRadiusFromWidthRatio floatValue] * view.width_sd)) {
        newCornerRadius = view.width_sd * [view.sd_cornerRadiusFromWidthRatio floatValue];
    } else if (view.sd_cornerRadiusFromHeightRatio && (cornerRadius != view.height_sd * [view.sd_cornerRadiusFromHeightRatio floatValue])) {
        newCornerRadius = view.height_sd * [view.sd_cornerRadiusFromHeightRatio floatValue];
    }
    
    if (newCornerRadius > 0) {
        view.layer.cornerRadius = newCornerRadius;
        view.clipsToBounds = YES;
    }
}

- (void)addAutoLayoutModel:(SDAutoLayoutModel *)model
{
    [self.autoLayoutModelsArray addObject:model];
}

@end

@implementation UIButton (SDAutoLayoutButton)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sdal_exchengeMethods:@[@"layoutSubviews"] prefix:@"sd_button_"];
    });
}

- (void)sd_button_layoutSubviews
{
    // 如果程序崩溃在这行代码说明是你的view在执行“layoutSubvies”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“layoutSubvies”方法
    [self sd_button_layoutSubviews];
    
    [self sd_layoutSubviewsHandle];
    
}

@end


@implementation UIView (SDChangeFrame)

- (BOOL)shouldReadjustFrameBeforeStoreCache
{
    return self.sd_categoryManager.shouldReadjustFrameBeforeStoreCache;
}

- (void)setShouldReadjustFrameBeforeStoreCache:(BOOL)shouldReadjustFrameBeforeStoreCache
{
    self.sd_categoryManager.shouldReadjustFrameBeforeStoreCache = shouldReadjustFrameBeforeStoreCache;
}

- (CGFloat)left_sd {
    return self.frame.origin.x;
}

- (void)setLeft_sd:(CGFloat)x_sd {
    CGRect frame = self.frame;
    frame.origin.x = x_sd;
    self.frame = frame;
}

- (CGFloat)top_sd {
    return self.frame.origin.y;
}

- (void)setTop_sd:(CGFloat)y_sd {
    CGRect frame = self.frame;
    frame.origin.y = y_sd;
    self.frame = frame;
}

- (CGFloat)right_sd {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight_sd:(CGFloat)right_sd {
    CGRect frame = self.frame;
    frame.origin.x = right_sd - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom_sd {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom_sd:(CGFloat)bottom_sd {
    CGRect frame = self.frame;
    frame.origin.y = bottom_sd - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX_sd
{
    return self.left_sd + self.width_sd * 0.5;
}

- (void)setCenterX_sd:(CGFloat)centerX_sd
{
    self.left_sd = centerX_sd - self.width_sd * 0.5;
}

- (CGFloat)centerY_sd
{
    return self.top_sd + self.height_sd * 0.5;
}

- (void)setCenterY_sd:(CGFloat)centerY_sd
{
    self.top_sd = centerY_sd - self.height_sd * 0.5;
}

- (CGFloat)width_sd {
    return self.frame.size.width;
}

- (void)setWidth_sd:(CGFloat)width_sd {
    if (self.ownLayoutModel.widthEqualHeight) {
        if (width_sd != self.height_sd) return;
    }
    CGRect frame = self.frame;
    frame.size.width = width_sd;
    self.frame = frame;
    if (self.ownLayoutModel.heightEqualWidth) {
        self.height_sd = width_sd;
    }
}

- (CGFloat)height_sd {
    return self.frame.size.height;
}

- (void)setHeight_sd:(CGFloat)height_sd {
    if (self.ownLayoutModel.heightEqualWidth) {
        if (height_sd != self.width_sd) return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height_sd;
    self.frame = frame;
    
    if (self.ownLayoutModel.widthEqualHeight) {
        self.width_sd = height_sd;
    }
}

- (CGPoint)origin_sd {
    return self.frame.origin;
}

- (void)setOrigin_sd:(CGPoint)origin_sd {
    CGRect frame = self.frame;
    frame.origin = origin_sd;
    self.frame = frame;
}

- (CGSize)size_sd {
    return self.frame.size;
}

- (void)setSize_sd:(CGSize)size_sd {
    CGRect frame = self.frame;
    frame.size = size_sd;
    self.frame = frame;
}

@end

@implementation SDUIViewCategoryManager

@end

