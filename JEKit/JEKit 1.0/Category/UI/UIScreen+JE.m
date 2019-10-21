
#import "UIScreen+JE.h"
#import <objc/runtime.h>


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   UIScreen   🔷 (JE)
@implementation UIScreen (JE)

/** [@[@(<#iPhone4#>),@(<#iPhone5#>),@(<#iPhone6,7#>),@(<#iPhone6,7plus#>),@(<#iPhoneX#>)][[UIScreen ScreenType]] floatValue] */
+ (iPhoneScreenType)ScreenType{
    if (iPhone4_Screen) { return iPhone4;}
    else if (iPhone5_Screen){ return iPhone5;}
    else if (iPhone6_Screen){ return iPhone6; }
    else if (iPhone6Plus_Screen){ return iPhone6plus; }
    else if (iPhoneX_Screen){ return iPhoneX; }
    else if (iPhoneXR_Screen){ return iPhoneXR;}
    else if (iPhoneXM_Screen){ return iPhoneXMax;}
    else{ return iPhone6;}
}

/** safeArea 底部距离 */
+ (CGFloat)SafeAreaBottom{
    if (@available(iOS 11.0, *)) {
        return [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
    }
    return 0.0;
}

/** 全部屏幕类型尺寸 */
+ (NSArray <NSString *>*)AllScreenDPI{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:NSStringFromCGSize(CGSizeMake(640, 960))];
    [arr addObject:NSStringFromCGSize(CGSizeMake(640, 1136))];
    [arr addObject:NSStringFromCGSize(CGSizeMake(750, 1334))];
    [arr addObject:NSStringFromCGSize(CGSizeMake(1242, 2208))];
    [arr addObject:NSStringFromCGSize(CGSizeMake(1125, 2436))];
    [arr addObject:NSStringFromCGSize(CGSizeMake(828, 1792))];
    [arr addObject:NSStringFromCGSize(CGSizeMake(1242, 2688))];
    return arr;
}



//[[UIScreen AllScreenDPI] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//    CGSize size = CGSizeFromString(obj);
//    UIImage *image = [UIImage je_GradualColors:@[kHexColor(0x007E86),kHexColor(0x2D264E)] size:size type:ImageJEGradualType4];
//    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@x%@.png",@((int)size.width),@((int)size.height)]];
//    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
//    JELog(@"%@",filePath);
//}];

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   NSArray   🔷 (Screen)
@implementation NSArray (Screen)

- (CGFloat)adaptScreen{
    NSInteger index = [UIScreen ScreenType];
    if (index >= self.count) {
        return [self.lastObject floatValue];
    }
    return [self[[UIScreen ScreenType]] floatValue];
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   NSLayoutConstraint   🔷 (adapt)

NS_INLINE  CGFloat _adaptSizeRate(){
    static CGFloat _rate = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rate = [UIScreen mainScreen].bounds.size.width / 375.0;
    });
    return _rate;
}

@implementation NSLayoutConstraint(adapt)

- (void)setAdaptive:(BOOL)widthAdaptive {
    if (widthAdaptive) {
        CGFloat _cons = self.constant;
        _cons = _cons * _adaptSizeRate();
        self.constant = _cons;
    }
    objc_setAssociatedObject(self, @selector(adaptive), @(widthAdaptive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)adaptive {
    NSNumber *value = objc_getAssociatedObject(self, @selector(adaptive));
    return [value boolValue];
}

@end
