
#import "JEDBModel.h"
#import "JEDataBase.h"
#import "NSObject+YYModel.h"

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define DBLog(fmt, ...) fprintf(stderr,"💾  %s\n",[[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);
#else
#define DBLog(...)
#endif
#define Format(...)     ([NSString stringWithFormat:__VA_ARGS__])


static NSString * const kDB_text     =    @"text";
static NSString * const kDB_integer  =    @"integer";
static NSString * const kDB_real     =    @"real";///< 浮点数

static NSString * const kColumn_id =      @"ID";///< 父类 id 字段名
static NSString * const kColumn_Date =    @"date";///< 父类 NSDate 字段名

@implementation JEDBModel

#pragma mark ------------------------------------------可子类重新定义-----------------------------------------------
+ (NSString *)TableName { return NSStringFromClass(self.class);}
+ (NSString *)PrimaryKey{ return @"ID";}
+ (NSArray <Class> *)PropertysFromSuper{  return nil;}
+ (NSArray <NSString *> *)IgnorePropertys{  return nil;}
+ (NSString *)OrderKey{return [self PrimaryKey];}

#pragma mark -   YY 自定义处理 NSDate

static NSDateFormatter *staticDateFormatter;
- (NSDateFormatter *)staticDateFormatter{
    if (!staticDateFormatter) {
        staticDateFormatter = [[NSDateFormatter alloc] init];
        [staticDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return staticDateFormatter;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    NSString *date = dic[@"date"];
    if (![date isKindOfClass:[NSString class]]) { return YES;}
    if (![date containsString:@"UTC"] && [date containsString:@"-"]) {
        self.date = [self.staticDateFormatter dateFromString:date];
    }else{
        if (date.length) {self.date = [NSDate dateWithTimeIntervalSince1970:date.longLongValue];}
    }
    
    return YES;
}

#pragma mark ------------------------------------------runTime基本建表等-----------------------------------------------

/// 属性字段名 & 类型
+ (NSDictionary <NSString *,NSString *> *)DBModelPropertys{
    NSMutableDictionary <NSString *,NSString *> *propertysDic = objc_getAssociatedObject(self, __func__);
    if (propertysDic) { return propertysDic;
    }else{ propertysDic  = [NSMutableDictionary dictionary];}
    
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([super class], &count);
    NSArray <NSString *> *ignores = [self IgnorePropertys];
    for (int i = 0; i < count; i++){
        objc_property_t property = propertys[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        if ([ignores containsObject:name]) {continue;}
        
        NSString *type = [NSString stringWithUTF8String:property_copyAttributeValue(property,"T")];
        if (![type isEqualToString:@"@?"]) {//property block 
            [propertysDic setValue:type forKey:name];
        }
    }
    free(propertys);
    
    NSArray <Class > *superPro = [self PropertysFromSuper];
    if (superPro.count) {
        [superPro enumerateObjectsUsingBlock:^(Class  sClass, NSUInteger idx, BOOL * stop) {
            NSDictionary *dic = [sClass DBModelPropertys];
            [dic enumerateKeysAndObjectsUsingBlock:^(id  key, id obj, BOOL * stop) {
                [propertysDic setObject:obj forKey:key];
            }];
        }];
    }
    
    objc_setAssociatedObject(self, __func__, propertysDic, OBJC_ASSOCIATION_COPY);
    return propertysDic;
}

/// Json&自定义类型的属性名称
+ (NSArray <NSString *> *)JsonPropertys{
    NSMutableArray <NSString *> *filtArr = objc_getAssociatedObject(self, __func__);
    if (filtArr) { return filtArr;
    }else{ filtArr  = [NSMutableArray array];}
    
    [[self DBModelPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * type, BOOL * stop) {
        if ([@[@"@\"NSArray\"",@"@\"NSMutableArray\"",@"@\"NSDictionary\"",@"@\"NSMutableDictionary\""] containsObject:type]) {
            [filtArr addObject:key];
        }else{//自定义的类
            if ([type hasPrefix:@"@"] && ([NSBundle bundleForClass:NSClassFromString([type substringWithRange:NSMakeRange(2, type.length - 3)])] == [NSBundle mainBundle])) {
                [filtArr addObject:key];
            }
        }
    }];
    objc_setAssociatedObject(self, __func__, filtArr, OBJC_ASSOCIATION_COPY);
    return filtArr;
}

+ (NSMutableArray <NSString *> *)FiltPropertys:(NSString *)string{
    NSMutableArray <NSString *> *filtArr = [NSMutableArray array];
    [[self DBModelPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * type, BOOL * stop) {
        if ([type containsString:string]) { [filtArr addObject:key];}
    }];return filtArr;
}

/// 属性与表结构类型对应关系
+ (NSDictionary <NSString *,NSString *> *)SQLPropertys{
    NSMutableDictionary <NSString *,NSString *> *dbDic = objc_getAssociatedObject(self, __func__);
    if (dbDic) { return dbDic;
    }else{ dbDic  = [NSMutableDictionary dictionary];}
    
    //NSDate按时间戳字符串处理
    NSArray <NSString *> *textT = @[@"@\"NSString\"",@"@\"NSNumber\"",@"@\"NSArray\"",@"@\"NSMutableArray\"",@"@\"NSDictionary\"",@"@\"NSMutableDictionary\""];
    NSArray <NSString *> *intT = @[@"i",@"s",@"q",@"c",@"b",@"l"];
    NSArray <NSString *> *floatT = @[@"f",@"d"];
    
    [[self DBModelPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * type, BOOL * stop) {
        
        if      ([textT containsObject:type]) {                   [dbDic setValue:kDB_text forKey:key]; }
        else if ([type containsString:@"NSDate"]){                [dbDic setValue:kDB_integer forKey:key]; }
        else if ([intT containsObject:type.lowercaseString]){     [dbDic setValue:kDB_integer forKey:key]; }
        else if ([floatT containsObject:type.lowercaseString]){   [dbDic setValue:kDB_real forKey:key]; }
        else{                                                     [dbDic setValue:kDB_text forKey:key]; }//其他 按字符串处理
    }];
    
    if ([[self PrimaryKey] isEqualToString:kColumn_id]) { [dbDic setValue:kDB_integer forKey:kColumn_id];}//父类的
    [dbDic setValue:kDB_integer forKey:kColumn_Date];//父类的
    
    objc_setAssociatedObject(self, __func__, dbDic, OBJC_ASSOCIATION_COPY);
//    DBLog(@"%@\n%@",[self TableName],dbDic);
    return dbDic;
}

#pragma mark -------------------------------------------建表、更新表----------------------------------------------

+ (BOOL)TableExist{
    NSDictionary *res = [self QuerySchema:Format(@"select count(*) as 'count' from sqlite_master where type ='table' and name = \"%@\"", [self TableName])].firstObject;
    NSNumber *countDesc = [res valueForKey:@"count"];
    return countDesc.boolValue;
}

+ (void)CreateTable{
    [self CreateTable:nil];
}

+ (void)CreateTable:(JEDBResult)done{
    NSString *autoKey = Format(@"%@ %@ primary key autoincrement,",kColumn_id,kDB_integer);//没有主键时拼上
    NSMutableString *SQL = Format(@"create table if not exists %@ (%@",[self TableName],[self PrimaryKey] ? @"" : autoKey).mutableCopy;
    [[self SQLPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * name, NSString * type, BOOL * stop) {
        [SQL appendFormat:@"%@ %@,",name,type];
    }];
    
    if ([self PrimaryKey]) { [SQL appendFormat:@"primary key(%@) )",[self PrimaryKey]];}
    else{ SQL = [SQL stringByReplacingCharactersInRange:NSMakeRange(SQL.length - 1, 1) withString:@" )"].mutableCopy;}
    
    [self ExecuteUpdate:@[SQL] arguments:nil done:done];
}

+ (void)UpdateTable{
    NSMutableArray <NSString *> *tableColumn = [NSMutableArray array];
    [[self QuerySchema:Format(@"pragma table_info('%@')",[self TableName])] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * stop) {
        [tableColumn addObject:obj[@"name"]];
    }];
    NSMutableDictionary <NSString *,NSString *> *newColumn = [self SQLPropertys].mutableCopy;
    [newColumn removeObjectsForKeys:tableColumn];
    if (newColumn.count == 0) { return;}
    DBLog(@"%@ 表要新加的字段%@",[self TableName],newColumn);
    [newColumn enumerateKeysAndObjectsUsingBlock:^(NSString * name, NSString * type, BOOL * stop) {
        [self ExecuteUpdate:@[(Format(@"alter table %@ ADD column %@ %@;",[self TableName],name,type))] arguments:nil done:nil];
    }];
}

#pragma mark -------------------------------------------更新----------------------------------------------

+ (void)dbSave:(NSArray <JEDBModel *> *)arr done:(JEDBResult)done{
    if (arr.count == 0) { return;}
    NSMutableArray <NSString *> *SQLs = [NSMutableArray array];
    NSMutableArray <id> *Arguments = [NSMutableArray array];
    for (JEDBModel *eachMod in arr) {
        NSArray *create = [eachMod createReplace_SQL_Arguments];
        [SQLs addObject:create.firstObject];
        [Arguments addObject:create.lastObject];
    }
    
    [self ExecuteUpdate:SQLs arguments:Arguments done:done];
}

- (void)dbSave{
    [self dbSave:nil];
}

- (void)dbSave:(JEDBResult)done{
    NSArray *SQLArguments = [self createReplace_SQL_Arguments];
    [self.class ExecuteUpdate:@[SQLArguments.firstObject] arguments:@[SQLArguments.lastObject] done:done];
}

- (NSArray *)createReplace_SQL_Arguments{
    NSMutableString *columnName = [NSMutableString string],*columnValue = [NSMutableString string];
    NSMutableArray *arguments = [NSMutableArray array];
    [[self.class SQLPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString *type, BOOL * stop) {
        [columnName appendFormat:@"%@%@",columnName.length ? @"," : @"",key];
        [columnValue appendFormat:@"%@%@",columnValue.length ? @"," : @"",@"?"];
        [arguments addObject:[self columnValue:[self valueForKey:key] key:key DBtype:type]];
    }];
    NSString *SQL = Format(@"replace into %@ (%@) values (%@)",[self.class TableName],columnName,columnValue);
    return @[SQL,arguments];
}

/// 实际传入SQL的字符拼接 String
- (NSString *)columnValue:(id)value key:(NSString *)key DBtype:(NSString *)DBtype{
    if ([DBtype isEqualToString:kDB_text]) {
        if(value && ([NSBundle bundleForClass:[value class]] == [NSBundle mainBundle])){//自定义的类
            return [value modelToJSONString] ? : @"";
        }
        if (value == nil || [value isKindOfClass:NSString.class] || [value isKindOfClass:NSNumber.class]) {
            return (Format(@"%@",value ? : @""));
        }
        if ([value isKindOfClass:NSValue.class]) {
            return [self.class HandelNSValue:value type:[self.class DBModelPropertys][key]] ? : @"";
        }
        if ([value isKindOfClass:NSData.class]) {
            return [((NSData *)value) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        }
        if ([value isKindOfClass:UIColor.class]) {
            CGFloat r, g, b, a;
            [value getRed:&r green:&g blue:&b alpha:&a];
            return [NSString stringWithFormat:@"%.4f,%.4f,%.4f,%.4f", r, g, b, a];
        }
        
        return [value modelToJSONString] ? : @"";
    }else if ([value isKindOfClass:[NSDate class]]){
        return Format(@"%lld",(long long)[(NSDate *)value timeIntervalSince1970]);//NSDate按时间戳处理 1970
    }else{
             
    }
    return (Format(@"%@",value ? : @""));
}

+ (id)HandelNSValue:(id)value type:(NSString *)t{
    BOOL v = [value isKindOfClass:NSString.class];
    if ([t containsString:@"CGRect"]) {
        return (v ? [NSValue valueWithCGRect:CGRectFromString(value)] : NSStringFromCGRect([value CGRectValue]));
    }else if ([t containsString:@"CGPoint"]) {
        return (v ? [NSValue valueWithCGPoint:CGPointFromString(value)] : NSStringFromCGPoint([value CGPointValue]));
    }else if ([t containsString:@"CGSize"]) {
        return (v ? [NSValue valueWithCGSize:CGSizeFromString(value)] : NSStringFromCGSize([value CGSizeValue]));
    }else if ([t containsString:@"UIOffset"]) {
        return (v ? [NSValue valueWithUIOffset:UIOffsetFromString(value)] : NSStringFromUIOffset([value UIOffsetValue]));
    }else if ([t containsString:@"NSRange"]) {
        return (v ? [NSValue valueWithRange:NSRangeFromString(value)] : NSStringFromRange([value rangeValue]));
    }else if ([t containsString:@"UIEdgeInsets"]) {
        return (v ? [NSValue valueWithUIEdgeInsets:UIEdgeInsetsFromString(value)] : NSStringFromUIEdgeInsets([value UIEdgeInsetsValue]));
    }else if ([t containsString:@"CGAffineTransform"]) {
        return (v ? [NSValue valueWithCGAffineTransform:CGAffineTransformFromString(value)] : NSStringFromCGAffineTransform([value CGAffineTransformValue]));
    }
    return nil;
}

/// 子线程 executeUpdate  (arguments个数不为0时 必须 arguments.count = SQLArr.count)
+ (void)ExecuteUpdate:(NSArray <NSString *> *)SQLArr arguments:(NSArray <NSArray <id> *> *)arguments done:(JEDBResult)done{
    if (arguments.count != 0 && arguments.count != SQLArr.count) {DBLog(@"⚠️SQL arguments 个数不对应");return;}
    
    BOOL isTransaction = (SQLArr.count > 1);//多条开启事务
    if (JEdbQe == nil) {DBLog(@"⚠️未打开");}

    __block NSUInteger suc = 0;
    [JEdbQe inDatabase:^(FMDatabase * _Nonnull db) {
        if (isTransaction) {[db beginTransaction];}
        
        [SQLArr enumerateObjectsUsingBlock:^(NSString * SQL, NSUInteger idx, BOOL * stop) {
            if (arguments) {
                [db executeUpdate:SQL withArgumentsInArray:arguments[idx]] ? (suc++) : (*stop = YES);//withArgumentsInArray
            }else{
                [db executeUpdate:SQL] ? (suc++) : (*stop = YES);
            }
        }];
        
        if (isTransaction) {SQLArr.count == suc ? [db commit] : [db rollback];}//事务结束
    }];
//    DBLog(@"%@",(isTransaction ? Format(@"事务操作：%@条, %@",@(suc),(suc == SQLArr.count ? @"" : @"🔴失败")) : Format(@"%@",SQLArr.firstObject)));
    
    !done ?: done((SQLArr.count == suc));
}


#pragma mark -------------------------------------------查询----------------------------------------------

+ (void)Query:(NSString *)SQL done:(JEDBSelectBlock)done{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray <__kindof JEDBModel *> *result = [self Query:SQL];
        dispatch_async(dispatch_get_main_queue(), ^{!done ? : done(result); });
    });
}

+ (NSMutableArray <__kindof JEDBModel *> *)Query:(NSString *)SQL{
    return (id)[self Query:SQL modClass:self.class dbQe:JEdbQe];
}

+ (NSArray <NSDictionary *> *)QuerySchema:(NSString *)SQL{
    return (id)[self Query:SQL modClass:nil dbQe:JEdbQe];
}

+ (NSMutableArray <id> *)Query:(NSString *)SQL modClass:(Class)modClass dbQe:(FMDatabaseQueue *)dbQe{
    NSMutableArray <id> *result = [NSMutableArray array];
    NSArray <NSString *> *NSDatePropertys = [[self FiltPropertys:@"NSDate"] arrayByAddingObject:kColumn_Date];
    NSArray <NSString *> *NSDataPropertys = [self FiltPropertys:@"NSData"];
    NSArray <NSString *> *UIColorPropertys = [self FiltPropertys:@"UIColor"];
    NSArray <NSString *> *JsonPropertys = [self JsonPropertys];
    
    if (dbQe == nil) {DBLog(@"⚠️未打开");}
    [dbQe inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs =  [db executeQuery:SQL];
        NSNumber *containNSValue = nil;
        
        while ([rs next]) {
            if (modClass == nil) {
                [result addObject:rs.resultDictionary];
            }else{
                NSMutableDictionary <NSString *,id> *dic = (NSMutableDictionary *)rs.resultDictionary;
                
                [JsonPropertys enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * stop) {
                    NSString *jsonStr = dic[key];
                    if ([jsonStr isKindOfClass:[NSNull class]]) { jsonStr = @"";}
                    if (jsonStr) {
                        NSObject *jsonValue = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                        [dic setValue:jsonValue forKey:key];
                    }
                }];
                
                [NSDatePropertys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * stop) {
                    NSDate *date = dic[key];
                    if ([date isKindOfClass:NSDate.class]) {
                        dic[key] = date;
                    }else{
                        long long timeStamp = [dic[key] longLongValue];
                        if (timeStamp != 0) {dic[key] = [NSDate dateWithTimeIntervalSince1970:timeStamp];;}
                    }
                }];
                
                [NSDataPropertys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * stop) {
                    dic[key] = [[NSData alloc] initWithBase64EncodedString:dic[key] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                }];
                
                [UIColorPropertys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * stop) {
                    NSArray <NSString *> *arr = [dic[key] componentsSeparatedByString:@","];
                    if (arr.count >= 4) {
                        dic[key] = [UIColor colorWithRed:arr[0].floatValue green:arr[1].floatValue blue:arr[2].floatValue alpha:arr[3].floatValue];
                    }
                }];
                
                
                if (containNSValue == nil) {
                    containNSValue = @(NO);
                    for (NSString *obj in dic.allKeys) {
                        NSString *t = [self DBModelPropertys][obj];
                        if ([t containsString:@"CGSize"] || [t containsString:@"CGPoint"] || [t containsString:@"NSRange"] || [t containsString:@"UIOffset"] || [t containsString:@"UIEdgeInsets"] || [t containsString:@"CGAffineTransform"]) {
                            containNSValue = @(YES);break;
                        }
                    }
                }
                
                if (containNSValue.boolValue) {
                    [[self DBModelPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *t, BOOL * stop) {
                        id value = [self HandelNSValue:dic[key] type:t];
                        if (value) {dic[key] = value;}
                    }];
                }
                
                [result addObject:[modClass modelWithJSON:dic]];//用YYkit的Json转模型
            }
        }
        [rs close];
    }];
