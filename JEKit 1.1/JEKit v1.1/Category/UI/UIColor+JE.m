
#import "UIColor+JE.h"

@implementation UIColor (JE)

#pragma mark - UIUserInterfaceStyleDark | UIUserInterfaceStyleLight  
+ (UIColor *)je_wb{return [UIColor Light:UIColor.whiteColor dark:UIColor.blackColor];}
+ (UIColor *)je_bw{return [UIColor Light:UIColor.blackColor dark:UIColor.whiteColor];}
+ (UIColor *)je_txt{
    if (@available(iOS 13.0, *)) {return UIColor.labelColor;} else {return UIColor.blackColor;}
}
+ (UIColor *)je_Tgray1{
    if (@available(iOS 13.0, *)) {return UIColor.secondaryLabelColor;} else {return kRGBA(60, 60, 67, 0.6);}
}
+ (UIColor *)je_Tgray2{
    if (@available(iOS 13.0, *)) {return UIColor.tertiaryLabelColor;} else {return kRGBA(60, 60, 67, 0.3);}
}
+ (UIColor *)je_Tgray3{
    if (@available(iOS 13.0, *)) {return UIColor.quaternaryLabelColor;} else {return kRGBA(60, 60, 67, 0.2);}
}
+ (UIColor *)je_sep{
//    if (@available(iOS 13.0, *)) {return UIColor.separatorColor;} else {return kRGBA(60, 60, 67, 0.3);}
    return [UIColor Light:[UIColor colorWithWhite:0 alpha:0.12] dark:[UIColor colorWithWhite:1 alpha:0.2]];
}
+ (UIColor *)gray1{
    return [UIColor Light:kRGBA(142, 142, 147, 1.0) dark:kRGBA(142, 142, 147, 1.0)];}
+ (UIColor *)gray2{
    return [UIColor Light:kRGBA(174, 174, 178, 1.0) dark:kRGBA(99, 99, 102, 1.0)];}
+ (UIColor *)gray3{
    return [UIColor Light:kRGBA(199, 199, 204, 1.0) dark:kRGBA(72, 72, 74, 1.0)];}
+ (UIColor *)gray4{
    return [UIColor Light:kRGBA(209, 209, 214, 1.0) dark:kRGBA(58, 58, 60, 1.0)];}
+ (UIColor *)gray5{
    return [UIColor Light:kRGBA(229, 229, 234, 1.0) dark:kRGBA(44, 44, 46, 1.0)];}
+ (UIColor *)gray6{
    return [UIColor Light:kRGBA(242, 242, 247, 1.0) dark:kRGBA(28, 28, 30, 1.0)];}
+ (UIColor *)cellBgC{
return [UIColor Light:kRGBA(255, 255, 255, 1.0) dark:kRGBA(28, 28, 30, 1.0)];}


+ (UIColor *)Light:(UIColor *)light dark:(UIColor *)dark{
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *c) {
            return (c.userInterfaceStyle == UIUserInterfaceStyleDark) ? dark : light;
        }];
    } else {
        return light;
    }
}



#pragma mark -
+ (UIColor *)Random{
    return [UIColor colorWithRed:(arc4random()%255)/255.0f green:(arc4random()%255)/255.0f blue:(arc4random()%255)/255.0f alpha:1];
}

- (UIColor *)je_Abe:(CGFloat)abe Alpha:(CGFloat)Alpha{
    CGFloat r = 0.0,g = 0.0,b = 0.0,temp = 0.0;
    [self getRed:&r green:&g blue:&b alpha:&temp];
    return [UIColor colorWithRed:r*abe green:g*abe blue:b*abe alpha:Alpha];
}

- (UIColor * (^)(CGFloat abe,CGFloat alpha))abe{
    return ^id (CGFloat abe,CGFloat alpha){
        CGFloat r = 0.0,g = 0.0,b = 0.0,temp = 0.0;
        [self getRed:&r green:&g blue:&b alpha:&temp];
        return [UIColor colorWithRed:r*abe green:g*abe blue:b*abe alpha:alpha];
    };
}

- (UIColor * (^)(CGFloat alpha))alpha_{
    return ^id (CGFloat alpha){return self.abe(1,alpha);};
}
#pragma mark - Gradient Color

+ (UIColor*)je_gradient:(NSArray <id> *)colors withSize:(CGSize)size type:(NSInteger)type{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    if ([colors.firstObject isKindOfClass:[UIColor class]]) {
        NSMutableArray *ar = [NSMutableArray array];
        for(UIColor *c in colors) {
            [ar addObject:(id)c.CGColor];
        }
        colors = ar;
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    
    CGPoint start;
    CGPoint end;
    switch (type) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            if ((size.height) == 0) { CGGradientRelease(gradient); CGColorSpaceRelease(colorspace);return nil;}
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            if ((size.width) == 0) { CGGradientRelease(gradient); CGColorSpaceRelease(colorspace);return nil;}
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            if ((size.width + size.height) == 0) { CGGradientRelease(gradient); CGColorSpaceRelease(colorspace);return nil;}
            break;
        case 3:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            if ((size.height) == 0) { CGGradientRelease(gradient); CGColorSpaceRelease(colorspace);return nil;}
            break;
        default:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            if ((size.height) == 0) { CGGradientRelease(gradient); CGColorSpaceRelease(colorspace);return nil;}
            break;
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

@end
