//
//  JEDBModel.h
//  
//
//  Created by JE on 2018/5/25.
//  Copyright © 2018年 JE. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 数据持久化。。。 */
@interface JEDBModel : NSObject
//todo
//模型的模型

typedef void (^JEDBSelectBlock)(NSMutableArray <JEDBModel *> * models);///< 查询结果
typedef void (^JEDBResult)(BOOL success);///< 执行结果

#pragma mark ------------------------------------------默认属性-----------------------------------------------
@property (nonatomic,assign) NSInteger id;///< PRIMARY KEY 默认主键
@property (nonatomic,strong) NSDate *date;///< (NSDate按时间戳处理 1970)

#pragma mark ------------------------------------------可子类重新定义-----------------------------------------------
+ (NSString *)TableName;///< 表名字 ###默认 NSStringFromClass([self class])
+ (NSString *)PrimaryKey;///< 重新定义 Primary Key 主键 ### 默认父类的id
+ (NSArray <Class> *)PropertysFromSuper;///< 要加入的父类属性 （继承默认不会加上父类属性滴）
+ (NSArray <NSString *> *)IgnorePropertys;///< 要忽略的属性


#pragma mark -------------------------------------------建表、更新表----------------------------------------------
/** 按约定建表 */
+ (void)CreateTable;
+ (void)CreateTable:(JEDBResult)done;

/** 更新表，添加缺少的字段 */
+ (void)UpdateTable;


#pragma mark -------------------------------------------更新----------------------------------------------
/** ### UPDATE table (suffix - 传语句后缀), arguments 可nil */
+ (void)Update:(NSString *)suffix arguments:(NSArray <id> *)arguments;

/** REPLACE 同步一组  (事务操作) */
+ (void)dbSave:(NSArray <JEDBModel *> *)arr done:(JEDBResult)done;

/** REPLACE 同步 */
- (void)dbSave:(JEDBResult)done;
- (void)dbSave;

#pragma mark -------------------------------------------查询----------------------------------------------

/** executeQuery: 返回处理过的模型 */
+ (NSMutableArray <__kindof JEDBModel *> *)Query:(NSString *)SQL;

/** executeQuery: 返回处理过的模型 */
+ (void)Query:(NSString *)SQL done:(JEDBSelectBlock)done;

/**  executeQuery: 返回原始数据 */
+ (NSArray <NSDictionary *> *)QuerySchema:(NSString *)SQL;

/**  表中的行数（数据个数） */
+ (NSInteger)TableCount;

/** 表中按date排序的第一个 */
+ (instancetype)FirstModel;

/** 表中按date排序的最后一个 */
+ (instancetype)LastModel;

/** 表中所有 */
+ (void)AllModel:(JEDBSelectBlock)done desc:(BOOL)desc;

/** 按表中的 date 根据时间范围查找 */
+ (void)SelectFrom:(NSDate *)begin to:(NSDate *)end desc:(BOOL)desc done:(JEDBSelectBlock)done;

/** 分页查询 size = 每次多少个 */
+ (void)SelectByPage:(NSInteger )page size:(NSInteger)size desc:(BOOL)desc done:(JEDBSelectBlock)done;

/** ### SELECT * FROM table (suffix - 传语句后缀) */
+ (void)Select:(NSString *)suffix done:(JEDBSelectBlock)done;



#pragma mark -------------------------------------------删除----------------------------------------------

/** TRUNCATE TABLE 删除全部 */
+ (void)DeleteAll:(JEDBResult)done;
+ (void)DeleteAll;

/** 根据选定主键ID删除 */
+ (void)Delete:(NSArray <NSString *> *)ids;

/** ### DELETE FROM table (suffix - 传语句后缀就行) */
+ (void)DeleteQuery:(NSString *)suffix;

/** 删除这条数据 */
- (void)dbDelete;

@end
