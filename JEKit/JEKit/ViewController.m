
#import "ViewController.h"
#import "TestDebugToolVC.h"
#import "MeiZi_tabbar_mei.h"
#import "StaticTryThatVC.h"
#import "OtherTestVC.h"
#import "DataBaseTestVC.h"
#import "JEWKWebviewVC.h"

#import "JEKit.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JEKit";
    
    [JEDataBase SharedDbName:@"JEKit"];
    JEShare.HUDColor = kColorText;
    
    
    NSMutableArray <JESTCItem *> *a0 = [NSMutableArray array],*a1 = [NSMutableArray array];
    a0.add([JESTCItem Title:@"其他测试" indicator:YES select:^(JESTCItem *item) {
        [OtherTestVC ShowVC];
    }]);
    
    a1.add([JESTCItem Title:@"Debug工具" indicator:YES select:^(JESTCItem *item) {
        JEApp.window.rootViewController = [[JEBaseNavtion alloc] initWithRootViewController:[TestDebugToolVC VC] theme:^(UIViewController *_) {
            _.je_navBarColor = (kRGB(47, 174, 133));
        }];
        [JEApp.window.layer je_fade];
    }]);
    
    a1.add([JESTCItem Title:@"MeiZi" indicator:YES select:^(JESTCItem *item) {
        NSDictionary *dic = @{@"name" : @"name",@"userId" : @"userId"};
        NSString *account = @"accountMeiZi";
        NSString *password = @"123456";
        
        MeiZiUser *user = [MeiZiUser modelWithJSON:dic];
        [JEAppScheme LoginAccount:account password:password user:user];
    }]);
    a1.add([JESTCItem Title:@"打开网页" indicator:YES select:^(JESTCItem *item) {
        [JEWKWebviewVC Open:@"https://gitee.com/"];
    }]);
    a1.add([JESTCItem Title:@"静态TV代码" indicator:YES select:^(JESTCItem *item) {
        [StaticTryThatVC ShowVC];
    }]);
    a1.add([JESTCItem Title:@"数据库测试" indicator:YES select:^(JESTCItem *item) {
        [DataBaseTestVC ShowVC];
    }]);

    
    self.staticTv.Arr_item = @[a0,a1];
    
}

@end
