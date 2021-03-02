
#import "tempVC.h"
#import "JEKit.h"
#import "JETextField.h"
#import "JENumberAnimateLabel.h"
#import "JEPutDownMenuView.h"
#import "JEScrIndexView.h"
#import "JETranslate.h"
#import "JEWKWebviewVC.h"


@implementation tempVC{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"General".loc;

    [self setuptempVC_UI];
    
//    [self resetNavBackBtn:@"Cancel"];
//    _Btn1_ = [self rightNavBtn:@"Done" target:self act:@selector(testBtnClick)];
//
//    _Ve_container = JEVe(JR0, nil, self.view).jo.right(12).bottom(50).h(100).w(100) .me;
//    [self.view sendSubviewToBack:_Ve_container];
    
//    _VeRed = JEVe(JR0, UIColor.redColor, _Ve_container).jo.top(12).lr(12).h(20).me;
//    _VeBlue = JEVe(JR0, UIColor.blueColor, _Ve_container).jo.top_(_VeRed,12).h_rate(_VeRed,1).lead(_VeRed,0).trall(_VeRed,0).me;
    
//    [_Ve_container je_DebugSubView];
    
//    [self.navBar je_DebugSubView];

#if TARGET_OS_SIMULATOR
//    JEBtn(JR(kSW - 50,ScreenStatusBarH,50,44),@"test",@16,Clr_white,self,@selector(testBtnClick),Clr_orange,0,self.view);
#endif
}

- (void)testBtnClick{

}




#pragma mark - UI

- (void)setuptempVC_UI{
    //    #define MeiZi_Categorys         (@[@"All",@"DaXiong",@"QiaoTun",@"HeiSi",@"MeiTui",@"QingXin",@"ZaHui"])
    self.liteTv = [self liteTv:UITableViewStylePlain cellC:UITableViewCell.class cellH:100 cell:^(__kindof UITableViewCell *cell, UITableView *tv, NSIndexPath *idx, NSDictionary *dic) {
        cell.textLabel.text = [dic str:@"title"];
               cell.textLabel.numberOfLines = 0;
               
               //         dic.str(@"thumb_url").url
               //         dic.str(@"image_url").url
               [cell.imageView setImageWithURL:[dic str:@"image_url" ].url placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                   if (from == YYWebImageFromRemote || from == YYWebImageFromDiskCache){
                       [tv reloadRowsAtIndexPaths:@[idx] withRowAnimation:(UITableViewRowAnimationNone)];
                   }
               }];
               [cell.imageView tapToshowImg];
    } select:^(UITableView * _Nonnull tv, NSIndexPath * _Nonnull idxP, id  _Nonnull obj) {
        
    }];
    
//    [self.liteTv je_Debug:nil width:4];
//    self.liteTv = [JELiteTV Frame:self.tvFrameFull style:(UITableViewStylePlain) cellC:UITableViewCell.class cellH:100 cell:^(__kindof UITableViewCell *cell, UITableView *tv, NSIndexPath *idx, NSDictionary *dic) {
//
//    } select:nil to:self.view];

    [self.liteTv listManager:nil param:nil pages:YES mod:nil superVC:self caChe:nil method:(AFHttpMethodGET) resetAPI:^NSString *(NSInteger page) {
        return Format(@"%@/%@/page/%@",@"https://meizi.leanapp.cn/category",@"QingXin",@(page));
    } sift:^NSArray *(NSDictionary *result) {
        return result[@"results"];
    }  suc:nil fail:nil];
    
}

@end

