
#import "UIColor+JE.h"

@implementation UIColor (JE)

+ (UIColor *)Random{
    return [UIColor colorWithRed:(arc4random()%255)/255.0f green:(arc4random()%255)/255.0f blue:(arc4random()%255)/255.0f alpha:1];
}

- (UIColor *)je_Abe:(CGFloat)abe Alpha:(CGFloat)Alpha{
    CGFloat R = 1, G = 1 , B = 1;
    CGColorRef colorRef = [self CGColor];
    int numComponents = (int)CGColorGetNumberOfComponents(colorRef);
    if (numComponents == 4){
        const CGFloat *components = CGColorGetComponents(colorRef);
        R = components[0];
        G = components[1];
        B = components[2];
    }
    
    return [UIColor colorWithRed:R*abe green:G*abe blue:B*abe alpha:Alpha];
}

#pragma mark - Gradient Color

+ (UIColor*)je_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withSize:(CGSize)size type:(NSInteger)type{
    return [self je_gradient:[NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil] withSize:size type:type];
}

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
