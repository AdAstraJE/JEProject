
#import <UIKit/UIKit.h>

#define kSW                        ([UIScreen mainScreen].bounds.size.width)
#define kSH                        ([UIScreen mainScreen].bounds.size.height)
#define kSWMid(X)                  ((ScreenWidth - (X))/2)
#define kNavBarH44                 (44.0)

#define ScreenHeight               ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth                ([UIScreen mainScreen].bounds.size.width)
#define ScreenStatusBarH           ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define ScreenNavBarH              (ScreenStatusBarH + kNavBarH44)
#define ScreenTabBarH              (49.0)
#define ScreenSafeArea             ([UIScreen SafeAreaBottom])// 34
#define ScreenSafeAreaTop          ([UIScreen SafeAreaTop])// 44

#define ScreenPerH(X)              ((X)*(ScreenHeight/667.0f))
#define ScreenPerW(X)              ((X)*(ScreenWidth/375.0f))
#define ScrnAdapt(X)               ((X)*(ScreenWidth/375.0f))
#define ScrnAdaptMax(X)            (MAX((X), ((X)*(ScreenWidth/375.0f))))


#define iPhone4_Screen             ((ScreenWidth == 320 && ScreenHeight == 480) || (ScreenHeight == 320 && ScreenWidth == 480))
#define iPhone5_Screen             (ScreenWidth == 568 || ScreenHeight == 568)
#define iPhone6_Screen             ((ScreenWidth == 375 && ScreenHeight == 667) || (ScreenHeight == 375 && ScreenWidth == 667))
#define iPhone6Plus_Screen         (ScreenWidth == 736 || ScreenHeight == 736)
//#define iPhone6_PBigger            (ScreenWidth >= 375)
#define iPhoneX_Screen             (ScreenWidth == 812 || ScreenHeight == 812)
#define iPhoneXR_Screen            ((ScreenWidth == 896 || ScreenHeight == 896) && (([UIScreen mainScreen].scale) == 2))
#define iPhoneXM_Screen            ((ScreenWidth == 896 || ScreenHeight == 896) && (([UIScreen mainScreen].scale) == 3))

#define fontT(X) ([UIFont systemFontOfSize:X weight:UIFontWeightThin])
#define fontL(X) ([UIFont systemFontOfSize:X weight:UIFontWeightLight])
#define font(X)  ([UIFont systemFontOfSize:X])
#define fontM(X) ([UIFont systemFontOfSize:X weight:UIFontWeightMedium])
#define fontS(X) ([UIFont systemFontOfSize:X weight:UIFontWeightSemibold])
#define fontB(X) ([UIFont systemFontOfSize:X weight:UIFontWeightBold])


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   UIScreen   🔷 (JE)
@interface UIScreen (JE)

typedef NS_ENUM(NSUInteger, iPhoneScreenType) {
    iPhone4 = 0,    ///< 3.5inch   320×480   640x960     @2x   0.6666
    iPhone5,        ///< 4.0inch   320x568   640x1136    @2x   0.5633
    iPhone6,        ///< 4.7inch   375x667   750x1334    @2x   0.5622    7,8
    iPhone6plus,    ///< 5.5inch   414x736   1242x2208   @3x   0.5625    7,8plus
    iPhoneX,        ///< 5.8inch   375x812   1125x2436   @3x   0.4618    XS,11 pro
    iPhoneXR,       ///< 6.1inch   414x896   828x1792    @2x   0.4618    11,
    iPhoneXMax,     ///< 6.5inch   414x896   1242x2688   @3x   0.4620    
};

/// [@[@(<#iPhone4#>),@(<#iPhone5#>),@(<#iPhone6,7#>),@(<#iPhone6,7plus#>),@(<#iPhoneX#>),@(<#iPhoneXR#>),@(<#iPhoneXMax#>)][[UIScreen ScreenType]] floatValue]
+ (iPhoneScreenType)ScreenType;

/// safeArea 顶部距离
+ (CGFloat)SafeAreaTop;
/// safeArea 底部距离
+ (CGFloat)SafeAreaBottom;

/// 全部屏幕类型分辨率
+ (NSArray <NSString *>*)AllScreenDPI;

/// DeviceName iPhone11 Pro
+ (NSString*)DeviceName;

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   NSArray   🔷 (Screen)
@interface NSArray (Screen)

/// @[@(5),@(6,7,8),@(6,7,8plus),@(X),@(XR),@(Xplus)]6种屏幕适配
@property (nonatomic,assign,readonly) CGFloat adaptScreen;

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   NSLayoutConstraint   🔷 (adapt)
IB_DESIGNABLE
@interface NSLayoutConstraint(adapt)

@property (nonatomic, assign) IBInspectable BOOL adaptive;

@end
