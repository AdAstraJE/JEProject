
#import <UIKit/UIKit.h>
#import "UIColor+YYAdd.h"

#define kRGB(r,g,b)         ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])
#define kRGBA(r,g,b,a)      ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])
#define kHexColor(X)         ([UIColor colorWithRed:((float)((X & 0xFF0000) >> 16))/255.0 green:((float)((X & 0xFF00) >> 8))/255.0 blue:((float)(X & 0xFF))/255.0 alpha:1.0])
#define kHexColorA(X,A)      ([UIColor colorWithRed:((float)((X & 0xFF0000) >> 16))/255.0 green:((float)((X & 0xFF00) >> 8))/255.0 blue:((float)(X & 0xFF))/255.0 alpha:A])


#define Clr_white         (UIColor.whiteColor)
#define Clr_blue          (UIColor.systemBlueColor)
#define Clr_lightBlue     (UIColor.systemTealColor)
#define Clr_yellow        (UIColor.systemYellowColor)
#define Clr_orange        (UIColor.systemOrangeColor)
#define Clr_pink          (UIColor.systemPinkColor)
#define Clr_green         (UIColor.systemGreenColor)
#define Clr_red           (UIColor.systemRedColor)

#define Tgray1        (UIColor.je_Tgray1)
#define Tgray2        (UIColor.je_Tgray2)
#define Tgray3        (UIColor.je_Tgray3)

@interface UIColor (JE)

#pragma mark - UIUserInterfaceStyleLight | UIUserInterfaceStyleDark

+ (UIColor *)je_wb;///< 纯白 | 纯黑
+ (UIColor *)je_bw;///< 纯黑 | 纯白
+ (UIColor *)je_txt;  ///< labelColor
+ (UIColor *)je_Tgray1;///< secondaryLabelColor (60,60,67,0.6) | (235,235,245,0.6)
+ (UIColor *)je_Tgray2;///< tertiaryLabelColor  (60,60,67,0.3) | (235,235,245,0.3)
+ (UIColor *)je_Tgray3;///< quaternaryLabelColor (60,60,67,0.18) | (235,235,245,0.16)
+ (UIColor *)je_sep;///< 分割线 UIColor.separatorColor

+ (UIColor *)gray1;///< systemGrayColor   (142, 142, 147, 1.0) | (142, 142, 147, 1.0)
+ (UIColor *)gray2;///< systemGray2Color  (174, 174, 178, 1.0) | (99, 99, 102, 1.0)
+ (UIColor *)gray3;///< systemGray3Color  (199, 199, 204, 1.0) | (72, 72, 74, 1.0)
+ (UIColor *)gray4;///< systemGray4Color  (209, 209, 214, 1.0) | (58, 58, 60, 1.0)
+ (UIColor *)gray5;///< systemGray5Color  (229, 229, 234, 1.0) | (44, 44, 46, 1.0)
+ (UIColor *)gray6;///< systemGray6Color  (242, 242, 247, 1.0) | (28, 28, 30, 1.0)
+ (UIColor *)cellBgC;///< GroupedBackgroundColor  (255, 255, 255, 1.0) | (28, 28, 30, 1.0)
+ (UIColor *)groupTvBgC;///< systemGroupedBackgroundColor

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

