
#import "JEVisualEffectView.h"

@implementation JEVisualEffectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self resetEffect];
    return self;
}

- (void)resetEffect{
    BOOL dark = NO;
    if (@available(iOS 13.0, *)) {dark = (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);}
    self.effect = [UIBlurEffect effectWithStyle:dark ? UIBlurEffectStyleDark : UIBlurEffectStyleExtraLight];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    [self resetEffect];
}

@end
