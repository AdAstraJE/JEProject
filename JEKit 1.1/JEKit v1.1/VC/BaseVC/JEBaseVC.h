
#import <UIKit/UIKit.h>
@class JETableView;
@class JEStaticTableView;
@class JELiteTV;
@class JEButton;

@interface JEBaseVC : UIViewController

@property (nonatomic,strong) UIColor *backgroundColor;///< 

#pragma mark - navBar
@property (nonatomic,assign) BOOL disableNavBar;///< 不使用自定义navBar ### NO
@property (nonatomic,strong)  UIView *navBar;///< 自定义导航栏
@property (nonatomic,strong)  UIView *navBarline;///< 导航栏底部线条
@property (nonatomic,strong)  UILabel *navTitleLable;///< 标题label
@property (nonatomic,strong)  JEButton *navBackButton;///< 返回按钮

/// 导航栏返回键点击事件 可重写控制返回
- (void)navBackButtonClick;

/// 设置返回键标题
- (JEButton *)leftNavBtn:(id)item;

/// 导航栏右边按钮
- (JEButton *)rightNavBtn:(id)item target:(id)target act:(SEL)selector;


#pragma mark -
@property (nonatomic,assign,readonly) CGRect tvFrame;///< tableView默认Frame
@property (nonatomic,strong) JETableView *tableView;///< 默认的tableView
@property (nonatomic,strong) JELiteTV *liteTv;///< 默认的tableView
@property (nonatomic,strong) JEStaticTableView *staticTv;///< 静态 tableView 

/// 默认Frame的tableView创建方法 
- (JETableView *)defaultTv:(UITableViewStyle)style cell:(id)cellClass;

/// 黑暗模式
- (void)handelStyleDark;

@end
