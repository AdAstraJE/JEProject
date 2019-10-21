
#import <UIKit/UIKit.h>

@interface JECircleProgressView : UIView

@property (nonatomic,strong) UIColor *strokeColor;///< 线条背景色
@property (nonatomic,strong) UIColor *fillColor;///< 线条填充色
@property (nonatomic,assign) CGFloat lineWidth;///< 线宽
@property (nonatomic,assign) CGFloat backLineWidth;///< 线宽
@property (nonatomic,assign) CGFloat startAngle;///< 起点角度
@property (nonatomic,assign) CGFloat reduceAngle;///< 减少的角度

@property (nonatomic,assign) BOOL increaseFromLast;///< 是否从上次数值开始动画，默认为YES
@property (nonatomic,assign) BOOL animation;///< 是否动画，默认为YES
@property (nonatomic,assign) CGFloat duration;///< 动画时长 默认 0.35
@property (nonatomic, assign) CGFloat progress;///< 设置进度 0-1

@property (nonatomic,strong) UIImageView *Img_end;///< 动态显示的跟随动画点
@property (nonatomic, assign) CGFloat endDotFixRad;///< ### 0

/** 进度条 */
- (instancetype)initWithFrame:(CGRect)frame stroke:(UIColor *)strokeColor fill:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth start:(CGFloat)startAngle reduce:(CGFloat)reduceAngle;

/** 进度条 */
- (instancetype)initWithFrame:(CGRect)frame stroke:(UIColor *)strokeColor fill:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth start:(CGFloat)startAngle reduce:(CGFloat)reduceAngle backLineWidth:(CGFloat)backLineWidth;


/** 固定显示起始点（图片）偏移角度&位置 */
- (void)showStartDot:(UIImage *)image size:(CGSize)size degree:(CGFloat)degress offset:(CGPoint)offset;

/** 动画跟随显示结束点（图片） */
- (void)showEndDot:(UIImage *)image size:(CGSize)size;

/** 设置进度 */
- (void)setProgress:(CGFloat)progress animation:(BOOL)animation;

@end
