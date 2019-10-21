
#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "YYMemoryCache.h"
#import "YYDiskCache.h"
#import "YYCache.h"

#define USDF       [NSUserDefaults standardUserDefaults]
#define JEdbQe     [JEDataBase dbQueue]

NS_ASSUME_NONNULL_BEGIN

@interface JEDataBase : NSObject

#pragma mark - SQL
+ (instancetype)SharedDbName:(NSString*)dbName;///< 单例 创建数据库

+ (FMDatabaseQueue *_Nullable)dbQueue;///< SharedDbName: 后才会有值
+ (void)Close;///< 关闭数据库


#pragma mark - 键值对存储 (id<NSCoding>)
+ (YYCache *_Nullable)dataCache;                        ///< SharedDbName: -> 键值对缓存类

+ (void)Cache :(id)obj    key:(NSString *)key;///< save
+ (id)  Cache :(NSString*)key;                ///< get
+ (void)Remove:(NSString*)key;                ///< remove
+ (void)RemoveAll;                            ///< removeAll

#pragma mark - JEObject Cache
+ (YYCache *_Nonnull)JEObjectCache;                    ///< 独立JEObject专用Cache

@end

NS_ASSUME_NONNULL_END
