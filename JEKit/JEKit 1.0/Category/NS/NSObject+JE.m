//
//  NSObject+Property.m
//  IOS-Categories
//
//  Created by Jakey on 14/12/20.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSObject+JE.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@implementation NSObject (JE)

+ (NSString *)ClassName {
    return NSStringFromClass(self);
}

- (BOOL)isArray{
    return [self isKindOfClass:[NSArray class]];
}

- (BOOL)isDict{
    return [self isKindOfClass:[NSDictionary class]];
}

/** 字典时 获得的字符串 至少返回 @"" */
- (NSString *)str:(NSString*)key{
    if (![self isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    id value = [(NSDictionary *)self objectForKey:key];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",value];
}

- (NSString *)JsonStr{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return   [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString *)JsonStr_{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return   [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:0 error:NULL] encoding:NSUTF8StringEncoding];
    }
    return nil;
}

/** 属性值和列表 */
- (NSDictionary <NSString *,id> *)propertyDictionary{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    for(int i=0;i<outCount;i++){
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propName];
        if(propValue){
            [dict setObject:propValue forKey:propName];
        }
    }
    free(props);
    return dict;
}

/** 属性集合 */
+ (NSArray <NSString *> *)ClassPropertyList {
    NSMutableArray *allProperties = [[NSMutableArray alloc] init];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList(self, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        if (propName) {
            [allProperties addObject:propName];
        }
    }
    free(props);
    return [NSArray arrayWithArray:allProperties];
}

#define JELog(fmt, ...)     fprintf(stderr,"%s\n",[[NSString stringWithFormat:@"" fmt, ##__VA_ARGS__] UTF8String]);
- (void)propertyList_methodList_ivarList{
#ifdef DEBUG
    unsigned int count;
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        //        id propertyValue = [self valueForKey:(NSString *)propertyName];
        JELog(@"property---->  %@", propertyName);
    }
    
    free(propertyList);
    //获取方法列表
    Method *methodList = class_copyMethodList([self class], &count);
    for ( int i = 0; i < count; i++) {
        Method method = methodList[i];
        JELog(@"method---->  %@", NSStringFromSelector(method_getName(method)));
    }
    
    //获取成员变量列表
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i = 0; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        JELog(@"Ivar---->  %@", [NSString stringWithUTF8String:ivarName]);
    }
    
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i = 0; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        JELog(@"protocol---->  %@", [NSString stringWithUTF8String:protocolName]);
    }
#endif
}

@end
