
#import "MeiZiVC.h"
#import "UIImageView+YYWebImage.h"
#import "JEPutDownMenuView.h"
#import "YYPhotoGroupView.h"
#import "MeiZi_tabbar_zi.h"
#import "MeiZi_tabbar_mei.h"
#import "JEKit.h"

#pragma mark - 🔵 ====== ====== @interface MeiZi_Mod : NSObject ====== ====== 🔵
@interface MeiZi_Mod : NSObject

@property (nonatomic,copy) NSString  * title; ///< 情侣睡衣。
@property (nonatomic,copy) NSString  * objectId; ///< 586fc1478d6d81005880b6bd
@property (nonatomic,copy) NSString  * group_url; ///< http://www.dbmeinv.com/dbgroup/1086548
@property (nonatomic,copy) NSString  * image_url; ///< http://ww2.sinaimg.cn/large/0060lm7Tgw1fbgrd7sauhj30dw0oo0vg.jpg
@property (nonatomic,copy) NSString  * category; ///< MeiTui
@property (nonatomic,copy) NSString  * thumb_url; ///< http://ww2.sinaimg.cn/small/0060lm7Tgw1fbgrd7sauhj30dw0oo0vg.jpg

@end

@implementation MeiZi_Mod

@end


#pragma mark - 🔵 ====== ====== @interface MeiZiVC ====== ====== 🔵
@interface MeiZiVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *Col_MeiZi;
@property (nonatomic,assign) NSInteger currentCategorysIndex;

@end

@implementation MeiZiVC
+ (NSArray<NSString *> *)__Storyboard_Name_Id__{return SBId_Main(@"妹子呀");};

- (instancetype)sendInfo:(NSNumber*)info{
    _currentCategorysIndex = info.integerValue;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.Col_MeiZi.contentInset = UIEdgeInsetsMake(0, 0, ScreenNavBarH, 0);
    
    [self.Ve_jeNavBar addSubview:[UIButton Frame:CGRectMake((ScreenWidth - 120)/2,ScreenStatusBarH, 120, 44) title:MeiZi_CategorysNames[_currentCategorysIndex] font:font(20) color:[UIColor whiteColor] rad:0 tar:self sel:@selector(chooseCategorys:) img:nil]];
    
    _Col_MeiZi.ListManager = [[JEListManager alloc] initWithAPI:nil param:@{@"category" : MeiZi_Categorys[_currentCategorysIndex]} pages:YES Tv:_Col_MeiZi Arr:_Col_MeiZi.Arr VC:self modClass:[MeiZi_Mod class] cacheKey:@"MeiZi" method:AFHttpMethodGET suc:^(NSDictionary *res, NSInteger Page, UITableView *table) {
        NSArray *arr = (NSArray *)res;
        if (res.isDict) { arr = res[@"results"]; }
        [table.ListManager defaultHandleListArr:arr];//测试不给看
        
    } fail:nil];
    
    WSELF
    _Col_MeiZi.ListManager.block_resetAPI = ^NSString *(NSInteger page) {
        return Format(@"%@/%@/page/%@",API_MeiZi,(MeiZi_Categorys[wself.currentCategorysIndex]),@(page));
    };
    [_Col_MeiZi.ListManager startNetworking];
}

//选择类型
- (void)chooseCategorys:(UIButton*)sender{
    [JEPutDownMenuView ShowIn:self.view Point:CGPointMake(sender.x, sender.bottom) List:MeiZi_CategorysNames Click:^(NSString *str, NSInteger index) {
        [sender setTitle:(MeiZi_CategorysNames[self->_currentCategorysIndex = index]) forState:UIControlStateNormal];
        [self->_Col_MeiZi.mj_header beginRefreshing];
    }];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [collectionView emptyeInfo:@"啊，不，没有妹子~" image:@"tabbarIcon_my"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MeiZi_Mod *mod = collectionView.Arr[indexPath.row];
//    [[cell ImageViewWithTag:1] setImageWithURL:mod.thumb_url.url placeholder:nil];//只试接口 不看妹子🤔
    [cell labelWithTag:2].text = mod.title;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-4)/3,(ScreenWidth-4)/3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MeiZi_Mod *mod = collectionView.Arr[indexPath.row];
    
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView = [[collectionView cellForItemAtIndexPath:indexPath] ImageViewWithTag:1];
    item.largeImageURL = mod.image_url.url;
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    [v presentFromImageView:item.thumbView toContainer:JEApp.window animated:YES completion:nil];//🙄
}

@end
