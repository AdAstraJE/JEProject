
#import <UIKit/UIKit.h>

/// 下拉复选框
@interface JEPutDownMenuView : UIView

+ (void)ShowIn:(UIView *)view point:(CGPoint)point list:(NSArray <NSString *> *)list select:(void (^)(NSString *str,NSInteger index))block;
+ (void)ShowIn:(UIView *)view point:(CGPoint)point list:(NSArray <NSString *> *)list select:(void (^)(NSString *str,NSInteger index))block upward:(BOOL)upward arrowX:(CGFloat)arrowX;

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)inview list:(NSArray <NSString *> *)list select:(void (^)(NSString *str,NSInteger index))block upward:(BOOL)upward arrowX:(CGFloat)arrowX;

@end
