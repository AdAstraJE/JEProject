
#import <Foundation/Foundation.h>
#import "NSObject+YYAdd.h"

@interface NSObject (JE)

- (BOOL)isArray;                                    ///< [self isKindOfClass:NSArray.class]
- (instancetype (^)(NSMutableArray *))to;           ///< [arr addObject:self]
- (BOOL)isDict;                                     ///< [self isKindOfClass:NSDictionary.class]
- (NSString *)str:(NSString *)key;                  ///< dictionary时 获得的字符串 至少返回 @""
- (NSString *)json;                                 ///< 转为 jsonString
- (NSString *)json_;                                ///< 转为 jsonString 压缩
- (NSDictionary <NSString *,id> *)je_propertyDictionary; ///< 属性值和列表
- (void)je_propertyList_methodList_ivarList;             ///< 各种属性
+ (NSArray <NSString *> *)je_classPropertyList;          ///< 属性集合

@end
