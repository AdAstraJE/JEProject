//
//  NSObject+Property.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/20.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYAdd.h"

@interface NSObject (JE)

+ (NSString *)ClassName;/**< NSStringFromClass(self) */

@property (nonatomic,assign,readonly) BOOL isArray;/**< 是否真是数组 [self isKindOfClass:[NSArray class]] */
@property (nonatomic,assign,readonly) BOOL isDict;/**< 是否真是字典 [self isKindOfClass:[NSDictionary class]] */

/** 字典时 获得的字符串 至少返回 @"" */
- (NSString *)str:(NSString*)key;

@property (nonatomic,copy,readonly) NSString *JsonStr;/**< 转为 JsonStr */
@property (nonatomic,copy,readonly) NSString *JsonStr_;/**< 转为 JsonStr 压缩*/
@property (nonatomic,strong,readonly) NSDictionary <NSString *,id> *propertyDictionary;///< 属性值和列表

+ (NSArray <NSString *> *)ClassPropertyList;/**< 属性集合 */

- (void)propertyList_methodList_ivarList;/**< 各种属性 */


@end