//    DBLog(@"%@",SQL);
    return result;
}

+ (NSInteger)TableCount{
    return [[self QuerySchema:Format(@"select count(*) as count from %@ ",[self TableName])].firstObject[@"count"] integerValue];
}

+ (instancetype)FirstModel{
    return [self Select:(Format(@"order by %@ asc limit 1",([self OrderKey] ? : kColumn_id)))].firstObject;
}

+ (instancetype)LastModel{
    return [self Select:(Format(@"order by %@ desc limit 1",([self OrderKey] ? : kColumn_id)))].firstObject;
}

+ (instancetype)Model:(NSString *)primaryKey{
    return [self Select:(Format(@"where %@ = \"%@\"",[self.class PrimaryKey],primaryKey))].firstObject;
}

+ (void)AllModel:(JEDBSelectBlock)done desc:(BOOL)desc{
    [self Select:(Format(@"order by %@ %@",([self OrderKey] ? : kColumn_id),desc ? @"desc" : @"asc")) done:done];
}

+ (NSMutableArray <__kindof JEDBModel *> *)AllModelByDesc:(BOOL)desc{
    return [self Select:(Format(@"order by %@ %@",([self OrderKey] ? : kColumn_id),desc ? @"desc" : @"asc"))];
}

+ (void)SelectFrom:(NSDate *)begin to:(NSDate *)end desc:(BOOL)desc done:(JEDBSelectBlock)done{
    NSString *range = (Format(@"%@ between \"%lld\" and \"%lld\"",kColumn_Date,((long long)[begin timeIntervalSince1970]),((long long)[end timeIntervalSince1970])));
    [self Select:(Format(@"where %@ order by %@ %@",range,kColumn_Date,desc ? @"desc" : @"asc")) done:done];
}

