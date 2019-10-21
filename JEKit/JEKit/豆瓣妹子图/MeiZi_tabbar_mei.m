
#import "MeiZi_tabbar_mei.h"
#import "MeiZiVC.h"
#import "JEScrIndexView.h"
#import "JEKit.h"

@implementation MeiZiUser

+ (UIViewController *)HandleRootVC{
    NSMutableArray <UIViewController *> *VCs = [NSMutableArray array];
    NSArray *ImgNames = @[@[@"tabbarIcon_my".img,@"tabbarIcon_my_h".img],@[@"tabbarIcon_my".img,@"tabbarIcon_my_h".img]];
    for (int i = 0; i < 2; i++) {
        [VCs addObject:[NSClassFromString([NSString stringWithFormat:@"MeiZi_tabbar_%@",@[@"mei",@"zi"][i]]) VC]];
//        VCs.lastObject.view.autoresizingMask = UIViewAutoresizingNone;
    }
    
    JETabbarController *tabbar = [[JETabbarController alloc] initWithVCs:VCs titles:@[@"图",@"片"] imgs:ImgNames theme:^(JETabbarController *_) {
        _.je_navBarColor = [UIColor redColor];
        _.je_navBarItemColor = [UIColor whiteColor];
    }];
    return tabbar;
}

+ (void)WillSetRootVC{
    [[JEAppScheme RootVC] setDifferentStatusBarStyleWithVCClass:@[[MeiZiVC class]]];
}

@end


#pragma mark - 🔵 ====== ====== @interface vc1 ====== ====== 🔵

@implementation MeiZi_tabbar_mei

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DeMo不给看";
    
    JEScrIndexView *_ = [[JEScrIndexView alloc]initWithFrame:CGRectMake(0, ScreenNavBarH, ScreenWidth, ScreenHeight - 64) lazyLoadView:^UIViewController *(NSInteger index) {
        MeiZiVC *vc = [[MeiZiVC VC] sendInfo:@(index)];
        vc.view.y -= ScreenNavBarH;
        return vc;
    }].addTo(self.view);
    
    _.tintColore = [UIColor Random];
    _.titleColore = [UIColor Random];
    [_ loadTitles:MeiZi_CategorysNames];

}

@end
    
