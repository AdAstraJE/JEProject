
#import "tempVC.h"
#import "JEKit.h"
#import "JETextField.h"
#import "JENumberAnimateLabel.h"
#import "JEPutDownMenuView.h"
#import "JEScrIndexView.h"
#import "JETranslate.h"
#import "JEWKWebviewVC.h"

@interface UIImageViewTest : UIImageView

@end

@implementation UIImageViewTest

- (void)dealloc{
    jkDeallocLog
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
//    JIE1
}

@end



@implementation tempVC{
    UIImageViewTest *_Img;
    UILabel *_La_;
    JEButton *_Btn1_;
    UIView *_Ve_container;
    UIView *_VeRed,*_VeBlue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"General".loc;
    
    //    [self setuptempVC_UI];
    [self resetNavBackBtn:@"Cancel"];
    _Btn1_ = [self rightNavBtn:@"Done" target:self act:@selector(testBtnClick)];
    
//    _La_ = JELab(JR0,@"12111111111111111111113",@12,nil,(0),self.view).jo.left(0).inCenterY().autoW(0).h(20).maxW(kSW).me;
//    [_La_ je_DebugSubView];
//    _Img = [[UIImageViewTest alloc] initWithFrame:JR0].addTo(self.view).jo.w(40).w_lock_h().top_(_La_,5).centerXSameTo(_La_).me;
//    [_Img je_DebugSubView];
    
//    _Ve_container = JEVe(JR0, nil, self.view).jo.right(12).top(100).h(40).autoW(12).me;
//    [self.view sendSubviewToBack:_Ve_container];
//    _VeRed = JEVe(JR0, UIColor.redColor, _Ve_container).jo.tb(0).left(12).w(20).me;
//    _VeBlue = JEVe(JR0, UIColor.blueColor, _Ve_container).jo.tb(0).left_(_VeRed,12).w(30).me;
    
    _Ve_container = JEVe(JR0, nil, self.view).jo.right(12).bottom(100).autoH(12).w(100) .me;
    [self.view sendSubviewToBack:_Ve_container];
    _VeRed = JEVe(JR0, UIColor.redColor, _Ve_container).jo.top(12).lr(12).h(20).me;
    _VeBlue = JEVe(JR0, UIColor.blueColor, _Ve_container).jo.top_(_VeRed,12).h_rate(_VeRed,1).lead(_VeRed,0).trall(_VeRed,0).me;
    
    [_Ve_container je_DebugSubView];
    
//    [self.navBar je_DebugSubView];

#if TARGET_OS_SIMULATOR
//    JEBtn(JR(kSW - 50,ScreenStatusBarH,50,44),@"test",@16,Clr_white,self,@selector(testBtnClick),Clr_orange,0,self.view);
#endif
}

- (void)testBtnClick{
//    [_Btn1_ setTitle:[NSString RandomStr:arc4random_uniform(5)] forState:(UIControlStateNormal)];
   
    
//    _La_.text = [NSString RandomStr:arc4random_uniform(40)];
//    _La_.jo.left(arc4random_uniform(120)).right(arc4random_uniform(120));
    
//    _Ve_container.jo.left(arc4random_uniform(120)).right(arc4random_uniform(120));
//    _VeRed.jo.w(arc4random_uniform(120));
//    _VeBlue.jo.w(arc4random_uniform(120));
    _VeRed.jo.h(arc4random_uniform(120));
//    _VeBlue.jo.h(arc4random_uniform(120));
    [_Ve_container updateLayout];
//    [_Ve_container layoutSubviews];
    
//    for (int i = 0; i < 10000; i++) {
//    _Img.jo.inCenterY().left(arc4random_uniform(100)).wh(arc4random_uniform(100), arc4random_uniform(100)).minW(20);
//    }
    
//    NSLog(@"⏰ %f",[[NSDate date] timeIntervalSinceDate:begin]);
//    JELayoutMod *mod = _Img.jo;
//    16.8 0.08
//    JELog(@"%@",mod);
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

