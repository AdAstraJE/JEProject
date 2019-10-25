
#import "UIColor+JE.h"

@implementation UIColor (JE)

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
