
#import <Foundation/Foundation.h>

@interface NSTimer (Blocks)

- (void)Pause;///< 暂停
- (void)GoOn;///< 继续
- (void)GoOn:(NSTimeInterval)interval;///< X秒后继续

@end