/*
light
kRGBA(255, 59, 48, 1.0) systemRedColor
kRGBA(52, 199, 89, 1.0) systemGreenColor
kRGBA(0, 122, 255, 1.0) systemBlueColor
kRGBA(255, 149, 0, 1.0) systemOrangeColor
kRGBA(255, 204, 0, 1.0) systemYellowColor
kRGBA(255, 45, 85, 1.0) systemPinkColor
kRGBA(175, 82, 222, 1.0) systemPurpleColor
kRGBA(90, 200, 250, 1.0) systemTealColor
kRGBA(88, 86, 214, 1.0) systemIndigoColor
kRGBA(142, 142, 147, 1.0) systemGrayColor
kRGBA(174, 174, 178, 1.0) systemGray2Color
kRGBA(199, 199, 204, 1.0) systemGray3Color
kRGBA(209, 209, 214, 1.0) systemGray4Color
kRGBA(229, 229, 234, 1.0) systemGray5Color
kRGBA(242, 242, 247, 1.0) systemGray6Color
kRGBA(0, 0, 0, 1.0) labelColor
kRGBA(60, 60, 67, 0.6) secondaryLabelColor
kRGBA(60, 60, 67, 0.3) tertiaryLabelColor
kRGBA(60, 60, 67, 0.2) quaternaryLabelColor
kRGBA(0, 122, 255, 1.0) linkColor
kRGBA(60, 60, 67, 0.3) placeholderTextColor
kRGBA(60, 60, 67, 0.3) separatorColor
kRGBA(198, 198, 200, 1.0) opaqueSeparatorColor
kRGBA(255, 255, 255, 1.0) systemBackgroundColor
kRGBA(242, 242, 247, 1.0) secondarySystemBackgroundColor
kRGBA(255, 255, 255, 1.0) tertiarySystemBackgroundColor
kRGBA(242, 242, 247, 1.0) systemGroupedBackgroundColor
kRGBA(255, 255, 255, 1.0) secondarySystemGroupedBackgroundColor
kRGBA(242, 242, 247, 1.0) tertiarySystemGroupedBackgroundColor
kRGBA(120, 120, 128, 0.2) systemFillColor
kRGBA(120, 120, 128, 0.2) secondarySystemFillColor
kRGBA(118, 118, 128, 0.1) tertiarySystemFillColor
kRGBA(116, 116, 128, 0.1) quaternarySystemFillColor

Dark
kRGBA(255, 69, 58, 1.0) systemRedColor
kRGBA(48, 209, 88, 1.0) systemGreenColor
kRGBA(10, 132, 255, 1.0) systemBlueColor
kRGBA(255, 159, 10, 1.0) systemOrangeColor
kRGBA(255, 214, 10, 1.0) systemYellowColor
kRGBA(255, 55, 95, 1.0) systemPinkColor
kRGBA(191, 90, 242, 1.0) systemPurpleColor
kRGBA(100, 210, 255, 1.0) systemTealColor
kRGBA(94, 92, 230, 1.0) systemIndigoColor
kRGBA(142, 142, 147, 1.0) systemGrayColor
kRGBA(99, 99, 102, 1.0) systemGray2Color
kRGBA(72, 72, 74, 1.0) systemGray3Color
kRGBA(58, 58, 60, 1.0) systemGray4Color
kRGBA(44, 44, 46, 1.0) systemGray5Color
kRGBA(28, 28, 30, 1.0) systemGray6Color
kRGBA(255, 255, 255, 1.0) labelColor
kRGBA(235, 235, 245, 0.6) secondaryLabelColor
kRGBA(235, 235, 245, 0.3) tertiaryLabelColor
kRGBA(235, 235, 245, 0.2) quaternaryLabelColor
kRGBA(9, 132, 255, 1.0) linkColor
kRGBA(235, 235, 245, 0.3) placeholderTextColor
kRGBA(84, 84, 88, 0.6) separatorColor
kRGBA(56, 56, 58, 1.0) opaqueSeparatorColor
kRGBA(0, 0, 0, 1.0) systemBackgroundColor
kRGBA(28, 28, 30, 1.0) secondarySystemBackgroundColor
kRGBA(44, 44, 46, 1.0) tertiarySystemBackgroundColor
kRGBA(0, 0, 0, 1.0) systemGroupedBackgroundColor
kRGBA(28, 28, 30, 1.0) secondarySystemGroupedBackgroundColor
kRGBA(44, 44, 46, 1.0) tertiarySystemGroupedBackgroundColor
kRGBA(120, 120, 128, 0.4) systemFillColor
kRGBA(120, 120, 128, 0.3) secondarySystemFillColor
kRGBA(118, 118, 128, 0.2) tertiarySystemFillColor
kRGBA(118, 118, 128, 0.2) quaternarySystemFillColor
*/
