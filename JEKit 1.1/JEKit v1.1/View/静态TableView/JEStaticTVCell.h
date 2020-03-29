
#import <UIKit/UIKit.h>
#import "JEStvIt.h"
#import "JETableView.h"

@interface JEStaticTVCell : JETableViewCell

@property (nonatomic,strong) UIImageView *Img_icon;///< 默认图标
@property (nonatomic,strong) UILabel *La_title;///< 标题
@property (nonatomic,strong) UILabel *La_detail;///< 标题下面的描述
@property (nonatomic,strong) UILabel *La_desc;///< 右边的描述
@property (nonatomic,strong) UISwitch *Swi;///< 开关

- (void)resetTitleDescFrame;

@end
