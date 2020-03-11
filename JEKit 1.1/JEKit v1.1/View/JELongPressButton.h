
#import <UIKit/UIKit.h>

@interface JELongPressButton : UIView

/// 长按触发按钮
/// @param frame W=H
/// @param lineWidth 进度线宽
/// @param lineGap 线和中间按钮的间距
/// @param done 长按完成后触发
- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineGap:(CGFloat)lineGap done:(void (^)(void))done;

@property (nonatomic,strong) UIButton *Btn;///< 长按的按钮 默认没东西
@property (nonatomic,strong) CAShapeLayer *backLayer;///< 进度背景layer
@property (nonatomic,strong) CAShapeLayer *frontLayer;///< 进度中layer

@end
