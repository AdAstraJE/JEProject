
#import "StaticTryThatVC.h"
#import "JEStaticTableView.h"
#import "JEKit.h"

@interface jjjjjjCell : JEStaticTVCell <JEStaticTVCellDelegate>

@end

@implementation jjjjjjCell

- (void)loadCell:(JESTCItem *)item{
    [super loadCell:item];
//    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

@end


@interface StaticTryThatVC ()

@end

@implementation StaticTryThatVC{
    JEStaticTableView *_Tv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"静态TV代码";
    [self je_rightBarBtn:@"Out" target:[JEAppScheme class] act:@selector(Logout)];
    [self je_setBackButtonTitle:@"取消"];

    _Tv = [[JEStaticTableView alloc]initWithFrame:CGRectMake(0, ScreenNavBarH, ScreenWidth, ScreenHeight - ScreenNavBarH - ScreenSafeArea)].addTo(self.view);
    
    JESTCItem *timeLine = [JESTCItem Icon:@"tab_发现2" title:@"朋友圈" desc:@"啥都没有" indicator:YES select:^(JESTCItem *item) {
        JELog(@"朋友圈");
    }];
    JESTCItem *saoyisao = [JESTCItem Icon:@"tab_摩族2" title:@"扫一扫" desc:nil indicator:YES select:^(JESTCItem *item) {
        JELog(@"扫一扫");
    }];
    JESTCItem *kanyikan = [JESTCItem Icon:@"tab_我的2" title:@"看一看" desc:nil indicator:YES select:^(JESTCItem *item) {
        JELog(@"看一看");
    }];
//    kanyikan.cellHeight = 280;
    JESTCItem *search = [JESTCItem Icon:@"tab_睡眠师2" title:@"搜一搜" desc:nil indicator:YES Switch:^(JESTCItem *item,BOOL on) {
        JELog(@"搜一搜 开关：%@",@(on));
    } on:YES select:nil];

    JESTCItem *custom = [JESTCItem Icon:@"tabbarIcon_my_h" title:@"customCell" desc:@"desc" indicator:NO customCell:jjjjjjCell.class Switch:nil on:NO height:100 select:^(JESTCItem *item) {
        JELog(@"custom");
        [StaticTryThatVC ShowVC];
    }];

    JESTCItem *logout = [JESTCItem MiddleNoti:@"退出啦" font:fontM(16) color:kColorBlue select:^(JESTCItem *item) {
        [[JEAppScheme RootVC] popViewControllerAnimated:YES];
    }];
    
    _Tv.Arr_item = @[@[timeLine],
                     @[saoyisao],
                     @[kanyikan,search,custom],
                     @[logout]].mutableCopy;
    
    [UIButton Frame:CGRectMake(0, ScreenNavBarH, 80, 44) title:@"reload" font:@18 color:kColorBlue rad:0 tar:self sel:@selector(test) img:nil].addTo(self.view);
}

- (void)test{
    _Tv.Arr_item.firstObject.lastObject.desc = [NSString RandomStr:arc4random_uniform(5)];
    _Tv.Arr_item.firstObject.lastObject.title = [NSString RandomStr:arc4random_uniform(5)];

    [_Tv reloadData];
}

@end
