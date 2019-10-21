
#import "JEDataBase.h"
#import "JEDBModel.h"
#import "YYCache.h"
#import "YYDiskCache.h"
#import "NSObject+YYModel.h"

#ifdef DEBUG
#define JELog(fmt, ...)     fprintf(stderr,"%s\n",[[NSString stringWithFormat:@"" fmt, ##__VA_ARGS__] UTF8String]);
#else
#define JELog(...)
#endif

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  SQL DataBase   🔷🔷🔷🔷🔷🔷🔷🔷

@interface JEDataBase ()
@property (nonatomic,strong) FMDatabaseQueue *dataBaseQueue;
@property (nonatomic,strong) YYCache *dataCache;
@end

@implementation JEDataBase

static NSString *_JEDataBase_dbName;

+ (id)allocWithZone:(struct _NSZone *)zone{
    static JEDataBase *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _instance = [super allocWithZone:zone];});
    return _instance;
}

+ (instancetype)Shared{ return [[self alloc] init];}
+ (instancetype)SharedDbName:(NSString*)dbName{
    [self Close];
    if (dbName.length == 0) { dbName = NSStringFromClass(JEDataBase.class);}
    _JEDataBase_dbName = ([dbName hasSuffix:@".db"] ? dbName : [dbName stringByAppendingString:@".db"]);
    [[JEDataBase Shared] dataBaseQueue];
    return [[self alloc] init];
}

/** 根据 唯一标识 (eg.用户id,属于自己的) 创建数据库 SharedDbName: 后才会有值  */
+ (FMDatabaseQueue*)dbQueue{
    return _JEDataBase_dbName ? [JEDataBase Shared].dataBaseQueue : nil;
}

/** 关闭数据库  */
+ (void)Close{
    if (_JEDataBase_dbName.length) {
        JELog(@"\n数据库关闭\n%@\n",_JEDataBase_dbName);
        [[JEDataBase Shared].dataBaseQueue close];
        [JEDataBase Shared].dataBaseQueue = nil;
        _JEDataBase_dbName = nil;
    }
}

- (FMDatabaseQueue *)dataBaseQueue{
    if (_dataBaseQueue == nil) {
        NSString * dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:_JEDataBase_dbName];//数据库账号通用
        _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        
        [JEDataBase Shared].dataCache = [YYCache cacheWithName:_JEDataBase_dbName];
        JELog(@"💾💾💾数据库路径\n%@",dbPath);
//        JELog(@"💾💾💾Cache路径\n%@",[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:_JEDataBase_dbName]);
    }
    return _dataBaseQueue;
}

+ (void)setObject:(id)object forKey:(NSString *)key{
    NSAssert([JEDataBase Shared].dataCache != nil,@"必须先设置缓存数据库名 SharedDbName: ");
    [[JEDataBase Shared].dataCache setObject:object forKey:key withBlock:nil];
}

+ (id)objectForKey:(NSString*)key{
    return [[JEDataBase Shared].dataCache objectForKey:key];
}

+ (void)RemoveObjectForKey:(NSString *)key{
    [[JEDataBase Shared].dataCache removeObjectForKey:key];
}

+ (void)RemoveAll{
    [[JEDataBase Shared].dataCache removeAllObjects];
}

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @implementation NSObject (JEDbCache)   🔷
@implementation NSObject (JEDbCache)

- (void)je_Cache{
    [JEDataBase setObject:[self modelToJSONObject] forKey:NSStringFromClass([self class])];
}

+ (instancetype)je_OneCache{
    NSObject *obj = [JEDataBase objectForKey:NSStringFromClass([self class])];
    if (obj == nil) {
        obj = [[self alloc] init];
        [obj je_DefaultSetting];
        [obj je_Cache];
        return obj;
    }
    return [self modelWithJSON:obj];
}

- (void)je_DefaultSetting{
    
}


@end