+ (void)SelectByPage:(NSInteger )page size:(NSInteger)size desc:(BOOL)desc done:(JEDBSelectBlock)done{
    [self Select:(Format(@"order by %@ %@ limit %@*%@,%@",[self OrderKey],desc ? @"desc" : @"asc",@(page),@(size),@(size))) done:done];
}

+ (NSMutableArray <__kindof JEDBModel *> *)Select:(NSString *)suffix{
    return [self Query:Format(@"select * from %@ %@",[self TableName],suffix ? : @"")];
}

+ (void)Select:(NSString *)suffix done:(JEDBSelectBlock)done{
    [self Query:Format(@"select * from %@ %@",[self TableName],suffix ? : @"") done:done];
}

+ (NSMutableArray <__kindof JEDBModel *> *)SelectIn:(NSArray <NSString *> *)ids{
    if (ids.count == 0) {return nil; }
    NSMutableString *range = [NSMutableString string];
    for (NSString *key in ids) {[range appendFormat:@"%@%@",range.length ? @"," : @"",key];}
    return [self Select:(Format(@"where %@ in (%@)",[self PrimaryKey],range))];
}

#pragma mark -------------------------------------------删除----------------------------------------------

+ (void)DeleteAll:(JEDBResult)done{
    [self DeleteAllByClass:@[[self class]] done:done];
}

