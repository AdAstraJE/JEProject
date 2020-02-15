
#import <UIKit/UIKit.h>
#import "JEListManager.h"

@interface UIScrollView (JE)

//CGFloat top, left, bottom, right;
@property (nonatomic,assign) CGFloat contentInsetTop;///< contentInset.top
@property (nonatomic,assign) CGFloat contentInsetLeft;///< contentInset.left
@property (nonatomic,assign) CGFloat contentInsetBottom;///< contentInset.bottom
@property (nonatomic,assign) CGFloat contentInsetRight;///< contentInset.right

@property (nonatomic,strong) NSMutableArray *Arr;///< 默认基础数据源
@property(nonatomic,strong) UIActivityIndicatorView *ActView;///< tableview 默认ActView

/// storyboard 静态tableview 加载
- (void)staticLoading;

/// storyboard 静态tableview 停止加载
- (void)staticStopLoading;


/// 自带的数组count 为0时 显示的  图片-文本 信息  image = imageName | UIImage */
- (NSInteger)emptyeInfo:(NSString*)title image:(id)image;
- (NSInteger)emptyeInfo:(NSString*)title image:(id)image count:(NSInteger)count;

/// 网络请求失败时显示的
- (UIView*)networkingFailViewWithTarget:(id)target action:(SEL)action;


#pragma mark - 列表管理工具
@property (nonatomic,strong)  JEListManager *listMgr;///< 列表管理工具

/// 创建列表管理工具 
- (void)listMgr:(NSString*)API param:(NSDictionary*)param pages:(BOOL)pages mod:(Class)modClass caChe:(NSString*)caChe suc:(listMgrSucBlock)success;

- (void)listManager:(NSString*)API param:(NSDictionary*)param pages:(BOOL)pages mod:(Class)modClass superVC:(UIViewController*)superVC caChe:(NSString*)caChe method:(AFHttpMethod)method resetAPI:(NSString *(^) (NSInteger page))resetAPI sift:(NSArray *(^) (id result))sift suc:(listMgrSucBlock)success fail:(JENetFailBlock)fail;


@end
