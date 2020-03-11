
#import <UIKit/UIKit.h>

@interface JENumberAnimateLabel : UILabel

/// 动态跳动数字
- (void)showAnimateNumber:(NSNumber *)number;

- (void)suffixUnit:(NSString *)unit font:(UIFont *)font clr:(UIColor *)clr;

@end
