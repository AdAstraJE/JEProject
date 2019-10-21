
#import "OtherTestVC.h"
#import "JECircleProgressView.h"
#import "JETranslate.h"
#import "MeiZiVC.h"
#import "UIImageView+WebCache.h"
#import "JEKit.h"

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷    SettingCell   🔷🔷🔷🔷🔷🔷🔷🔷

@interface SettingCell : UITableViewCell

@end

@implementation SettingCell{
    UILabel *_La_title;
    UIImageView *_Img_;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _La_title = JELa(JR(15,0,300,20),nil,@14,kColorRed,(0),self.contentView);
    _Img_ = JEImg(JR(_La_title.x,_La_title.bottom,50,50),nil,self.contentView);
    return self;
}

- (instancetype)je_loadCell:(NSDictionary *)dic{
    _La_title.text = [dic str:@"title"];
    [_Img_ sd_setImageWithURL:[dic str:@"image_url"].url];
    return self;
}

@end


@implementation OtherTestVC{
    NSMutableArray <NSString *> *_Arr_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    JELiteTV *tv = [[JELiteTV alloc] initWithFrame:self.tvFrame style:1 cell:[SettingCell class] cellH:70].addTo(self.view);
    
    JELiteTV *tv = [JELiteTV F:self.tvFrame style:1 cellC:[SettingCell class] cellH:70 cell:nil select:^(UITableView *tv, NSIndexPath *idx, id obj) {
        
    }].addTo(self.view);

//    UIView *head = [UIView Frame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/320*240) color:nil];
//    [UIImageView F:head.bounds name:@"ic_ghost"].addTo(head);
//    tv.tableHeaderView = head;
//    tv.headExpandEffect = YES;
    
//    while (tv.Arr.count < 10) {[tv.Arr addObject:@{@"title" : [NSString RandomUserName]}];}
    
    tv.ListManager = [[JEListManager alloc] initWithAPI:nil param:@{@"category" : @"All"} pages:YES Tv:tv Arr:tv.Arr VC:self modClass:nil cacheKey:@"MeiZi" method:AFHttpMethodGET suc:^(NSDictionary *res, NSInteger Page, UITableView *table) {
        NSArray *arr = (NSArray *)res;
        if (res.isDict) { arr = res[@"results"]; }
        [table.ListManager defaultHandleListArr:arr];
    } fail:nil];
    
    tv.ListManager.block_resetAPI = ^NSString *(NSInteger page) {
        return Format(@"%@/%@/page/%@",API_MeiZi,@"All",@(page));
    };
    [tv.ListManager startNetworking];
    
    
    
//    tv.sections = ^NSInteger(UITableView *tv) {
//        return tv.Arr.count;
//    };
    
//    tv.rows = ^NSInteger(UITableView *tv, NSInteger section) {
//        return section ? 3 : 2;
//    };
//        tv.rows = ^NSInteger(UITableView *tv, NSInteger section) {
//            return section ? 3 : 2;
//        };
    
//    tv.rowH = ^CGFloat(UITableView *tv, NSIndexPath *idx) {
//        return idx.row*20 + 20;
//    };
    
//        tv.cell = ^(SettingCell *cell, UITableView *tv, NSIndexPath *idx, NSString *obj) {
//        cell.La_title.text = [NSString stringWithFormat:@"%d-%d",(int)idx.section,(int)idx.row];
//        cell.La_title.text = obj;
//    };
    
//    tv.cells = ^UITableViewCell *(UITableView *tv, NSIndexPath *idx) {
//        if (idx.row == 0) {
//            SettingCell *cell = [tv dequeueReusableCellWithIdentifier:[SettingCell ClassName] forIndexPath:idx];
//            [cell je_loadCell:tv.Arr[idx.row]];
//            return cell;
//        }
//        JEStaticTVCell *cell = [tv dequeueReusableCellWithIdentifier:[JEStaticTVCell ClassName] forIndexPath:idx];
//        cell.La_title.text = tv.Arr[idx.row];
//        return cell;
//    };
//    tv.select = ^(UITableView *tv, NSIndexPath *idx, id obj) {
//        JELog(@"%@",obj);
//    };

//    JEBtn(JR(100, ScreenNavBarH, 50, 50),@"ble",@15,nil,self,@selector(bletest),kColorBlue,0,self.view).touchs(20,20,20,20);
}

@end
