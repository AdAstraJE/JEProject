
#import <UIKit/UIKit.h>

/** 下拉复选框 */
@interface JEPutDownMenuView : UIView

typedef void(^selectBlock)(NSString *str,NSInteger index);
@property (nonatomic,copy) selectBlock selectBlock;/// 点击的回调

+ (void)ShowIn:(UIView *)view point:(CGPoint)point list:(NSArray <NSString *> *)list select:(selectBlock)block;
+ (void)ShowIn:(UIView *)view point:(CGPoint)point list:(NSArray <NSString *> *)list select:(selectBlock)block upward:(BOOL)upward arrowX:(CGFloat)arrowX;

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)inview list:(NSArray <NSString *> *)list select:(selectBlock)block upward:(BOOL)upward arrowX:(CGFloat)arrowX;


@end
