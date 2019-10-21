//
//  UIColor+JE.h
//
//
//  Created by JE on 15/6/15.
//  Copyright © 2015年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+YYAdd.h"

#define kRGB(r,g,b)         ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])
#define kRGBA(r,g,b,a)      ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])
#define kHexColor(X)         ([UIColor colorWithRed:((float)((X & 0xFF0000) >> 16))/255.0 green:((float)((X & 0xFF00) >> 8))/255.0 blue:((float)(X & 0xFF))/255.0 alpha:1.0])
#define kHexColorA(X,A)      ([UIColor colorWithRed:((float)((X & 0xFF0000) >> 16))/255.0 green:((float)((X & 0xFF00) >> 8))/255.0 blue:((float)(X & 0xFF))/255.0 alpha:A])


#define kColorBackground    (kRGB(244, 245, 246))
#define kColorWhite         ([UIColor whiteColor])

#define kColorBlue          (kHexColor(0x007AFF))//系统蓝
#define kColorLightBlue     (kHexColor(0x5ac8fa))
#define kColorYellow        (kHexColor(0xffcc00))
#define kColorOrange        (kHexColor(0xff9500))
#define kColorPink          (kHexColor(0xff2d55))
#define kColorGreen         (kHexColor(0x4cd964))
#define kColorRed           (kHexColor(0xff3b30))

#define kColorText          (kHexColor(0x202020))
#define kColorText33        (kHexColor(0x333333))
#define kColorText66        (kHexColor(0x666666))
#define kColorText99        (kHexColor(0x999999))
#define kColorTextC8        (kHexColor(0xC8C8C8))


@interface UIColor (JE)

/** 随机颜色 */
+ (UIColor *)Random;

/** 该颜色色差后的颜色 eg. 差别0.618 透明0.9 */
- (UIColor *)je_Abe:(CGFloat)abe Alpha:(CGFloat)Alpha;

/** (id)color.CGColor ！！！！！    渐变 type 0=上到下 1=左到右 2=左上到右下 3=右上到左下 */
+ (UIColor*)je_gradient:(NSArray <id> *)colors withSize:(CGSize)size type:(NSInteger)type;

/** 渐变 */
+ (UIColor*)je_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withSize:(CGSize)size type:(NSInteger)type;

@end
