
#import "UIViewController+JE.h"
#import <objc/runtime.h>
#import "JEKit.h"

static NSInteger const jkNoLimitTime = -1;///< 时间不限
static CGFloat const jkHudAnimatedDuration = 1.8;///< HUD默认显示时间

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  JEHUDView : UIView   🔷🔷🔷🔷🔷🔷🔷🔷
@interface JEHUDView : UIView
@end
@implementation JEHUDView
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
    [self showHUD:nil touch:NO type:HUDMarkTypeNone delay:jkNoLimitTime];
}

/** 一直显示 HUD❊动画 和 文字 */
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

/** 显示文本  背景可点击做其他操作  默认延迟消失 */
- (void)showHUD:(NSString*)text{
    [self showHUD:text delay:jkHudAnimatedDuration];
}

- (void)showHUD:(NSString*)text delay:(CGFloat)delay{
    [self showHUD:text touch:YES type:HUDMarkTypeNone delay:delay];
}

/** 显示文本  背景可点击做其他操作 显示默认图片类型  默认延迟消失 */
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
    
    if (text) {
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

/** 显示到合理?的视图层 */
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




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  @implementation UIViewController (JEVC)   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation UIViewController (JEVC)

+ (void)load{
#ifdef DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(viewDidLoad) with:@selector(je_viewDidLoad)];
    });
#endif
}

- (void)je_viewDidLoad{
#ifdef DEBUG
    [self je_viewDidLoad];
    NSString *sbName = [[self class] __Storyboard_Name_Id__].firstObject;
    NSString *sbDesc = sbName ? [NSString stringWithFormat:@"【%@%@ - %@】",sbName ? : @"",sbName.length ? @".storyboard" : @"",sbName.length ? [[self class] __Storyboard_Name_Id__].lastObject : @""] : @"";
    NSString *className = NSStringFromClass([self class]);
    if (![className hasPrefix:@"UI"] && ![className hasPrefix:@"_UI"] && ![className hasPrefix:@"JEDebug"]) {
        [JEDebugTool__ LogSimple:JELog___(@"🍀🍀🍀 %@ : %@ %@ [* viewDidLoad]",className,NSStringFromClass([self superclass]),sbDesc) toDB:NO];
    }
#endif
    
    
}

/**  count = 2     @[@"StoryboardName",@"vcId"]   */
+ (NSArray <NSString *> *)__Storyboard_Name_Id__{
    return nil;
}

/** 统一获取 storyboard构建的 UIViewController   根据Storyboard_Name_ID获取 取不到就 [[[self class] alloc] init] */
+ (instancetype)VC{
    NSArray *sbNameId = [self __Storyboard_Name_Id__];
    if (sbNameId) {
        @try {
            UIViewController *vc = [[UIStoryboard storyboardWithName:sbNameId.firstObject bundle:nil] instantiateViewControllerWithIdentifier:sbNameId.lastObject];
            if (vc) { return vc;}
        } @catch (NSException *exception) {}
    }
    
    return [[[self class] alloc] init];
}

