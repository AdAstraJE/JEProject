//
//  NetWorking.h
//
//
//  Created by JE on 15/1/26.
//  Copyright (c) 2015年 JE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import<CoreTelephony/CTCellularData.h>
#import "AFNetworkReachabilityManager.h"
@class AFHTTPSessionManager;

static NSString *const jkNetworkReachabilityNotificationKey = @"jkNetworkReachabilityNotificationKey";///<

typedef NS_ENUM(NSUInteger, AFHttpMethod) {
    AFHttpMethodPOST,
    AFHttpMethodGET,
};

typedef NS_ENUM(NSUInteger, JECacheType) {
    JECacheTypeDisk = 1,/**< 本地缓存 */
    JECacheTypeVC,/**< 对应VC临时缓存 离开栈就没了  有缓存不会再进行请求*/
};

typedef JECacheType (^JENetCacheBlock)(id result);
typedef void(^JENetDoneBlock)(id object,NSInteger errorCode);
typedef void(^JENetSucBlock)(id result);
typedef void(^JENetFailBlock)(NSURLSessionDataTask *task,NSError *error);
typedef void (^JENetProgressBlock)(NSProgress *progress,CGFloat pros);

typedef NSDictionary * (^JENetHandleInfoSucBlock)(NSDictionary *obj,UIViewController *vc);
typedef NSInteger (^JENetHandleDoneCodeBlock)(NSDictionary *obj);

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @interface JENetWorking : NSObject   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷

@interface JENetWorking : NSObject

+ (instancetype)Shared;///< 单例 

@property (nonatomic,assign) BOOL debug_enableLog;///< 打印log 默认YES

@property (nonatomic,strong) AFHTTPSessionManager *AFM;
@property (nonatomic,assign) AFNetworkReachabilityStatus status;
@property (nonatomic,assign) CTCellularDataRestrictedState cellularState;
@property (nonatomic,copy)   NSString *baseUrl;///< 请求地址前缀
@property (nonatomic,strong) NSDictionary <NSString *,NSString *> *Dic_coverParam;///< 覆盖请求参数 key 为 value
@property (nonatomic,strong) NSDictionary <NSString *,NSString *> *Dic_defaultParam;///< 请求默认参数 不会覆盖已有字段

@property (nonatomic,strong) NSMutableArray <NSURLSessionTask *> *Arr_task;///< 请求中的task
@property (nonatomic,strong) NSArray <NSString *> *Arr_disableAutoCancelAPI;///< 包含的 请求中的API 不会离开栈就自动取消

/** 取消所有任务 */
- (void)cancelAllTask;
    
/**  设置是否打开状态栏网络状态转圈 默认打开 */
- (void)setActivityIndicatorEnable:(BOOL)enable;

/** 请求完成后的自定义 errorCode */
- (void)setHandleDoneCode:(JENetHandleDoneCodeBlock)HandleInfo;

/** 请求完成后的验证处理 返回解包之后的数据？*/
- (void)setHandleInfoSucBlock:(JENetHandleInfoSucBlock)HandleInfo;


/**
 *  POST 关联 viewControl
 *
 *  @param URL        请求地址 会拼上设置的baseUrl
 *  @param param      参数
 *  @param vc         关联的UIViewController ,监控离开导航栏栈时取消网络请求，保证尽快dealloc 默认[UIApplication sharedApplication].keyWindow.rootViewController
 *  @param cacheBlock 返回的缓存数据，没缓存过的返回nil,  ▶︎ 设置该Block时才根据URL、param缓存数据 vc不为nil 且缓存的是sucBlock处理后的数据 
 *  @param doneBlock  请求成功 给解析后的数据 errorCode默认0 (setHandleDoneCode:)
 *  @param sucBlock   请求成功 不为nil才回调！ 给自定义处理后的数据   (setHandleInfoSucBlock:)
 *  @param failBlock  请求失败 设置nil时默认处理HUD显示
 *
 *  @return task
 */
- (NSURLSessionTask *)POST:(NSString*)URL param:(NSDictionary*)param vc:(UIViewController*)vc cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock fail:(JENetFailBlock)failBlock;


/** GET  */
- (NSURLSessionTask *)GET:(NSString*)URL param:(NSDictionary*)param vc:(UIViewController*)vc cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock fail:(JENetFailBlock)failBlock;

- (NSURLSessionTask *)taskWithMethod:(AFHttpMethod)method url:(NSString*)url param:(NSDictionary*)param vc:(UIViewController*)vc cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock fail:(JENetFailBlock)failBlock;

/** 上传流 */
- (NSURLSessionTask *)uploadDatasWithURL:(NSString *)URL param:(NSDictionary *)param vc:(UIViewController*)vc datas:(NSArray<NSData *> *)datas mimeType:(NSString *)mimeType progress:(JENetProgressBlock)progressBlock done:(JENetDoneBlock)doneBlock fail:(JENetFailBlock)failBlock;


@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   UIViewController (JENetWorking)   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷

@interface UIViewController (JENetWorking)

@property (nonatomic,assign) BOOL noAutoHUD;///< 异常 不自动弹出HUD 

/** 该VC所有进行中的请求id */
@property (nonatomic,strong) NSMutableArray <NSNumber *> *Arr_taskId;


/** VC所缓存的 */
@property (nonatomic,strong) NSMutableDictionary <NSString *,NSDictionary <NSString *,id> *> *Dic_jeCache;
@property (nonatomic,strong) NSMutableDictionary <NSString *,NSNumber *> *Dic_jeCacheType;


- (NSURLSessionTask *)POST:(NSString*)URL param:(NSDictionary*)param cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock fail:(JENetFailBlock)failBlock;

- (NSURLSessionTask *)GET:(NSString*)URL  param:(NSDictionary*)param cache:(JENetCacheBlock)cacheBlock done:(JENetDoneBlock)doneBlock suc:(JENetSucBlock)sucBlock fail:(JENetFailBlock)failBlock;


@end


