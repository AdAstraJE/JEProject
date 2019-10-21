
#import <UIKit/UIKit.h>

@interface UIView (PressMenu)
@property (strong, nonatomic) NSArray *menuTitles;
@property (strong, nonatomic) UILongPressGestureRecognizer *pressGR;
@property (copy, nonatomic) void(^menuClickedBlock)(NSInteger index, NSString *title);
@property (strong, nonatomic) UIMenuController *menuVC;

- (void)je_addPressMenuTitles:(NSArray *)menuTitles menuClickedBlock:(void(^)(NSInteger index, NSString *title))block;
- (void)je_showMenuTitles:(NSArray *)menuTitles menuClickedBlock:(void(^)(NSInteger index, NSString *title))block;

- (BOOL)je_isMenuVCVisible;
- (void)je_removePressMenu;

@end