/** self.navigationController */
- (UINavigationController *)Nav{
    if ([self isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self;
    }
    UINavigationController *nav = self.navigationController;
    return nav ? nav : self.tabBarController.navigationController;
}

/** self.tabBarController 没有就是 self.Nav.viewControllers.firstObject */
- (UITabBarController *)Tab{
    if ([self isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)self;
    }
    UITabBarController *tab = self.tabBarController;
    return tab ? : ((self.Nav.viewControllers.firstObject) ? : self);
}

/** 导航控制器 取得对应栈上的vc*/
+ (instancetype)InNav{
    return [JEApp.window.rootViewController findVC:NSStringFromClass(self)];
}

/**  导航控制器 取得对应栈上的vc */
- (UIViewController*)findVC:(NSString*)classStr{
    if ([self.presentedViewController isKindOfClass:NSClassFromString(classStr)]) {
        return self.presentedViewController;
    }
    
    if ([self isKindOfClass:UITabBarController.class]) {
        for (UIViewController *vc in ((UITabBarController *)self).viewControllers) {
            if ([vc isKindOfClass:UINavigationController.class]) { return [vc findVC:classStr];}
            if ([vc isKindOfClass:NSClassFromString(classStr)]) { return vc;}
        }
    }
    
    UINavigationController *navigation = (UINavigationController *)self;
    if (![navigation isKindOfClass:UINavigationController.class]) {
        return nil;
    }
    
    for (UIViewController *vc in [navigation.viewControllers reverseObjectEnumerator]) {
        if ([vc isKindOfClass:UITabBarController.class]) { return [vc findVC:classStr]; }
        if ([vc isKindOfClass:NSClassFromString(classStr)]) { return vc;}
    }
    return nil;
}

/** showViewController */
+ (void)ShowVC{
    [JEApp.window.rootViewController showViewController:[self VC] sender:nil];
}

/** showViewController  顺便调 sendInfo:  传参 */
+ (instancetype)ShowVC:(id)info{
    UIViewController *vc = [[self VC] sendInfo:info];
    [JEApp.window.rootViewController showViewController:vc sender:nil];
    return vc;

}

/** showViewController; */
- (instancetype)showVC{
    [JEApp.window.rootViewController showViewController:self sender:nil];
    return self;
}

/** UIViewController 默认传参方法 */
- (instancetype)sendInfo:(id)info{
    return self;
}

/** 替换导航栏栈里最后一个vc */
- (void)je_replaceVC:(UIViewController *)vc{
    NSMutableArray *vcs = self.Nav.viewControllers.mutableCopy;
    [vcs removeLastObject];
    [vcs addObject:vc];
    [self.Nav setViewControllers:vcs animated:YES];
}

- (void)Alert:(NSString*)title msg:(NSString*)msg act:(NSArray <NSString *> *)actions destruc:(NSArray <NSString *> *)destructive _:(void(^)(NSString *act,NSInteger idx))block{
    [self Alert:title msg:msg act:actions destruc:destructive _:block cancel:@"取消".loc _:nil];
}
- (void)Alert:(NSString*)title msg:(NSString*)msg act:(NSArray <NSString *> *)actions destruc:(NSArray <NSString *> *)destructive _:(void(^)(NSString *act,NSInteger idx))block cancel:(NSString *)cancel _:(void (^)(void))cancelBlock{
    [self ShowAlert:title msg:msg style:(UIAlertControllerStyleAlert) actions:actions block:block destructive:destructive cancel:cancel cancelBlock:cancelBlock];
}
/// UIAlertControllerStyleActionSheet
- (void)Sheet:(NSString*)title msg:(NSString*)msg act:(NSArray <NSString *> *)actions destruc:(NSArray <NSString *> *)destructive _:(void(^)(NSString *act,NSInteger idx))block cancel:(NSString *)cancel _:(void (^)(void))cancelBlock{
    [self ShowAlert:title msg:msg style:(UIAlertControllerStyleActionSheet) actions:actions block:block destructive:destructive cancel:cancel cancelBlock:cancelBlock];
}

- (void)ShowAlert:(NSString*)title msg:(NSString*)msg style:(UIAlertControllerStyle)style actions:(NSArray <NSString *> *)actions block:(void(^)(NSString *act,NSInteger idx))block destructive:(NSArray <NSString *> *)destructive cancel:(NSString *)cancel cancelBlock:(void (^)(void))cancelBlock{
    __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:title  message:msg preferredStyle:style];
    
    void (^removeAlert)(void) = ^(void){
        [alert removeFromParentViewController];
        alert = nil;
    };
    
    [actions enumerateObjectsUsingBlock:^(NSString * _Nonnull btnTitle, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertActionStyle style = ([destructive containsObject:btnTitle] ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault);
        [alert addAction:[UIAlertAction actionWithTitle:btnTitle style:style handler:^(UIAlertAction * _Nonnull action) {
            !block ? : block(btnTitle,idx);
            removeAlert();
        }]];
    }];
    
    if (cancel.length) {
        [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            !cancelBlock ? : cancelBlock();
            removeAlert();
        }]];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end

