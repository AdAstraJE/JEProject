
//   JEAutoLayout 魔改简化版 -- 源自SDAutoLayout （2020.4.10）  from https://github.com/gsdios/SDAutoLayout

#import <UIKit/UIKit.h>
@class JELayoutModel;
NS_ASSUME_NONNULL_BEGIN

typedef JELayoutModel * _Nonnull (^JOViewValue)   (UIView *toView, CGFloat v);
typedef JELayoutModel * _Nonnull (^JOView)        (UIView *toView);
typedef JELayoutModel * _Nonnull (^JOValue)       (CGFloat v);
typedef JELayoutModel * _Nonnull (^JO2Value)      (CGFloat v1,CGFloat v2);
typedef JELayoutModel * _Nonnull (^JOSet)         (void);
/// 4项都设置了，可以返回自己了
typedef __kindof UIView * _Nonnull (^JOEndValue)(CGFloat value);
typedef __kindof UIView * _Nonnull (^JO4Value)(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIView (JEAutoLayout)   🔷🔷🔷🔷🔷🔷🔷🔷
@interface UIView (JEAutoLayout)

///开始布局
- (JELayoutModel *)jo;

/// 清空&重新开始布局
- (JELayoutModel *)jo_reset;

/// 立即更新布局 view.frame
- (void)updateLayout;

@property (nonatomic,strong,readonly) JELayoutModel * _Nullable jo_layoutMod;///< layoutMod
@property (nonatomic) void (^ _Nullable didFinishAutoLayoutBlock)(CGRect frame);///< 自动布局完成后的回调block,


@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JELayoutMod   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JELayoutModel : NSObject

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

@property(nonatomic,strong,readonly) JOSet       subviewSameW   ;///< 子view同宽 需要在同一水平方向
@property(nonatomic,strong,readonly) JOValue     autoW          ;///< label button 自动调整width 传额外值 (float)
@property(nonatomic,strong,readonly) JOValue     autoH          ;///< label 自动调整height 传额外值       (float)

@property (nonatomic,weak) __kindof UIView *me;///< 自己 放链式最后返回自己以结束布局

@property (nonatomic,assign) BOOL close;///< 是否关闭自动布局

@end


NS_ASSUME_NONNULL_END
