
#import "Tab_1VC.h"
#import "JEKit.h"
#import "tempVC.h"
#import "DataBaseTestVC.h"
#import "JEWKWebviewVC.h"
#import "UIDevice+YYAdd.h"
#import "JEBaseBackView.h"

#import "JEBluetooth+Category.h"
#import "JEBLEDevice.h"
#import "JEBluetooth.h"

@implementation Tab_1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JE".loc;
    
    [self setupTab_1VC_UI];
    
#if TARGET_OS_SIMULATOR
JEBtn(JR(0,ScreenNavBarH,50,44),@"test",@16,Clr_white,self,@selector(testBtnClick),Clr_orange,0,self.view);
#endif
}

- (void)testBtnClick{
//    self.staticTv.backgroundColor = UIColor.redColor;
//    [JEInputView Show];
//    JELog(@"%@",[NSByteCountFormatter stringFromByteCount:32423488 countStyle:NSByteCountFormatterCountStyleFile]);
    
    
//    [Tab_1VC ShowVC];
//    [self showHUD];
//    JEApp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
//    [JEApp.window.layer je_fade];

//    [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JESecret" ofType:@"plist"]];

//    NSDictionary *dic1 = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"JEResource" ofType:@"bundle"]] pathForResource:@"JEAddress" ofType:@"plist"]];
    
    
//    NSDictionary *dic2 = [NSDictionary dictionaryWithContentsOfFile:JEBundleImg(@"JEAddress.plist")];
//    JEBundleImg(@"JEAddress.plist")
    JIE1;
}



#pragma mark - UI

- (void)setupTab_1VC_UI{
    NSMutableArray <NSString *> *arr = [NSMutableArray array];
    JEStvIt_(nil,@"JEKit", nil, 1, ^(JEStvIt *item) {
        [tempVC ShowVC];
    }).to(arr);
    JEStvIt *DataBase = JEStvIt_(nil,@"DataBase", @"DataBase", 1, ^(JEStvIt *item) {
        [DataBaseTestVC ShowVC];
    }).to(arr);
    JEStvIt_(nil,@"pre", nil, 1, ^(JEStvIt *item) {
        [JEApp.window.rootViewController presentViewController:tempVC.VC animated:YES completion:nil];
    }).to(arr);
    JEStvIt_(nil,@"pre full", nil, 1, ^(JEStvIt *item) {
        tempVC *vc = tempVC.VC;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [JEApp.window.rootViewController presentViewController:vc animated:YES completion:nil];
    }).to(arr);
    DataBase.detail = @"数据库";
    
    self.staticTv.Arr_item = @[arr];
    
//    self.liteTv = [JELiteTV Frame:self.tvFrame style:0 cellC:UITableViewCell.class cellH:80 cell:^(__kindof UITableViewCell * _Nonnull cell, UITableView * _Nonnull tv, NSIndexPath * _Nonnull idxP, id  _Nonnull obj) {
//        cell.textLabel.text = Format(@"%@",idxP);
//    } select:^(UITableView * _Nonnull tv, NSIndexPath * _Nonnull idxP, id  _Nonnull obj) {
//
//    } to:self.view];
//    self.liteTv.Arr = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""].mutableCopy;
//    [self.liteTv reloadData];
    

}



@end
