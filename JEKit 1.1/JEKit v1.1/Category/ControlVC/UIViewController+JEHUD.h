
#import <UIKit/UIKit.h>
@class MBProgressHUD;
@class JEHUDView;

typedef NS_ENUM(NSUInteger, HUDMarkType) {
    HUDMarkTypeSuccess = 0,///< √
    HUDMarkTypefailure = 1,///< X
    HUDMarkTypeNetError = 2,///< 网络错误图标
    HUDMarkTypeSystemBusy = 3,///< 系统忙
    HUDMarkTypeNone = 100,
};


NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (JEHUD)

@property (nonatomic,strong) JEHUDView *HUDView;///< 显示时只有返回键可以点击
@property (nonatomic,strong,readonly) MBProgressHUD *HUD;///< hud

/// 一直显示HUD 不可点击
- (void)showHUD;

/// 显示HUD动画 和 文字
- (void)showHUDLabelText:(NSString*)text;
- (void)showHUDLabelText:(NSString*)text delay:(CGFloat)delay;

/// 显示文本  背景可点击做其他操作  默认延迟消失
- (void)showHUD:(NSString * __nullable)text;
- (void)showHUD:(NSString * __nullable)text delay:(CGFloat)delay;

/// 显示文本  背景可点击做其他操作 显示默认图片类型  默认延迟消失
- (void)showHUD:(NSString * __nullable)text type:(HUDMarkType)type;

///  显示文本  背景可点击做其他操作
- (void)showHUD:(NSString * __nullable)text type:(HUDMarkType)type delay:(CGFloat)delay;

/// 显示默认图片类型  延迟消失时间
- (void)showHUD:(NSString * __nullable)text touch:(BOOL)touch type:(HUDMarkType)type delay:(CGFloat)delay;

/// hideHud
- (void)hideHud;

@end

NS_ASSUME_NONNULL_END
