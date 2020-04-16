
//   JEAutoLayout 魔改简化版 -- 源自SDAutoLayout （2020.4.10）  from https://github.com/gsdios/SDAutoLayout

#import <UIKit/UIKit.h>
@class JELayoutTool;

NS_ASSUME_NONNULL_BEGIN

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JELayoutMod   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JELayoutMod : NSObject

typedef JELayoutMod * _Nonnull (^JOSet)(void);
typedef JELayoutMod * _Nonnull (^JOViewValue)(UIView *toView, CGFloat v);
typedef JELayoutMod * _Nonnull (^JOView)(UIView *toView);
typedef JELayoutMod * _Nonnull (^JOValue)(CGFloat v);
typedef JELayoutMod * _Nonnull (^JO2Value)(CGFloat v1,CGFloat v2);

/// 4项都设置了，可以返回自己了
typedef __kindof UIView * _Nonnull (^JOEndValue)(CGFloat value);
typedef __kindof UIView * _Nonnull (^JO4Value)(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

// 相当于AutoLayout的 (? Space to)
@property(nonatomic,strong,readonly) JOViewValue  left_  ;///< 左边到参照view的间距 (view, float)
@property(nonatomic,strong,readonly) JOViewValue  right_ ;///< 右边到参照view的间距 (view, float)
@property(nonatomic,strong,readonly) JOViewValue  top_   ;///< 顶部到参照view的间距 (view, float)
@property(nonatomic,strong,readonly) JOViewValue  bottom_;///< 底部到参照view的间距 (view, float)
//---------------------------------- 为上面4种派生，方便构建方法。
@property(nonatomic,strong,readonly) JOValue      left   ;///< 父视图 left_
@property(nonatomic,strong,readonly) JOValue      right  ;///< 父视图 right_
@property(nonatomic,strong,readonly) JOValue      top    ;///< 父视图 top_
@property(nonatomic,strong,readonly) JOValue      bottom ;///< 父视图 bottom_
@property(nonatomic,strong,readonly) JOValue      lr     ;///< left & right 相同值
@property(nonatomic,strong,readonly) JOValue      tb     ;///< top & bottom 相同值
@property(nonatomic,strong,readonly) JOValue      tb_l   ;///< 左部上下贴边0 & 左间距
@property(nonatomic,strong,readonly) JOValue      tb_r   ;///< 右部上下贴边0 & 右间距
@property(nonatomic,strong,readonly) JOEndValue   lrt0_h ;///< 顶部贴边0 & height
@property(nonatomic,strong,readonly) JOEndValue   lrb0_h ;///< 底部贴边0 & height
@property(nonatomic,strong,readonly) JOEndValue   insets ;///< top left bottom right 相同值
@property(nonatomic,strong,readonly) JO4Value     inset  ;///< top left bottom right


@property(nonatomic,strong,readonly) JOValue      x          ;///< frame.origin.x     固定值 (float)
@property(nonatomic,strong,readonly) JOValue      y          ;///< frame.origin.y     固定值 (float)
@property(nonatomic,strong,readonly) JOValue      w          ;///< frame.size.width   固定值 (float)
@property(nonatomic,strong,readonly) JOValue      h          ;///< frame.size.height  固定值 (float)
@property(nonatomic,strong,readonly) JO2Value     wh         ;///< width & height     固定值 (float, float)
@property(nonatomic,strong,readonly) JOViewValue  w_rate     ;///< width 是参照view.width的多少倍   (view, float)
@property(nonatomic,strong,readonly) JOViewValue  h_rate     ;///< height是参照view.height的多少倍  (view, float)
@property(nonatomic,strong,readonly) JOSet        w_lock_h   ;///< width 值锁定height值 width为准 等值
@property(nonatomic,strong,readonly) JOSet        h_lock_w   ;///< height值锁定width值 height为准 等值
@property(nonatomic,strong,readonly) JOValue      h_rateBy_w ;///< height是width的多少倍, label传0实现高度自适应 (float)
@property(nonatomic,strong,readonly) JOValue      w_rateBy_h ;///< width 是height的多少倍 比如用作UIImageView  (float)
@property(nonatomic,strong,readonly) JOValue      maxW       ;///< width 不会大于这个数 最大是maxW   (float)
@property(nonatomic,strong,readonly) JOValue      maxH       ;///< height不会大于这个数 最大是maxH   (float)
@property(nonatomic,strong,readonly) JOValue      minW       ;///< width 不会小于这个数 至少是minW   (float)
@property(nonatomic,strong,readonly) JOValue      minH       ;///< height不会小于这个数 至少是minH   (float)
@property(nonatomic,strong,readonly) JOValue      centerXIs  ;///< centerX值, (float)
@property(nonatomic,strong,readonly) JOValue      centerYIs  ;///< centerY值, (float)

// 相当于AutoLayout的 (Align ? to)
@property(nonatomic,strong,readonly) JOView      leftSameTo     ;///< 左部    与参照view相同  (view)
@property(nonatomic,strong,readonly) JOView      rightSameTo    ;///< 右部    与参照view相同  (view)
@property(nonatomic,strong,readonly) JOView      topSameTo      ;///< 顶部    与参照view相同  (view)
@property(nonatomic,strong,readonly) JOView      bottomSameTo   ;///< 底部    与参照view相同  (view)
@property(nonatomic,strong,readonly) JOView      centerXSameTo  ;///< centerX与参照view相同  (view)
@property(nonatomic,strong,readonly) JOView      centerYSameTo  ;///< centerY与参照view相同  (view)
@property(nonatomic,strong,readonly) JOValue     offset         ;///< 设置最后一个 以上?SameTo: 的偏移量, (float)
//---------------------------------- 为上面派生，方便构建方法。
@property(nonatomic,strong,readonly) JOViewValue lead           ;///< leftSameTo  & offset
@property(nonatomic,strong,readonly) JOViewValue trall          ;///< rightSameTo & offset
@property(nonatomic,strong,readonly) JOSet       inCenterX      ;///< centerXSameTo 父视图
@property(nonatomic,strong,readonly) JOSet       inCenterY      ;///< centerYSameTo 父视图

@property(nonatomic,strong,readonly) JOValue      autoW         ;///< label button 自动调整width 传额外值 (float)
@property(nonatomic,strong,readonly) JOValue      autoH         ;///< label 自动调整height 传额外值       (float)

@property (nonatomic, weak) __kindof UIView *me;///< 自己 放链式最后返回自己以结束布局

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  JELayoutModItem   🔷🔷🔷🔷🔷🔷🔷🔷

@interface JELayoutItem : NSObject

@property (nonatomic, weak) UIView * _Nullable toView;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat offset;

@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JELOAutoHeightWidth)   🔷🔷🔷🔷🔷🔷🔷🔷
#pragma mark - UIView 高度、宽度自适应相关方法