+ (void)DeleteAllByClass:(NSArray <Class> *)classArr done:(JEDBResult)done{
    NSMutableArray <NSString *> *SQLs = [NSMutableArray array];
    for (Class class in classArr) {[SQLs addObject:(Format(@"delete from %@",[class TableName]))];}
    [self ExecuteUpdate:SQLs arguments:nil done:done];
}

+ (void)Delete:(NSArray <NSString *> *)ids{
    [self Delete:ids done:nil];
}

+ (void)Delete:(NSArray <NSString *> *)ids done:(JEDBResult)done{
    if (ids.count == 0) {return; }
    NSMutableString *range = [NSMutableString string];
    for (NSString *key in ids) {[range appendFormat:@"%@%@",range.length ? @"," : @"",key];}
    [self DeleteQuery:(Format(@"where %@ in (%@)",[self PrimaryKey],range)) done:done];
}

+ (void)DeleteQuery:(NSString *)suffix done:(JEDBResult)done{
    [self.class ExecuteUpdate:@[(Format(@"delete from %@ %@",[self TableName],suffix ? : @""))] arguments:nil done:done];
}

- (void)dbDelete{
    NSString *key = [self valueForKey:[self.class PrimaryKey]];
    if ([key isKindOfClass:[NSDate class]]) {
        key = Format(@"%lld",(long long)[(NSDate *)key timeIntervalSince1970]);
    }
    [self.class DeleteQuery:(Format(@"where %@ = \"%@\"",[self.class PrimaryKey],key)) done:nil];
}

//----------------------------------------------------------------------------------------
//@"where a = \"48\" and b = \"75\""
//@"set upload = \"1\" where a = \"49\""

@end
