
#import "tempVC.h"
#import "JEKit.h"
#import "JETextField.h"
#import "JENumberAnimateLabel.h"
#import "JEPutDownMenuView.h"
#import "JEScrIndexView.h"
#import "JETranslate.h"
#import "JEWKWebviewVC.h"

@implementation tempVC{
    UIImageView *_Img;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"tempVC".loc;
    
    [self setuptempVC_UI];
    
#if TARGET_OS_SIMULATOR
    JEBtn(JR(kSW - 50,ScreenStatusBarH,50,44),@"test",@16,Clr_white,self,@selector(testBtnClick),Clr_orange,0,self.view);
#endif
}

- (void)testBtnClick{
    UIImage *img = [UIImage je_capture:self.view size:self.view.size update:YES];
    img = [img je_limitToWH:100];
//    img = img.clip(CGRectMake(0, 0, 375, 150));
    _Img.image = img;
    
    JIE1;
//    [_La_step showAnimateNumber:@(arc4random_uniform(10000))];
//    [JEPutDownMenuView ShowIn:self.view point:CGPointMake(15, ScreenNavBarH + 200) list:@[@"1",@"2"] select:^(NSString *str, NSInteger index) {
//
//    } upward:NO arrowX:0.2];
    
//    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
//    [cache.memoryCache removeAllObjects];
//    [cache.diskCache removeAllObjects];
//    [JETranslate Translate:@"我很饿"];
//    [JETranslate Translate:@"我很饿" to:@"en" done:^(JETranslateResult * _Nonnull result, NSError * _Nonnull error) {
//
//    }];
}




#pragma mark - UI

- (void)setuptempVC_UI{
    //    #define MeiZi_Categorys         (@[@"All",@"DaXiong",@"QiaoTun",@"HeiSi",@"MeiTui",@"QingXin",@"ZaHui"])
    
    self.liteTv = [JELiteTV Frame:self.tvFrame style:(UITableViewStylePlain) cellC:UITableViewCell.class cellH:100 cell:^(__kindof UITableViewCell *cell, UITableView *tv, NSIndexPath *idx, NSDictionary *dic) {
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
    } select:nil to:self.view];

    [self.liteTv listManager:nil param:nil pages:YES mod:nil superVC:self caChe:nil method:(AFHttpMethodGET) resetAPI:^NSString *(NSInteger page) {
        return Format(@"%@/%@/page/%@",@"https://meizi.leanapp.cn/category",@"QingXin",@(page));
    } sift:^NSArray *(NSDictionary *result) {
        return result[@"results"];
    }  suc:nil fail:nil];
    
}

@end

