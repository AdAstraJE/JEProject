//
//  JEListManager.h
//  
//
//  Created by JE on 15/6/13.
//
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import "JENetWorking.h"

@interface JEListManager : NSObject

#define         PageParam           @"pageIndex"     //有页的概念时 请求后台页的字段固定 eg.pageNumber
#define         rowsParam           @"pageSize"     //有页的概念时 请求后台每页的字段固定 eg.pageSize
#define         rowsNum             (15)          //有页的概念时 每页多少条

@property(nonatomic,assign) NSInteger       currentPage;/**< 当前页数 */
@property(nonatomic,copy)   NSString        *API;/**< 接口地址 */
@property(nonatomic,strong) NSDictionary    *param;/**< 接口字典参数 */


/** 请求前 每次重新设置API */
@property (nonatomic,copy) NSString* (^block_resetAPI)(NSInteger page);

/** 走自定请求处理 */
@property (nonatomic,copy) void (^block_customNetworking)(NSInteger page,NSDictionary *param,JEListManager *manager);

//网络请求成功时
typedef void (^JEListNetSucBlcok)(id result,NSInteger page,UITableView *table);
@property (nonatomic,copy) JEListNetSucBlcok   block_netSuc;

//网络请求失败时 
typedef void (^JEListNetFailureBlock)(void);
@property (nonatomic,copy) JEListNetFailureBlock   block_netFail;

//处理完成回调 设置了 defaultHandleListArr 默认不 reloadData
@property (nonatomic,copy) void (^block_end)(UITableView *table);


/**
 *  UITableView UICollectionView 列表封装 分页？加载更多的 + mjrefresh + 加缓存首页  ActivityView
 *
 *  @param API       请求地址
 *  @param param     参数
 *  @param pages     是否分页
 *  @param tableview UITableView UICollectionView
 *  @param dataSoure 引用的数据源
 *  @param SuperVC   UIViewController
 *  @param modclass  要转成模型的class
 *  @param cacheKey  不为nil就根据 API param 缓存首页数据
 *  @param suc       默认处理请求成功
 *  @param fail      默认处理请求失败
 *
 *  @return JEListManager
 */
- (instancetype)initWithAPI:(NSString*)API param:(NSDictionary*)param pages:(BOOL)pages Tv:(UIScrollView*)tableview Arr:(NSMutableArray*)dataSoure VC:(UIViewController*)SuperVC modClass:(Class)modclass cacheKey:(NSString*)cacheKey method:(AFHttpMethod)method suc:(JEListNetSucBlcok)suc fail:(JEListNetFailureBlock)fail;

/** 开始请求 */
- (void)startNetworking;

/** 重设默认 移除数据源刷新， 更换API参数(忽略nil)  并从新开始请求 忽略nil */
- (void)resetByNewAPI:(NSString *)API param:(NSDictionary *)param;

/** 获得实际数组 默认处理数组数据方法 */
- (void)defaultHandleListArr:(NSArray*)ArrLists;

@end