@interface UIView (JELOAutoHeightWidth)

/** 设置Cell的高度自适应,也可用于设置普通view内容高度自适应 */
- (void)setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin;

/** 用于设置普通view内容宽度自适应 */
- (void)setupAutoWidthWithRightView:(UIView *)rightView rightMargin:(CGFloat)rightMargin;

/** 设置Cell的高度自适应,也可用于设置普通view内容自适应（应用于当你不确定哪个view在自动布局之后会排布在最下方最为bottomView的时候可以调用次方法将所有可能在最下方的view都传过去） */
- (void)setupAutoHeightWithBottomViewsArray:(NSArray *)bottomViewsArray bottomMargin:(CGFloat)bottomMargin;

/** 更新布局（主动刷新布局,如果你需要设置完布局代码就获得view的frame请调用此方法） */
- (void)updateLayout;

@property (nonatomic, readonly) JELayoutTool * _Nullable jo_tool;

@property (nonatomic, readonly) NSMutableArray * _Nullable jo_bottomViews;
@property (nonatomic) CGFloat jo_bottomViewBottomMargin;

@property (nonatomic) NSArray * _Nullable jo_rightViews;
@property (nonatomic) CGFloat jo_rightViewRightMargin;

@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JELOExtention)   🔷🔷🔷🔷🔷🔷🔷🔷
#pragma mark - UIView 设置圆角半径、自动布局回调block等相关方法

@interface UIView (JELOExtention)

/** 自动布局完成后的回调block,可以在这里获取到view的真实frame  */
@property (nonatomic) void (^ _Nullable didFinishAutoLayoutBlock)(CGRect frame);

/** 设置固定宽度保证宽度不在自动布局过程再做中调整  */
@property (nonatomic, strong) NSNumber * _Nullable fixedWidth;

/** 设置固定高度保证高度不在自动布局过程中再做调整  */
@property (nonatomic, strong) NSNumber * _Nullable fixedHeight;

/** 设置圆角半径值  */
@property (nonatomic, strong) NSNumber * _Nullable jo_rad;
/** 设置圆角半径值为view宽度的多少倍  */
@property (nonatomic, strong) NSNumber * _Nullable jo_radWRate;
/** 设置圆角半径值为view高度的多少倍  */
@property (nonatomic, strong) NSNumber * _Nullable jo_radHRate;

/** 设置等宽子view（子view需要在同一水平方向） */
@property (nonatomic, strong) NSArray * _Nullable jo_equalWidthSubviews;


@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JELOFlowItems)   🔷🔷🔷🔷🔷🔷🔷🔷
#pragma mark - UIView 九宫格浮动布局效果

@interface UIView (JELOFlowItems)

