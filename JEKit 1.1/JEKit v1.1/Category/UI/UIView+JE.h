
#import <UIKit/UIKit.h>
#import "UIView+YYAdd.h"

CG_INLINE CGRect
JR(CGFloat x,CGFloat y,CGFloat width,CGFloat height){
    return CGRectMake(x, y, width, height);
}

CG_INLINE CGSize
JS(CGFloat width,CGFloat height){
    return CGSizeMake(width, height);
}

UIKIT_EXTERN  UIView * JEVe(CGRect rect,UIColor *clr,__kindof UIView *addTo);
UIKIT_EXTERN  UIVisualEffectView * JEEFVe(CGRect rect,UIBlurEffectStyle style,__kindof UIView *addTo);

@interface UIView (JE)

/// UIView
+ (__kindof UIView *)Frame:(CGRect)frame color:(UIColor*)color;

/// layout
+ (void)Center:(CGRect)inRect img:(__kindof UIImageView *)imgV gap:(CGFloat)gap la:(__kindof UILabel *)la in:(__kindof UIView*)inView;

/// NSKeyedArchiver copy UIView
- (__kindof UIView *)copyView;

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;

@property (nonatomic,assign) IBInspectable CGFloat   bor;    ///< 边框宽
@property (nonatomic,strong) IBInspectable UIColor  *borCol; ///< 边框颜色
@property (nonatomic,assign) IBInspectable CGFloat rad;///< 倒角
@property (nonatomic,assign) IBInspectable BOOL beRound;///< 变圆

/// 居中布局
- (__kindof UIView *)makeCenter:(__kindof UIImageView *)imgV la:(__kindof UILabel *)label gap:(CGFloat)gap;

/// mask layer 部分倒角
- (void)je_corner:(UIRectCorner)corner rad:(CGFloat)rad;

/// mask 为三角形
- (__kindof UIView *)je_triangle;
    
- (void)addShdow;///< 默认的阴影效果
- (__kindof UIView *)je_shadowRad:(CGFloat)rad edge:(CGFloat)edge clr:(UIColor *)clr;///< 全边框阴影效果

/// remove对应class的view
- (void)removeWithClass:(Class)classV;
/// 添加边框
- (void)border:(UIColor *)color width:(CGFloat)width;
/// Debug添加边框
- (void)je_Debug:(UIColor *)color width:(CGFloat)width;

/// viewWithTag
- (__kindof UILabel *)labelWithTag:(NSInteger)tag;
/// viewWithTag
- (__kindof UIButton *)buttonWithTag:(NSInteger)tag;
/// viewWithTag
- (__kindof UIImageView *)ImageViewWithTag:(NSInteger)tag;

- (__kindof UIView * (^)(NSInteger tag))tag_;///< self.tag =
- (__kindof UIView * (^)(NSInteger rad))rad_;///< self.rad =
- (__kindof UIView * (^)(__kindof UIView *view))addTo;///< [view addSubview:self]
- (__kindof UIView * (^)(__kindof UIView *view))insertTo;///< [view insertSubview:self atIndex:0]
- (__kindof UIView * (^)(CGRect rect))jeFrame;///< self.frame =
- (__kindof UIView * (^)(CGFloat x))jeX;///< self.x =
- (__kindof UIView * (^)(CGFloat y))jeY;///< self.y =
- (__kindof UIView * (^)(CGFloat w))jeW;///< self.width =
- (__kindof UIView * (^)(CGFloat h))jeH;///< self.height =

- (__kindof UITableView*)superTableView;///< cell view 根据nextResponder 获得 当前的TableView
- (__kindof UICollectionView *)superCollectionView;///< CollectionView
- (__kindof UIViewController*)superVC;///< view 根据nextResponder 获得 所在的viewcontroler
- (__kindof UIView *)find:(NSString *)className;///< 根据className 找view

#pragma mark - 手势
/// 单点击手势
- (void)tapGesture:(void (^)(UIGestureRecognizer *ges))block;
/// 长按手势
- (void)longPressGestrue:(void (^)(UIGestureRecognizer *ges))block;
/// 旋转手势
- (void)rotateGesture:(void (^)(UIGestureRecognizer *ges))block;

@end




