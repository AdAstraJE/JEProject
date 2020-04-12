
#import "UIViewController+JE.h"
#import <objc/runtime.h>
#import "JEKit.h"

@implementation JEAlertController
@end



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

+ (NSArray <NSString *> *)__Storyboard_Name_Id__{
    return nil;
}

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

- (UINavigationController *)Nav{
    if ([self isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self;
    }
    UINavigationController *nav = self.navigationController;
    return nav ? nav : self.tabBarController.navigationController;
}

- (UITabBarController *)Tab{
    if ([self isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)self;
    }
    UITabBarController *tab = self.tabBarController;
    return tab ? : ((self.Nav.viewControllers.firstObject) ? : self);
}

+ (instancetype)InNav{
    return [JEApp.window.rootViewController findVC:NSStringFromClass(self)];
}

- (UIViewController*)findVC:(NSString*)classStr{
    if ([self.presentedViewController isKindOfClass:NSClassFromString(classStr)]) {
        return self.presentedViewController;
    }
    
    if ([self isKindOfClass:UITabBarController.class]) {
        for (UIViewController *vc in ((UITabBarController *)self).viewControllers) {
            if ([vc isKindOfClass:UINavigationController.class]) {
                UIViewController *find = [vc findVC:classStr];
                if (find) { return find;}
            }
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

+ (void)ShowVC{
    [JEApp.window.rootViewController showViewController:[self VC] sender:nil];
}

+ (instancetype)ShowVC:(id)info{
    UIViewController *vc = [[self VC] sendInfo:info];
    [JEApp.window.rootViewController showViewController:vc sender:nil];
    return vc;
}

- (instancetype)showVC{
    [JEApp.window.rootViewController showViewController:self sender:nil];
    return self;
}

- (instancetype)sendInfo:(id)info{
    return self;
}

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

- (void)ActionSheet:(NSString*)title msg:(NSString*)msg act:(NSArray <NSString *> *)actions destruc:(NSArray <NSString *> *)destructive _:(void(^)(NSString *act,NSInteger idx))block cancel:(NSString *)cancel _:(void (^)(void))cancelBlock{
    [self ShowAlert:title msg:msg style:(UIAlertControllerStyleActionSheet) actions:actions block:block destructive:destructive cancel:cancel cancelBlock:cancelBlock];
}

- (void)ShowAlert:(NSString*)title msg:(NSString*)msg style:(UIAlertControllerStyle)style actions:(NSArray <NSString *> *)actions block:(void(^)(NSString *act,NSInteger idx))block destructive:(NSArray <NSString *> *)destructive cancel:(NSString *)cancel cancelBlock:(void (^)(void))cancelBlock{

    __block JEAlertController *alert = [JEAlertController alertControllerWithTitle:title  message:msg preferredStyle:style];
    
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

