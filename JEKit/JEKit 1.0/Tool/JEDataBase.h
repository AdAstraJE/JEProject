//
//  JEdataBase.h
//
//
//  Created by JE on 15/1/14.
//  Copyright (c) 2015年 JE All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#define USDF       [NSUserDefaults standardUserDefaults]
#define JEdbQe     [JEDataBase dbQueue]

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @interface NSObject (JEDbCache)   🔷
/** SQL DataBase & 键值对缓存 */
@interface JEDataBase : NSObject

/** 单例 创建数据库 */
+ (instancetype)SharedDbName:(NSString*)dbName;

/** 根据 唯一标识 dbName (SharedDbName: 后才会有值) 创建数据库  (eg.用户id,属于自己的数据库) */
+ (FMDatabaseQueue*)dbQueue;

/** 关闭数据库  */
+ (void)Close;

//------------------------------------------------------------------------------------------------------------------------
#pragma mark - 键值对存储 (id<NSCoding>)

+ (void)setObject:(id)object forKey:(NSString *)key;///< save

+ (id)objectForKey:(NSString*)key;///< get

+ (void)RemoveObjectForKey:(NSString *)key;///< remove

+ (void)RemoveAll;///< removeAll

@end

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷   @interface NSObject (JEDbCache)   🔷
@interface NSObject (JEDbCache)

/** 按className缓存一个模型  */
- (void)je_Cache;

/** 取一个按className缓存的模型 不存在就创建 不为空 */
+ (instancetype)je_OneCache;

/** 首次创建时配置  */
- (void)je_DefaultSetting;

@end

