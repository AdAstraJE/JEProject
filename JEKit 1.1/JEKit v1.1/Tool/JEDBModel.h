
#import <Foundation/Foundation.h>
@class FMDatabaseQueue;

/// 数据持久化。。。
@interface JEDBModel : NSObject
//todo
//模型的模型

typedef void (^JEDBSelectBlock)(NSMutableArray <JEDBModel *> * models);///< 查询结果
typedef void (^JEDBResult)(BOOL success);///< 执行结果

#pragma mark ------------------------------------------默认属性-----------------------------------------------
@property (nonatomic,assign) NSInteger ID;///< PRIMARY KEY 默认主键
@property (nonatomic,strong) NSDate *date;///< (NSDate按时间戳处理 1970)

#pragma mark ------------------------------------------可子类重新定义-----------------------------------------------
+ (NSString *)TableName;///< 表名字 ###默认 NSStringFromClass([self class])
+ (NSString *)PrimaryKey;///< 重新定义 Primary Key 主键 ### 默认父类的id
+ (NSArray <Class> *)PropertysFromSuper;///< 要加入的父类属性 （继承默认不会加上父类属性滴）

#pragma mark -------------------------------------------建表、更新表----------------------------------------------

+ (BOOL)TableExist;///< 是否有表
+ (void)CreateTable;///< 建表
+ (void)CreateTable:(JEDBResult)done;///< 建表
+ (void)UpdateTable;///< 更新表，添加缺少的字段

#pragma mark -------------------------------------------更新----------------------------------------------

/// REPLACE  (事务操作)
+ (void)dbSave:(NSArray <JEDBModel *> *)arr done:(JEDBResult)done;
- (void)dbSave:(JEDBResult)done;///< REPLACE
- (void)dbSave;///< REPLACE

#pragma mark -------------------------------------------查询----------------------------------------------

+ (void)Query:(NSString *)SQL done:(JEDBSelectBlock)done;///< executeQuery: 返回处理过的模型
+ (NSMutableArray <__kindof JEDBModel *> *)Query:(NSString *)SQL;///< executeQuery: 返回处理过的模型
+ (NSArray <NSDictionary *> *)QuerySchema:(NSString *)SQL;///< executeQuery: 返回原始数据

+ (NSInteger)TableCount;///<  表中的行数（数据个数）
+ (instancetype)FirstModel;///< 表中按date排序的第一个
+ (instancetype)LastModel;///< 表中按date排序的最后一个
+ (instancetype)Model:(NSString *)primaryKey;///< 按照primaryKey查询一个

/// 表中所有
+ (void)AllModel:(JEDBSelectBlock)done desc:(BOOL)desc;
+ (NSMutableArray <__kindof JEDBModel *> *)AllModelByDesc:(BOOL)desc;

/// 按表中的 date 根据时间范围查找
+ (void)SelectFrom:(NSDate *)begin to:(NSDate *)end desc:(BOOL)desc done:(JEDBSelectBlock)done;

/// 分页查询 page 0开始 size = 每次多少个
+ (void)SelectByPage:(NSInteger )page size:(NSInteger)size desc:(BOOL)desc done:(JEDBSelectBlock)done;

/// SELECT * FROM table (suffix - 传语句后缀)
+ (void)Select:(NSString *)suffix done:(JEDBSelectBlock)done;
+ (NSMutableArray <__kindof JEDBModel *> *)Select:(NSString *)suffix;

#pragma mark -------------------------------------------删除----------------------------------------------

/// TRUNCATE TABLE 删除全部
+ (void)DeleteAll:(JEDBResult)done;

/// 根据Class TABLE 删除全部
+ (void)DeleteAllByClass:(NSArray <Class> *)classArr done:(JEDBResult)done;
    
/// 根据选定主键ID删除
+ (void)Delete:(NSArray <NSString *> *)ids;

/// DELETE FROM table (suffix - 传语句后缀就行)
+ (void)DeleteQuery:(NSString *)suffix;

/// 删除这条数据 
- (void)dbDelete;


#pragma mark ---------------------------------其他类用自己的 FMDatabaseQueue 的---------------------------------

+ (NSMutableArray <id> *)Query:(NSString *)SQL modClass:(Class)modClass dbQe:(FMDatabaseQueue *)dbQe;
    
@end
