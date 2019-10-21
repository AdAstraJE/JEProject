
#import "MeiZi_tabbar_zi.h"
#import "MeiZi_tabbar_mei.h"
#import "MeiZiVC.h"
#import "JEKit.h"


@interface MeiZi_tabbar_zi ()

@end

@implementation MeiZi_tabbar_zi

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"<NuLl>";
    
    //eg. 接口返回格式 统一有 code msg  和 results  ,只要获得里面的 results
    [[JENetWorking Shared] setHandleInfoSucBlock:^NSDictionary *(NSDictionary *obj, UIViewController *vc) {
        
        if (obj[@"category"] != nil ) {//XXXXX算成功
            //            NSLog("\n%@",obj[@"category"]);
            return obj[@"results"] ? : @{};
        }
        
        [vc showHUD:(obj[@"errorMsg"] ? : @"服务器繁忙!") type:HUDMarkTypefailure];
        return @{};
    }];
    
    
    CGFloat btnW = 44;
    [self.view addSubview:[UIButton Frame:CGRectMake((ScreenWidth - btnW),ScreenStatusBarH, btnW, btnW) title:nil font:nil color:kColorText33 rad:0 tar:[MeiZiVC class] sel:@selector(ShowVC) img:@"tabbarIcon_my_h"]];
    
    [self.view addSubview:[JEButton Frame:CGRectMake((ScreenWidth - btnW*2)/2,ScreenHeight/4, btnW*2, btnW) title:@"妹子" font:@15 color:[UIColor whiteColor] rad:btnW tar:self sel:@selector(netClick:) img:kColorText66]];
    
    [self.view addSubview:({
        JEFrameBtn *gun = [[JEFrameBtn alloc] initWithFrame:CGRectMake((ScreenWidth - btnW*3)/2, ScreenHeight/1.5, btnW*3, btnW*2)
                                                       imgF:CGRectMake(btnW, 0, btnW, btnW) titF:CGRectMake(0, btnW, btnW*3, btnW)
                                                      title:@"你完蛋了，我告诉你。" font:@14 color:kColorText66 rad:0
                                                        tar:[JEAppScheme class] sel:@selector(Logout) img:@"gungun"];
        gun;
    })];
}

- (void)netClick:(JEButton*)sender{
//    MeiZiUser *user = (MeiZiUser *)[JEAppScheme User];
//    
//    JIE1
//    return;
    [sender coverLoading];

    delay(0.5, ^{
        [self GET:Format(@"%@/All/page/1",API_MeiZi) param:nil cache:^JECacheType(NSDictionary *cache) {
            JELog(@"缓存的 == cache.count %d",(int)cache.count);
            //        NSLog(@"%@",[cache modelDescription]);;
            return JECacheTypeDisk;
        } done:^(NSDictionary *object,NSInteger errorCode) {
            JELog(@"请求完成的 : %@",object.allKeys);
            [sender stopLoading];
            
        } suc:^(NSDictionary *result) {
            JELog(@"🔵 请求完成 进入 setHandleInfoSucBlock 后的 : %@",NSStringFromClass([result class]));
            
            //字典生成 模型代码
            NSString *code = [(((NSArray *)result)[arc4random_uniform((int)result.count)]) je_propertyCodeYY:@"MeiZi_Mod"];
            [JEKit ShowAlert:@"看控制台打印妹子了" msg:code style:UIAlertControllerStyleActionSheet block:nil cancel:nil actions:@[@"I See"] destructive:nil];
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            JIE1;
            [sender stopLoading];
            
        }];
        
    });
}

@end
