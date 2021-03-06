//
//  UIScreen+JE.h
//  JE
//
//  Created by JE on 2017/7/6.
//  Copyright © 2017年 JE. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenHeight               ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth                ([UIScreen mainScreen].bounds.size.width)
#define kSW                        ([UIScreen mainScreen].bounds.size.width)
#define kSH                        ([UIScreen mainScreen].bounds.size.height)
#define ScreenStatusBarH           ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define ScreenNavBarH              (ScreenStatusBarH + 44.0)
#define ScreenTabBarH              (49.0)
#define ScreenSafeArea             ([UIScreen SafeAreaBottom])

#define ScreenPerH(X)              ((X)*(ScreenHeight/667.0f))
#define ScreenPerW(X)              ((X)*(ScreenWidth/375.0f))
#define ScrnAdapt(X)               ((X)*(ScreenWidth/375.0f))
#define ScrnAdaptMax(X)            (MAX((X), ((X)*(ScreenWidth/375.0f))))

#define SWidthMid(X)                ((ScreenWidth - (X))/2)

#define iPhone4_Screen             ((ScreenWidth == 320 && ScreenHeight == 480) || (ScreenHeight == 320 && ScreenWidth == 480))
#define iPhone5_Screen             (ScreenWidth == 568 || ScreenHeight == 568)
#define iPhone6_Screen             ((ScreenWidth == 375 && ScreenHeight == 667) || (ScreenHeight == 375 && ScreenWidth == 667))
#define iPhone6Plus_Screen         (ScreenWidth == 736 || ScreenHeight == 736)
//#define iPhone6_PBigger            (ScreenWidth >= 375)
#define iPhoneX_Screen             (ScreenWidth == 812 || ScreenHeight == 812)
#define iPhoneXR_Screen            ((ScreenWidth == 896 || ScreenHeight == 896) && (([UIScreen mainScreen].scale) == 2))
#define iPhoneXM_Screen            ((ScreenWidth == 896 || ScreenHeight == 896) && (([UIScreen mainScreen].scale) == 3))

//#define font(X)  ([UIFont systemFontOfSize:X])
//#define fontT(X) ([UIFont systemFontOfSize:X weight:UIFontWeightThin])
//#define fontL(X) ([UIFont systemFontOfSize:X weight:UIFontWeightLight])
//#define fontM(X) ([UIFont systemFontOfSize:X weight:UIFontWeightMedium])
//#define fontS(X) ([UIFont systemFontOfSize:X weight:UIFontWeightSemibold])
//#define fontB(X) ([UIFont systemFontOfSize:X weight:UIFontWeightBold])
#define font(X)  ([UIScreen FontSize:X weight:0])
#define fontT(X) ([UIScreen FontSize:X weight:-0.6])
#define fontL(X) ([UIScreen FontSize:X weight:-0.4])
#define fontM(X) ([UIScreen FontSize:X weight:0.23])
#define fontS(X) ([UIScreen FontSize:X weight:0.3])
#define fontB(X) ([UIScreen FontSize:X weight:0.4])

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   UIScreen   🔷 (JE)
@interface UIScreen (JE)

typedef NS_ENUM(NSUInteger, iPhoneScreenType) {
    iPhone4 = 0,    ///< 3.5inch   320×480   640x960     @2x   0.6666
    iPhone5,        ///< 4.0inch   320x568   640x1136    @2x   0.5633
    iPhone6,        ///< 4.7inch   375x667   750x1334    @2x   0.5622    iPhone7,8
    iPhone6plus,    ///< 5.5inch   414x736   1242x2208   @3x   0.5625    iPhone7,8plus
    iPhoneX,        ///< 5.8inch   375x812   1125x2436   @3x   0.4618    iPhoneXS 11pro
    iPhoneXR,       ///< 6.1inch   414x896   828x1792    @2x   0.4618    11
    iPhoneXMax,     ///< 6.5inch   414x896   1242x2688   @3x   0.4620    
};

/** [@[@(<#iPhone4#>),@(<#iPhone5#>),@(<#iPhone6,7#>),@(<#iPhone6,7plus#>),@(<#iPhoneX#>)][[UIScreen ScreenType]] floatValue] */
+ (iPhoneScreenType)ScreenType;

/** safeArea 底部距离 */
+ (CGFloat)SafeAreaBottom;

/** 全部屏幕类型分辨率 */
+ (NSArray <NSString *>*)AllScreenDPI;

/// 兼容8.0
+ (UIFont *)FontSize:(NSInteger)size weight:(CGFloat)weight;

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   NSArray   🔷 (Screen)
@interface NSArray (Screen)

/** @[@(iPhone4),@(iPhone5),@(iPhone6,7),@(iPhone6,7plus),@(iPhoneX)五种屏幕适配 */
@property (nonatomic,assign,readonly) CGFloat adaptScreen;

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   NSLayoutConstraint   🔷 (adapt)
IB_DESIGNABLE
@interface NSLayoutConstraint(adapt)

@property (nonatomic, assign) IBInspectable BOOL adaptive;

@end
