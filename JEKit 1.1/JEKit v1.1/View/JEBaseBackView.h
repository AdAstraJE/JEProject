
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JEPopType) {
    JEPopTypeMiddle,/**< 中间渐显 */
    JEPopTypeBottom,/**< 从最下面上来 */
    
};

/** 弹出的背景 */
@interface JEBaseBackView : UIView

/**  [JEApp.window addSubview:[[view alloc] initWithFrame:JEApp.window.bounds]]; */
+ (instancetype)Show;

- (instancetype)initWithFrame:(CGRect)frame contentHieht:(CGFloat)height;
    
@property (nonatomic,assign) JEPopType popType;///< 弹出类型
@property (nonatomic,assign,getter=istapToDismiss) BOOL tapToDismiss;///< 默认 NO 点击 Ve_content 以外的边界视图消失

@property (nonatomic,strong) UIView *Ve_content;///< 主视图
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *maskView;

- (void)resetWidth:(CGFloat)widht;
    
/** 显示 */
- (void)show;

/** 隐藏 销毁 */
- (void)dismiss;

@end



@interface JEInputView : JEBaseBackView

@end
