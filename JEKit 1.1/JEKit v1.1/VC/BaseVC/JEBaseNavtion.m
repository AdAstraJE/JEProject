
#import "JEBaseNavtion.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "JEDebugTool__.h"

@implementation JEBaseNavtion

#pragma mark -
- (BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark -
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.visibleViewController;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = NO;
    self.navigationBar.hidden = self.fd_prefersNavigationBarHidden = YES;
}

//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
//    
//}

#ifdef DEBUG
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [JEDebugTool__ SwitchONOff];
}	
#endif

@end
