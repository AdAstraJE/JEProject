
#import <UIKit/UIKit.h>
@class JEButton;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JEPopType) {
    JEPopTypeMiddle,///< 中间渐显
    JEPopTypeBottom,///< 从最下面上来 
    
};

/// 弹出的背景
@interface JEBaseBackView : UIView

///  [JEApp.window addSubview:[[view alloc] initWithFrame:JEApp.window.bounds]];
+ (instancetype)Show;

- (instancetype)initWithFrame:(CGRect)frame contentHieht:(CGFloat)height;
    
@property (nonatomic,assign) JEPopType popType;///< 弹出类型
@property (nonatomic,assign,getter=istapToDismiss) BOOL tapToDismiss;///< 默认 NO 点击 Ve_content 以外的边界视图消失

@property (nonatomic,strong) UIView *Ve_content;///< 主视图
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIVisualEffectView *maskView;

- (void)resetWidth:(CGFloat)widht;
- (void)resetHeight:(CGFloat)height;

/// 添加模拟系统的 取消 确定
- (void)addCancelConfirmBtn;
@property (nonatomic,strong) JEButton *__nullable Btn_cancel;///< 取消
@property (nonatomic,strong) JEButton *__nullable Btn_confirm;///< 确定
@property (nonatomic,strong) UIView *lineH,*lineV;
- (void)confirmBtnClick;

/// 显示
- (void)show;

/// 隐藏 销毁 
- (void)dismiss;

/// 黑暗模式
- (void)handelStyleDark;

@end


@interface JEInputView : JEBaseBackView

@end


NS_ASSUME_NONNULL_END
