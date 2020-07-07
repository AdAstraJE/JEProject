
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
@property (nonatomic,strong)  UIView *navBarContent;///< 自定义导航栏 44/56
@property (nonatomic,strong)  UIVisualEffectView *navBarEffect;///< 自定义导航栏EffectView
@property (nonatomic,strong)  UIView *navBarline;///< 导航栏底部线条
@property (nonatomic,strong)  UILabel *navTitleLable;///< 标题label
@property (nonatomic,strong)  JEButton *navBackButton;///< 返回按钮

/// 导航栏返回键点击事件 可重写控制返回
- (void)navBackButtonClick;

/// 重设返回键标题/图片
- (void)resetNavBackBtn:(id)item;

/// 导航栏左边按钮
- (JEButton *)leftNavBtn:(id)item target:(id)target act:(SEL)selector;

/// 导航栏右边按钮
- (JEButton *)rightNavBtn:(id)item target:(id)target act:(SEL)selector;


#pragma mark -
@property (nonatomic,strong) JETableView *tableView;///< 默认的tableView
@property (nonatomic,strong) JELiteTV *__nullable liteTv;///< 默认的tableView
@property (nonatomic,strong) JEStaticTableView *__nullable staticTv;///< 静态 tableView 

/// 默认Frame的tableView创建方法 
- (JETableView *)defaultTv:(UITableViewStyle)style cell:(id)cellClass;

/// 默认Frame的JELiteTV创建方法
- (JELiteTV *)liteTv:(UITableViewStyle)style cellC:(nullable Class)cellClass cellH:(CGFloat)cellHeight
                cell:(nullable void (^)(__kindof UITableViewCell *cell,UITableView *tv,NSIndexPath *idxP,id obj))cell select:(nullable void (^)(UITableView *tv,NSIndexPath *idxP,id obj))select;



@end

NS_ASSUME_NONNULL_END
