
#import "JEBaseColVC.h"
#import "JEKit.h"

@implementation JEBaseColVC

- (void)dealloc{
    jkDeallocLog
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.view.backgroundColor == nil) {
        self.view.backgroundColor = JEShare.VCBackgroundColor;
    }
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

@end


@implementation JECollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    [self fixDelaysContentTouches];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self fixDelaysContentTouches];
    return self;
}

/** 修改有点击效果 */
- (void)fixDelaysContentTouches{
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    
    // Remove touch delay (since iOS 8)
//    UIView *wrapView = self.subviews.firstObject;
//    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {    // UITableViewWrapperView
//        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
//            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) { // UIScrollViewDelayedTouchesBeganGestureRecognizer
//                gesture.enabled = NO;
//                break;
//            }
//        }
//    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}


@end