/** 
 * 设置类似collectionView效果的固定间距自动宽度浮动子view 
 * viewsArray       : 需要浮动布局的所有视图
 * perRowItemsCount : 每行显示的视图个数
 * verticalMargin   : 视图之间的垂直间距
 * horizontalMargin : 视图之间的水平间距
 * vInset           : 上下缩进值
 * hInset           : 左右缩进值
 */
- (void)setupAutoWidthFlowItems:(NSArray *_Nullable)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount verticalMargin:(CGFloat)verticalMargin horizontalMargin:(CGFloat)horizontalMagin verticalEdgeInset:(CGFloat)vInset horizontalEdgeInset:(CGFloat)hInset;

/** 清除固定间距自动宽度浮动子view设置 */
- (void)clearAutoWidthFlowItemsSettings;

/** 
 * 设置类似collectionView效果的固定宽带自动间距浮动子view 
 * viewsArray       : 需要浮动布局的所有视图
 * perRowItemsCount : 每行显示的视图个数
 * verticalMargin   : 视图之间的垂直间距
 * vInset           : 上下缩进值
 * hInset           : 左右缩进值
 */
- (void)setupAutoMarginFlowItems:(NSArray *_Nullable)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount itemWidth:(CGFloat)itemWidth verticalMargin:(CGFloat)verticalMargin verticalEdgeInset:(CGFloat)vInset horizontalEdgeInset:(CGFloat)hInset;

/** 清除固定宽带自动间距浮动子view设置 */
- (void)clearAutoMarginFlowItemsSettings;

@end






#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JEAutoLayout)   🔷🔷🔷🔷🔷🔷🔷🔷
#pragma mark - UIView 设置约束、更新约束、清空约束、从父view移除并清空约束、开启cell的frame缓存等相关方法

@interface UIView (JEAutoLayout)

///开始布局
- (JELayoutMod *)jo;

/** 清空之前的自动布局设置,重新开始自动布局(重新生成布局约束并使其在父view的布局序列数组中位置保持不变)  */
- (JELayoutMod *)jo_resetLayout;

/** 清空之前的自动布局设置,重新开始自动布局(重新生成布局约束并添加到父view布局序列数组中的最后一个位置)  */
- (nonnull JELayoutMod *)jo_resetNewLayout;

/** 是否关闭自动布局  */
@property (nonatomic) BOOL jo_closeAutoLayout;

/** 从父view移除并清空约束  */
- (void)removeFromSuperviewAndClearAutoLayoutSettings;

/** 清空之前的自动布局设置  */
- (void)jo_clearAutoLayoutSettings;

/** 将自身frame清零（一般在cell内部控件重用前调用）  */
- (void)jo_clearViewFrameCache;

/** 将自己的需要自动布局的subviews的frame(或者frame缓存)清零  */
- (void)jo_clearSubviewsAutoLayoutFrameCaches;

- (NSMutableArray <JELayoutMod *> * _Nullable)autoLayoutModelsArray;

@property (nonatomic) JELayoutMod * _Nullable ownLayoutModel;
//@property (nonatomic, strong) NSNumber * _Nullable jo_maxWidth;


@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIScrollView (JELOAutoContentSize)   🔷🔷🔷🔷🔷🔷🔷🔷
#pragma mark - UIScrollView 内容竖向自适应、内容横向自适应方法

@interface UIScrollView (JELOAutoContentSize)

/** 设置scrollview内容竖向自适应 */
- (void)setupAutoContentSizeWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin;

/** 设置scrollview内容横向自适应 */
- (void)setupAutoContentSizeWithRightView:(UIView *)rightView rightMargin:(CGFloat)rightMargin;

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  JEUIViewCategoryManager   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JELayoutTool : NSObject

@property (nonatomic, strong) NSArray * _Nullable rightViewsArray;
@property (nonatomic, assign) CGFloat rightViewRightMargin;

@property (nonatomic, assign) BOOL hasSetFrameWithCache;

@property (nonatomic) BOOL shouldReadjustFrameBeforeStoreCache;

@property (nonatomic, assign) BOOL jo_closeAutoLayout;


/** 设置类似collectionView效果的固定间距自动宽度浮动子view */

@property (nonatomic, strong) NSArray * _Nullable flowItems;
@property (nonatomic, assign) CGFloat verticalMargin;
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic, assign) NSInteger perRowItemsCount;
@property (nonatomic, assign) CGFloat lastWidth;


/** 设置类似collectionView效果的固定宽带自动间距浮动子view */

@property (nonatomic, assign) CGFloat flowItemWidth;
@property (nonatomic, assign) BOOL shouldShowAsAutoMarginViews;


@property (nonatomic) CGFloat horizontalEdgeInset;
@property (nonatomic) CGFloat verticalEdgeInset;

@end

NS_ASSUME_NONNULL_END
