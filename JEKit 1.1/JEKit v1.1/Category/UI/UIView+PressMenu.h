
#import <UIKit/UIKit.h>

@interface UIView (PressMenu)

@property (strong, nonatomic,readonly) NSArray <NSString *> *menuTitles;
@property (strong, nonatomic,readonly) UILongPressGestureRecognizer *pressGR;
@property (copy, nonatomic,readonly) void(^menuClickedBlock)(NSInteger index, NSString *title);
@property (strong, nonatomic,readonly) UIMenuController *menuVC;

/// 添加长按手势 弹出UIMenuController
- (void)je_addPressMenuTitles:(NSArray <NSString *> *)menuTitles menuClickedBlock:(void(^)(NSInteger index, NSString *title))block;

/// 弹出UIMenuController
- (void)je_showMenuTitles:(NSArray <NSString *> *)menuTitles menuClickedBlock:(void(^)(NSInteger index, NSString *title))block;

@property (assign, nonatomic,readonly) BOOL je_isMenuVCVisible;

/// remove UIMenuController && UILongPressGestureRecognizer
- (void)je_removePressMenu;

@end
