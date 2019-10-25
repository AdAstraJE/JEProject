
#import "Tab_1VC.h"
#import "JEKit.h"
#import "tempVC.h"
#import "DataBaseTestVC.h"

@implementation Tab_1VC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"J".loc;
    
    [self setupTab_1VC_UI];
    
#if TARGET_OS_SIMULATOR
JEBtn(JR(0,ScreenStatusBarH,50,44),@"test",@16,Clr_white,self,@selector(testBtnClick),Clr_orange,0,self.view);
#endif
}

- (void)testBtnClick{
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
    JEStvIt_(nil,@"DataBase", nil, 1, ^(JEStvIt *item) {
        [DataBaseTestVC ShowVC];
    }).to(arr);
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
