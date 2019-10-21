
#import <UIKit/UIKit.h>

@class JETableView;
@class JEStaticTableView;
@class JELiteTV;

@interface JEBaseVC : UIViewController

@property (nonatomic,strong) JETableView *tableView;///< 默认的tableView
@property (nonatomic,strong) JEStaticTableView *staticTv;///< 静态 tableView （离开栈时 block会置空）
@property (nonatomic,strong) JELiteTV *liteTv;///< 默认的tableView
@property (nonatomic,assign,readonly) CGRect tvFrame;///< tableView默认Frame

/// 默认Frame的tableView创建方法 
- (JETableView *)defaultTv:(UITableViewStyle)style cell:(id)cellClass;

@end
