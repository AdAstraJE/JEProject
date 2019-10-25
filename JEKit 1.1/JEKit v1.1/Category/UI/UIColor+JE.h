
#import <UIKit/UIKit.h>
#import "UIColor+YYAdd.h"

#define kRGB(r,g,b)         ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])
#define kRGBA(r,g,b,a)      ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])
#define kHexColor(X)         ([UIColor colorWithRed:((float)((X & 0xFF0000) >> 16))/255.0 green:((float)((X & 0xFF00) >> 8))/255.0 blue:((float)(X & 0xFF))/255.0 alpha:1.0])
#define kHexColorA(X,A)      ([UIColor colorWithRed:((float)((X & 0xFF0000) >> 16))/255.0 green:((float)((X & 0xFF00) >> 8))/255.0 blue:((float)(X & 0xFF))/255.0 alpha:A])


#define Clr_white         ([UIColor whiteColor])

#define Clr_blue          (kHexColor(0x007AFF))//系统蓝
#define Clr_lightBlue     (kHexColor(0x5ac8fa))
#define Clr_yellow        (kHexColor(0xffcc00))
#define Clr_orange        (kHexColor(0xff9500))
#define Clr_pink          (kHexColor(0xff2d55))
#define Clr_green         (kHexColor(0x4cd964))
#define Clr_red           (kHexColor(0xff3b30))

#define Clr_txt          (kHexColor(0x202020))
#define Clr_txt33        (kHexColor(0x333333))
#define Clr_txt66        (kHexColor(0x666666))
#define Clr_txt77        (kHexColor(0x777777))
#define Clr_txt99        (kHexColor(0x999999))
#define Clr_txtC8        (kHexColor(0xC8C8C8))

@interface UIColor (JE)

/// 随机颜色
+ (UIColor *)Random;

/// aberration 颜色色差后的颜色
- (UIColor * (^)(CGFloat abe,CGFloat alpha))abe;
- (UIColor * (^)(CGFloat alpha))alpha_;

///  渐变色 type 0=上到下 1=左到右 2=左上到右下 3=右上到左下
+ (UIColor*)je_gradient:(NSArray <id> *)colors withSize:(CGSize)size type:(NSInteger)type;

@end
