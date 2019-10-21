
#import "JEDBModel.h"
#import "JEDataBase.h"
#import <objc/runtime.h>
#import "NSObject+YYModel.h"

#ifdef DEBUG
#define DBLog(fmt, ...) fprintf(stderr,"💾  %s\n",[[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);
#else
#define DBLog(...)
#endif
#define Format(...)     ([NSString stringWithFormat:__VA_ARGS__])
#define kTEXT_TypeArr   (@[@"@\"NSString\"",@"@\"NSNumber\"",@"@\"NSArray\"",@"@\"NSMutableArray\"",@"@\"NSDictionary\"",@"@\"NSMutableDictionary\""])

static NSString * const kDB_TEXT     =    @"TEXT";
static NSString * const kDB_INTEGER  =    @"INTEGER";
static NSString * const kDB_REAL     =    @"REAL";///< 浮点数

static NSString * const kColumn_id =      @"ID";///< 父类 id 字段名
static NSString * const kColumn_Date =    @"date";///< 父类 NSDate 字段名

@implementation JEDBModel

#pragma mark ------------------------------------------可子类重新定义-----------------------------------------------
+ (NSString *)TableName { return NSStringFromClass(self.class);}
+ (NSString *)PrimaryKey{ return @"ID";}
+ (NSArray <Class> *)PropertysFromSuper{  return nil;}

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
        self.date = [NSDate dateWithTimeIntervalSince1970:date.longLongValue];
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
    for (int i = 0; i < count; i++){
        objc_property_t property = propertys[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *type = [NSString stringWithUTF8String:property_copyAttributeValue(property,"T")];
        [propertysDic setValue:type forKey:name];
    }
    free(propertys);
    
    NSArray <Class > *superPro = [self PropertysFromSuper];
    if (superPro.count) {
        [superPro enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = [obj DBModelPropertys];
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
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
    
    [[self DBModelPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull type, BOOL * _Nonnull stop) {
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

/// NSDate类型的属性名称
+ (NSArray <NSString *> *)NSDatePropertys{
    NSMutableArray <NSString *> *filtArr = [NSMutableArray arrayWithArray:@[kColumn_Date]];
    [[self DBModelPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull type, BOOL * _Nonnull stop) {
        if ([@[@"@\"NSDate\""] containsObject:type]) { [filtArr addObject:key];}
    }];
    return filtArr;
}

/// 属性与表结构类型对应关系
+ (NSDictionary <NSString *,NSString *> *)SQLPropertys{
    NSMutableDictionary <NSString *,NSString *> *dbDic = objc_getAssociatedObject(self, __func__);
    if (dbDic) { return dbDic;
    }else{ dbDic  = [NSMutableDictionary dictionary];}
    
    //NSDate按时间戳字符串处理
    NSArray <NSString *> *TEXT = kTEXT_TypeArr;
    NSArray <NSString *> *INTEGER = @[@"i",@"q",@"d",@"b"];
    
    [[self DBModelPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull type, BOOL * _Nonnull stop) {
        if      ([TEXT containsObject:type]) {                          [dbDic setValue:kDB_TEXT forKey:key]; }
        else if ([@"@\"NSDate\"" isEqualToString:type]){                [dbDic setValue:kDB_INTEGER forKey:key]; }
        else if ([INTEGER containsObject:[type lowercaseString]]){      [dbDic setValue:kDB_INTEGER forKey:key]; }
        else if ([@"f" isEqualToString:[type lowercaseString]]){        [dbDic setValue:kDB_REAL forKey:key]; }
        else{                                                           [dbDic setValue:kDB_TEXT forKey:key]; }//其他 按字符串处理
    }];
    
    if ([[self PrimaryKey] isEqualToString:kColumn_id]) { [dbDic setValue:kDB_INTEGER forKey:kColumn_id];}//父类的
    [dbDic setValue:kDB_INTEGER forKey:kColumn_Date];//父类的
    
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
    NSString *autoKey = Format(@"%@ %@ primary key autoincrement,",kColumn_id,kDB_INTEGER);//没有主键时拼上
    NSMutableString *SQL = Format(@"create table if not exists %@ (%@",[self TableName],[self PrimaryKey] ? @"" : autoKey).mutableCopy;
    [[self SQLPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull name, NSString * _Nonnull type, BOOL * _Nonnull stop) {
        [SQL appendFormat:@"%@ %@,",name,type];
    }];
    
    if ([self PrimaryKey]) { [SQL appendFormat:@"primary key(%@) )",[self PrimaryKey]];}
    else{ SQL = [SQL stringByReplacingCharactersInRange:NSMakeRange(SQL.length - 1, 1) withString:@" )"].mutableCopy;}
    
    [self ExecuteUpdate:@[SQL] arguments:nil done:done];
}

+ (void)UpdateTable{
    NSMutableArray <NSString *> *tableColumn = [NSMutableArray array];
    [[self QuerySchema:Format(@"pragma table_info('%@')",[self TableName])] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tableColumn addObject:obj[@"name"]];
    }];
    NSMutableDictionary <NSString *,NSString *> *newColumn = [self SQLPropertys].mutableCopy;
    [newColumn removeObjectsForKeys:tableColumn];
    if (newColumn.count == 0) { return;}
    DBLog(@"%@ 表要新加的字段%@",[self TableName],newColumn);
    [newColumn enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull name, NSString * _Nonnull type, BOOL * _Nonnull stop) {
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
    [[self.class SQLPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString *type, BOOL * _Nonnull stop) {
        [columnName appendFormat:@"%@%@",columnName.length ? @"," : @"",key];
        [columnValue appendFormat:@"%@%@",columnValue.length ? @"," : @"",@"?"];
        [arguments addObject:[self columnValue:[self valueForKey:key] type:[self.class SQLPropertys][key]]];
    }];
    NSString *SQL = Format(@"replace into %@ (%@) values (%@)",[self.class TableName],columnName,columnValue);
    return @[SQL,arguments];
}

/// 实际传入SQL的字符拼接 String
- (NSString *)columnValue:(id)value type:(NSString *)type{
    if ([type isEqualToString:kDB_TEXT]) {
        if(value && ([NSBundle bundleForClass:[value class]] == [NSBundle mainBundle])){//自定义的类
            return [value modelToJSONString] ? : @"";
        }
        if (value == nil || [value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            return (Format(@"%@",value ? : @""));
        }
        
        return [value modelToJSONString];
    }else if ([value isKindOfClass:[NSDate class]]){
        return Format(@"%lld",(long long)[(NSDate *)value timeIntervalSince1970]);//NSDate按时间戳处理 1970
    }else{
             
    }
    return Format(@"%@",value);
}

/// 子线程 executeUpdate  (arguments个数不为0时 必须 count = SQLArr.count)
+ (void)ExecuteUpdate:(NSArray <NSString *> *)SQLArr arguments:(NSArray <NSArray <id> *> *)arguments done:(JEDBResult)done{
    if (arguments.count != 0 && arguments.count != SQLArr.count) {DBLog(@"⚠️SQL arguments 个数不对应");return;}
    
    BOOL isTransaction = (SQLArr.count > 1);//多条开启事务
    if (JEdbQe == nil) {DBLog(@"⚠️未打开");}

    __block NSUInteger suc = 0;
    [JEdbQe inDatabase:^(FMDatabase * _Nonnull db) {
        if (isTransaction) {[db beginTransaction];}
        
        [SQLArr enumerateObjectsUsingBlock:^(NSString * _Nonnull SQL, NSUInteger idx, BOOL * _Nonnull stop) {
            if (arguments) {
                [db executeUpdate:SQL withArgumentsInArray:arguments[idx]] ? (suc++) : (*stop = YES);//withArgumentsInArray
            }else{
                [db executeUpdate:SQL] ? (suc++) : (*stop = YES);
            }
        }];
        
        if (isTransaction) {SQLArr.count == suc ? [db commit] : [db rollback];}//事务结束
    }];
    DBLog(@"%@",(isTransaction ? Format(@"事务操作：%@条, %@",@(suc),(suc == SQLArr.count ? @"" : @"🔴失败")) : Format(@"%@",SQLArr.firstObject)));
    
    !done ?: done((SQLArr.count == suc));
}


#pragma mark -------------------------------------------查询----------------------------------------------

+ (void)Query:(NSString *)SQL done:(JEDBSelectBlock)done{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
    NSArray <NSString *> *NSDatePropertys = [self NSDatePropertys];
    NSArray <NSString *> *JsonPropertys = [self JsonPropertys];
    
    if (dbQe == nil) {DBLog(@"⚠️未打开");}
    [dbQe inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs =  [db executeQuery:SQL];
        while ([rs next]) {
            if (modClass == nil) {
                [result addObject:rs.resultDictionary];
            }else{
                NSMutableDictionary *dic = (NSMutableDictionary *)rs.resultDictionary;
                
                [JsonPropertys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *jsonStr = dic[key];
                    if ([jsonStr isKindOfClass:[NSNull class]]) { jsonStr = @"";}
                    if (jsonStr) {
                        NSObject *jsonValue = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                        [dic setValue:jsonValue forKey:key];
                    }
                }];
                
                [NSDatePropertys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDate *date = dic[key];
                    if ([date isKindOfClass:NSDate.class]) {
                        [dic setValue:date forKey:key];
                    }else{
                        [dic setValue:[NSDate dateWithTimeIntervalSince1970:[dic[key] longLongValue]] forKey:key];
                    }
                }];
                
                [result addObject:[modClass modelWithJSON:dic]];//用YYkit的Json转模型
            }
        }
        [rs close];
    }];
    DBLog(@"%@",SQL);
    return result;
}

+ (NSInteger)TableCount{
    return [[self QuerySchema:Format(@"select count(*) as count from %@ ",[self TableName])].firstObject[@"count"] integerValue];
}

+ (instancetype)FirstModel{
    return [self Select:(Format(@"order by %@ asc limit 1",([self PrimaryKey] ? : kColumn_id)))].firstObject;
}

+ (instancetype)LastModel{
    return [self Select:(Format(@"order by %@ desc limit 1",([self PrimaryKey] ? : kColumn_id)))].firstObject;
}

+ (instancetype)Model:(NSString *)primaryKey{
    return [self Select:(Format(@"where %@ = \"%@\"",[self.class PrimaryKey],primaryKey))].firstObject;
}

+ (void)AllModel:(JEDBSelectBlock)done desc:(BOOL)desc{
    [self Select:(Format(@"order by %@ %@",([self PrimaryKey] ? : kColumn_id),desc ? @"desc" : @"asc")) done:done];
}

+ (NSMutableArray <__kindof JEDBModel *> *)AllModelByDesc:(BOOL)desc{
    return [self Select:(Format(@"order by %@ %@",([self PrimaryKey] ? : kColumn_id),desc ? @"desc" : @"asc"))];
}

+ (void)SelectFrom:(NSDate *)begin to:(NSDate *)end desc:(BOOL)desc done:(JEDBSelectBlock)done{
    NSString *range = (Format(@"%@ between \"%lld\" and \"%lld\"",kColumn_Date,((long long)[begin timeIntervalSince1970]),((long long)[end timeIntervalSince1970])));
    [self Select:(Format(@"where %@ order by %@ %@",range,kColumn_Date,desc ? @"desc" : @"asc")) done:done];
}

+ (void)SelectByPage:(NSInteger )page size:(NSInteger)size desc:(BOOL)desc done:(JEDBSelectBlock)done{
    [self Select:(Format(@"order by %@ %@ limit %@*%@,%@",[self PrimaryKey],desc ? @"desc" : @"asc",@(page),@(size),@(size))) done:done];
}

+ (NSMutableArray <__kindof JEDBModel *> *)Select:(NSString *)suffix{
    return [self Query:Format(@"select * from %@ %@",[self TableName],suffix ? : @"")];
}

+ (void)Select:(NSString *)suffix done:(JEDBSelectBlock)done{
    [self Query:Format(@"select * from %@ %@",[self TableName],suffix ? : @"") done:done];
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
    if (ids.count == 0) {return; }
    NSMutableString *range = [NSMutableString string];
    for (NSString *key in ids) {[range appendFormat:@"%@%@",range.length ? @"," : @"",key];}
    [self DeleteQuery:(Format(@"where %@ in (%@)",[self PrimaryKey],range))];
}

+ (void)DeleteQuery:(NSString *)suffix{
    [self.class ExecuteUpdate:@[(Format(@"delete from %@ %@",[self TableName],suffix ? : @""))] arguments:nil done:nil];
}

- (void)dbDelete{
    NSString *key = [self valueForKey:[self.class PrimaryKey]];
    if ([key isKindOfClass:[NSDate class]]) {
        key = Format(@"%lld",(long long)[(NSDate *)key timeIntervalSince1970]);
    }
    [self.class DeleteQuery:(Format(@"where %@ = \"%@\"",[self.class PrimaryKey],key))];
}

//----------------------------------------------------------------------------------------
//@"where bpm = \"48\" and bpL = \"75\""
//@"set upload = \"1\" where bpm = \"49\""

@end
