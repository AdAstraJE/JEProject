
#import <UIKit/UIKit.h>
#import "UIColor+YYAdd.h"

#define kRGB(r,g,b)         ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])
#define kRGBA(r,g,b,a)      ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])
#define kHexColor(X)         ([UIColor colorWithRed:((float)((X & 0xFF0000) >> 16))/255.0 green:((float)((X & 0xFF00) >> 8))/255.0 blue:((float)(X & 0xFF))/255.0 alpha:1.0])
#define kHexColorA(X,A)      ([UIColor colorWithRed:((float)((X & 0xFF0000) >> 16))/255.0 green:((float)((X & 0xFF00) >> 8))/255.0 blue:((float)(X & 0xFF))/255.0 alpha:A])


#define Clr_white         (UIColor.whiteColor)

#define Clr_blue          (kHexColor(0x007AFF))//系统蓝
#define Clr_lightBlue     (kHexColor(0x5ac8fa))
#define Clr_yellow        (kHexColor(0xffcc00))
#define Clr_orange        (kHexColor(0xff9500))
#define Clr_pink          (kHexColor(0xff2d55))
#define Clr_green         (kRGB(67, 199, 89))
#define Clr_red           (kHexColor(0xff3b30))

//#define Clr_txt          (kHexColor(0x202020))//32,
//#define Clr_txt33        (kHexColor(0x333333))//51,
//#define Clr_txt66        (kHexColor(0x666666))//102,gary1
//#define Clr_txt77        (kHexColor(0x777777))//119,gary1
//#define Clr_txt80        (kHexColor(0x808080))//128,gary1
//#define Clr_txt99        (kHexColor(0x999999))//153,gary1
//#define Clr_txtC8        (kHexColor(0xC8C8C8))//200,gary2

#define gary1        (UIColor.je_gary1)
#define gary2        (UIColor.je_gary2)
#define gary3        (UIColor.je_gary3)

@interface UIColor (JE)

#pragma mark - UIUserInterfaceStyleDark | UIUserInterfaceStyleLight
@property (class, nonatomic, readonly) UIColor *je_bw;///< 纯黑 | 纯白
@property (class, nonatomic, readonly) UIColor *je_txt;  ///< labelColor
@property (class, nonatomic, readonly) UIColor *je_gary1;///< secondaryLabelColor 235,235,245,0.6 | 60,60,67,0.6
@property (class, nonatomic, readonly) UIColor *je_gary2;///< tertiaryLabelColor 235,235,245,0.3 | 60,60,67,0.3
@property (class, nonatomic, readonly) UIColor *je_gary3;///< quaternaryLabelColor  235,235,245,0.16 | 60,60,67,0.18
@property (class, nonatomic, readonly) UIColor *je_sepLine;///< 分割线

/// ligth dark
+ (UIColor *)Light:(UIColor *)light dark:(UIColor *)dark;

/// 随机颜色
+ (UIColor *)Random;

/// aberration 颜色色差后的颜色
- (UIColor * (^)(CGFloat abe,CGFloat alpha))abe;
- (UIColor * (^)(CGFloat alpha))alpha_;

///  渐变色 type 0=上到下 1=左到右 2=左上到右下 3=右上到左下
+ (UIColor*)je_gradient:(NSArray <id> *)colors withSize:(CGSize)size type:(NSInteger)type;

@end
