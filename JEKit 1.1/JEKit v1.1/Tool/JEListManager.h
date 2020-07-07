
#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import "JENetWorking.h"

//网络请求成功时
typedef void (^listMgrSucBlock)(id result,NSInteger page,UITableView *table);
//#define         PageParam           @"pageIndex"     //有页的概念时 请求后台页的字段固定 eg.pageNumber
//#define         rowsParam           @"pageSize"     //有页的概念时 请求后台每页的字段固定 eg.pageSize
//#define         rowsNum             (15)          //有页的概念时 每页多少条

@interface JEListManager : NSObject

@property(nonatomic,assign) NSInteger       currentPage;///< 当前页数
@property(nonatomic,copy)   NSString        *API;///< 接口地址
@property(nonatomic,strong) NSDictionary    *param;///< 接口字典参数

/// 请求前 每次重新设置API
@property (nonatomic,copy) NSString* (^resetAPI)(NSInteger page);

/// 走自定网络处理
@property (nonatomic,copy) void (^customNetwork)(NSInteger page,NSDictionary *param,JEListManager *manager);

/// 走自定数据源筛选
@property (nonatomic,copy) NSArray * (^siftDataSoure)(id result);

/// 处理完成回调 设置了 defaultHandleListArr 不 reloadData
@property (nonatomic,copy) void (^handleEnd)(UITableView *table);



/// UITableView UICollectionView 列表封装 分页？加载更多的 + mjrefresh + 加缓存首页  ActivityView
/// @param API 请求地址
/// @param param 参数
/// @param pages 是否分页
/// @param tableview UITableView UICollectionView
/// @param dataSoure 引用的数据源
/// @param superVC UIViewController
/// @param modclass 要转成模型的class
/// @param cacheKey 不为nil就根据 API param 缓存首页数据
/// @param method AFHttpMethod
/// @param suc 默认处理请求成功
/// @param fail 默认处理请求失败
- (instancetype)initWithAPI:(NSString*)API param:(NSDictionary*)param pages:(BOOL)pages tv:(UIScrollView*)tableview arr:(NSMutableArray*)dataSoure vc:(UIViewController*)superVC mod:(Class)modclass caChe:(NSString*)cacheKey method:(AFHttpMethod)method suc:(listMgrSucBlock)suc fail:(JENetFailBlock)fail;

/// 开始请求
- (void)startNetworking;

/// 重设默认 移除数据源刷新， 更换API参数(忽略nil)  并从新开始请求 忽略nil 
- (void)resetByNewAPI:(NSString *)API param:(NSDictionary *)param;

@end

