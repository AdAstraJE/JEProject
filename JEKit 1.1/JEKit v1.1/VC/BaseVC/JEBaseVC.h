
#import <UIKit/UIKit.h>
@class JETableView;
@class JEStaticTableView;
@class JELiteTV;
@class JEButton;

NS_ASSUME_NONNULL_BEGIN

@interface JEBaseVC : UIViewController

#pragma mark - navBar
@property (nonatomic,assign) BOOL disableNavBar;///< 不使用自定义navBar ### NO
@property (nonatomic,strong)  UIView *navBar;///< 自定义导航栏
@property (nonatomic,strong)  UIVisualEffectView *navBarEffect;///< 自定义导航栏EffectView
@property (nonatomic,strong)  UIView *navBarline;///< 导航栏底部线条
@property (nonatomic,strong)  UILabel *navTitleLable;///< 标题label
@property (nonatomic,strong)  JEButton *navBackButton;///< 返回按钮

/// navBar navBarEffect navBarline frame
- (void)resetNavBarHeight:(CGFloat)h;

/// 导航栏返回键点击事件 可重写控制返回
- (void)navBackButtonClick;

/// 设置返回键标题
- (void)leftNavBtn:(id)item;

/// 导航栏做边按钮
- (JEButton *)leftBtn:(id)item target:(id)target act:(SEL)selector;

/// 导航栏右边按钮
- (JEButton *)rightNavBtn:(id)item target:(id)target act:(SEL)selector;


#pragma mark -
@property (nonatomic,assign,readonly) CGRect tvFrameFull;///< tableView默认Frame
@property (nonatomic,assign,readonly) CGRect tvFrame;///< 
@property (nonatomic,strong) JETableView *tableView;///< 默认的tableView
@property (nonatomic,strong) JELiteTV *liteTv;///< 默认的tableView
@property (nonatomic,strong) JEStaticTableView *staticTv;///< 静态 tableView 

/// 默认Frame的tableView创建方法 
- (JETableView *)defaultTv:(UITableViewStyle)style cell:(id)cellClass;

/// 默认Frame的JELiteTV创建方法
- (JELiteTV *)liteTv:(UITableViewStyle)style cellC:(nullable Class)cellClass cellH:(CGFloat)cellHeight
                cell:(nullable void (^)(__kindof UITableViewCell *cell,UITableView *tv,NSIndexPath *idxP,id obj))cell select:(nullable void (^)(UITableView *tv,NSIndexPath *idxP,id obj))select;

/// 黑暗模式
- (void)handelStyleDark;

@end

NS_ASSUME_NONNULL_END
