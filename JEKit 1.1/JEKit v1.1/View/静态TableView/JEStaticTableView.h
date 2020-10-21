
#import "JEStaticTVCell.h"
#import "JETableView.h"

@interface JEStaticTableView : JETableView

@property (nonatomic,strong) NSArray <NSArray <JEStvIt *> *> *Arr_item;///< 静态item 静态cell不复用

@property (nonatomic,strong) NSArray <NSString *> *Arr_headerTitle;///< ### nil
@property (nonatomic,strong) NSArray <NSString *> *Arr_footerTitle;///< ### nil
@property (nonatomic,assign) NSInteger adjustHeaderHeight;///< 根据headerTitle重新调正headerHeight ### 0 ,有headerTitle时 14
@property (nonatomic,assign) NSInteger adjustFooterHeight;///< 根据footerTitle重新调正footerHeight ### 0 ,有footerTitle时 14

@end
