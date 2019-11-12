
#import "UIViewController+JEHUD.h"
#import "JEKit.h"

static NSInteger const jkNoLimitTime = -1;///< 时间不限
static CGFloat const jkHudAnimatedDuration = 1.8;///< HUD默认显示时间

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  JEHUDView : UIView   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEHUDView : UIView
@end

@implementation JEHUDView
/// 允许点返回键
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return !CGRectContainsPoint(CGRectMake(0, 0, ScreenWidth*0.3, ScreenNavBarH), point);
}
@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  @implementation UIViewController (JEHUD)   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation UIViewController (JEHUD)


- (JEHUDView *)HUDView{
   JEHUDView *hudview = objc_getAssociatedObject(self, _cmd);
    if (hudview == nil) {
        hudview = [JEHUDView Frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) color:[UIColor clearColor]].addTo(self.view);
        self.HUDView = hudview;
    }
    [self.view bringSubviewToFront:hudview];
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHUDView:(UIView *)HUDView{objc_setAssociatedObject(self, @selector(HUDView), HUDView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}

- (MBProgressHUD *)HUD{ return objc_getAssociatedObject(self, _cmd);}
- (void)setHUD:(MBProgressHUD *)HUD{ objc_setAssociatedObject(self, @selector(HUD), HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}

- (void)showHUD{
    [self showHUD:@"" touch:NO type:HUDMarkTypeNone delay:jkNoLimitTime];
}

- (void)showHUDLabelText:(NSString*)text{
    [self showHUDLabelText:text delay:jkNoLimitTime];
}

- (void)showHUDLabelText:(NSString*)text delay:(CGFloat)delay{
    self.HUD.delegate = nil;
    [self.HUD hideAnimated:YES];
    
    MBProgressHUD *HUD = [self defaultHUD];
    HUD.userInteractionEnabled = YES;
    HUD.label.text = text;
    if (delay != jkNoLimitTime) {
        [HUD hideAnimated:YES afterDelay:delay];
    }
  
    [self setHUD:HUD];
}

- (void)showHUD:(NSString*)text{
    [self showHUD:text delay:jkHudAnimatedDuration];
}

- (void)showHUD:(NSString*)text delay:(CGFloat)delay{
    [self showHUD:text touch:YES type:HUDMarkTypeNone delay:delay];
}

- (void)showHUD:(NSString*)text type:(HUDMarkType)type{
    [self showHUD:text type:type delay:jkHudAnimatedDuration];
}

- (void)showHUD:(NSString*)text type:(HUDMarkType)type delay:(CGFloat)delay{
    [self showHUD:text touch:YES type:type delay:delay];
}

- (void)showHUD:(NSString*)text touch:(BOOL)touch type:(HUDMarkType)type delay:(CGFloat)delay{
    if (delay == 0) {
        delay = jkHudAnimatedDuration;
    }
    self.HUD.delegate = nil;
    [self.HUD hideAnimated:YES];

    MBProgressHUD *HUD = [self defaultHUD];
    HUD.userInteractionEnabled = !touch;
    self.HUDView.userInteractionEnabled = !touch;
    
    if (text.length) {
        HUD.mode = MBProgressHUDModeText;
        (text.length > 10) ? (HUD.detailsLabel.text = text) : (HUD.label.text = text);
    }

    if (type != HUDMarkTypeNone) {
        HUD.mode = MBProgressHUDModeCustomView;
        NSDictionary *dic = @{@(HUDMarkTypeSuccess) : @"ic_markSuc",@(HUDMarkTypefailure) : @"ic_markFail",@(HUDMarkTypeNetError) : @"ic_markNetError",@(HUDMarkTypeSystemBusy) : @"ic_markSystemBusy"};
        HUD.customView = [[UIImageView alloc] initWithImage:JEBundleImg(dic[@(type)])];
    }

    if (delay != jkNoLimitTime) {
        [HUD hideAnimated:YES afterDelay:delay];
    }

    [self setHUD:HUD];
}

- (MBProgressHUD *)defaultHUD{
    MBProgressHUD *HUD;
    if ([self isKindOfClass:[UITableViewController class]] || [self isKindOfClass:[UICollectionView class]]) {
        HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }else  if ([self isKindOfClass:[UINavigationController class]]) {
        HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }else {
        HUD = [MBProgressHUD showHUDAddedTo:self.HUDView animated:YES];
        self.HUDView.hidden = NO;
    }
    HUD.delegate = (id<MBProgressHUDDelegate>)self;
    HUD.offset = CGPointMake(HUD.offset.x, HUD.offset.y - ScreenNavBarH);
    HUD.contentColor = [UIColor whiteColor];
    if (JEShare.HUDClr) {
        HUD.bezelView.color = JEShare.HUDClr;
    }
//    HUD.bezelView.layer.cornerRadius = 6.5;
    return HUD;
}

- (void)hideHud{
    [[self HUD] hideAnimated:YES];
    self.HUDView.hidden = YES;
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    self.HUDView.hidden = YES;
}

@end
