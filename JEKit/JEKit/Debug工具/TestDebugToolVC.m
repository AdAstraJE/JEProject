
#import "TestDebugToolVC.h"
#import "JEDebugTool__.h"
#import "JEDBModel.h"
#import "JEKit.h"

@implementation TestDebugToolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self je_rightBarBtn:@"Out" target:[JEAppScheme class] act:@selector(Logout)];
    [JEDebugTool__ EnableSimulator];
    
    NSMutableArray <JESTCItem *> *arr = [NSMutableArray array];
    arr.add([JESTCItem Title:@"0.detailLog" indicator:YES select:^(JESTCItem *item) {
        [JEDebugTool__ LogTitle:@"标题" noti:@"其他不知道是什么" detail:@"详情点描述详情点描述详情点描述详情点描述详情点描述详情点描述详情点描述,缓存到历史" toDB:YES];
    }]);
    arr.add([JESTCItem Title:@"1.simpleLog" indicator:YES select:^(JESTCItem *item) {
        [JEDebugTool__ LogSimple:Format(@"%@ %@",@"简单一点的单项描述",@(arc4random())) toDB:YES];
    }]);
    
    self.staticTv.Arr_item = @[arr];
}


@end
