
#import "JEDataBase.h"
#import "NSObject+YYModel.h"

static NSString *const jkJEObjectCacheName = @"JEObjectCacheName";///<

#ifdef DEBUG
#define JELog(fmt, ...)     fprintf(stderr,"%s\n",[[NSString stringWithFormat:@"" fmt, ##__VA_ARGS__] UTF8String]);
#else
#define JELog(...)
#endif

@interface JEDataBase ()
@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
@property (nonatomic,strong) YYCache *dataCache;
@property (nonatomic,strong) YYCache *JEObjectCache;
@end

@implementation JEDataBase

+ (id)allocWithZone:(struct _NSZone *)zone{
    static JEDataBase *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        _instance->_JEObjectCache = [YYCache cacheWithName:jkJEObjectCacheName];
    });
    return _instance;
}

+ (instancetype)Shared{ return [[self alloc] init];}


+ (instancetype)SharedDbName:(NSString*)dbName{
    if ([JEDataBase Shared].dbQueue){[self Close];}
    if (dbName.length == 0) { dbName = NSStringFromClass(JEDataBase.class);}
    
    dbName = ([dbName hasSuffix:@".db"] ? dbName : [dbName stringByAppendingString:@".db"]);

    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dbName];//数据库账号通用
    [JEDataBase Shared].dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [JEDataBase Shared].dataCache = [YYCache cacheWithName:dbName];
    
    JELog(@"💾 数据库路径\n%@",dbPath);
    
    return [[self alloc] init];
}

+ (FMDatabaseQueue *_Nullable)dbQueue{
    return [JEDataBase Shared].dbQueue;
}

+ (void)Close{
    JELog(@"💾 \n数据库关闭\n%@\n",[JEDataBase Shared].dbQueue.path);
    [[JEDataBase Shared].dbQueue close];
    [JEDataBase Shared].dbQueue = nil;
}


#pragma mark - 键值对存储 (id<NSCoding>)
+ (YYCache *_Nullable)dataCache{
    return [JEDataBase Shared].dataCache;
}

+ (void)Cache:(id)obj key:(NSString *)key{
    NSAssert([JEDataBase Shared].dataCache != nil,@"必须先设置缓存数据库名 SharedDbName: ");
    [[JEDataBase Shared].dataCache setObject:obj forKey:key withBlock:nil];
}

+ (id)Cache:(NSString*)key{
    return [[JEDataBase Shared].dataCache objectForKey:key];
}

+ (void)Remove:(NSString *)key{
    [[JEDataBase Shared].dataCache removeObjectForKey:key];
}

+ (void)RemoveAll{
    [[JEDataBase Shared].dataCache removeAllObjects];
}

#pragma mark - JEObject Cache
+ (YYCache *_Nonnull)JEObjectCache{
    return [JEDataBase Shared].JEObjectCache;
}

@end

