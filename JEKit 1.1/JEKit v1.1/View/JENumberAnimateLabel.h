
#import <UIKit/UIKit.h>

@interface JENumberAnimateLabel : UILabel

- (void)showAnimateNumber:(NSNumber *)number;

- (void)suffixUnit:(NSString *)unit font:(UIFont *)font clr:(UIColor *)clr;

@end
