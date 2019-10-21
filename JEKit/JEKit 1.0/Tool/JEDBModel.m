
#import "JEDBModel.h"
#import "JEDataBase.h"
#import <objc/runtime.h>
#import "NSObject+YYModel.h"

#ifdef DEBUG
#define DBLog(fmt, ...) fprintf(stderr,"🔹DB %s\n",[[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);
#else
#define DBLog(...)
#endif
#define Format(...)     ([NSString stringWithFormat:__VA_ARGS__])
#define kTEXT_TypeArr   (@[@"@\"NSString\"",@"@\"NSNumber\"",@"@\"NSArray\"",@"@\"NSMutableArray\"",@"@\"NSDictionary\"",@"@\"NSMutableDictionary\""])

static NSString * const kDB_TEXT     =    @"TEXT";
static NSString * const kDB_INTEGER  =    @"INTEGER";
static NSString * const kDB_REAL     =    @"REAL";///< 浮点数

static NSString * const kColumn_id =      @"id";///< 父类 id 字段名
static NSString * const kColumn_Date =    @"date";///< 父类 NSDate 字段名

@implementation JEDBModel

#pragma mark ------------------------------------------可子类重新定义-----------------------------------------------
+ (NSString *)TableName { return NSStringFromClass(self.class);}
+ (NSString *)PrimaryKey{ return @"id";}
+ (NSArray <Class> *)PropertysFromSuper{  return nil;}

#pragma mark ------------------------------------------runTime基本建表等-----------------------------------------------

/** 属性字段名 & 类型 */
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

/** Json&自定义类型的属性名称 */
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

/** NSDate类型的属性名称 */
+ (NSArray <NSString *> *)NSDatePropertys{
    NSMutableArray <NSString *> *filtArr = [NSMutableArray arrayWithArray:@[kColumn_Date]];
    [[self DBModelPropertys] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull type, BOOL * _Nonnull stop) {
        if ([@[@"@\"NSDate\""] containsObject:type]) { [filtArr addObject:key];}
    }];
    return filtArr;
}

/** 属性与表结构类型对应关系 */
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
    DBLog(@"%@\n%@",[self TableName],dbDic);
    return dbDic;
}

#pragma mark -------------------------------------------建表、更新表----------------------------------------------

/** 按约定建表 */
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

/** 更新表，添加缺少的字段 */
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

/** ### UPDATE table (suffix - 传语句后缀) */
+ (void)Update:(NSString *)suffix arguments:(NSArray <id> *)arguments{
    [self ExecuteUpdate:@[(Format(@"update %@ %@",[self TableName],suffix ? : @""))] arguments:@[arguments] done:nil];
}

/** REPLACE 同步一组  (事务操作) */
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

/** REPLACE 同步到数据库 */
- (void)dbSave{
    [self dbSave:nil];
}

- (void)dbSave:(JEDBResult)done{
    NSArray *SQLArguments = [self createReplace_SQL_Arguments];
    [self.class ExecuteUpdate:@[SQLArguments.firstObject] arguments:@[SQLArguments.lastObject] done:done];
}

/** firstObject：SQL字符串，lastObject：Arguments数组 */
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

/** 实际传入SQL的字符拼接 String */
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

/** 子线程 executeUpdate  (arguments个数不为0时 必须 count = SQLArr.count) */
+ (void)ExecuteUpdate:(NSArray <NSString *> *)SQLArr arguments:(NSArray <NSArray <id> *> *)arguments done:(JEDBResult)done{
    if (arguments.count != 0 && arguments.count != SQLArr.count) {DBLog(@"SQL arguments 个数不对应");return;}
    
    BOOL isTransaction = (SQLArr.count > 1);//多条开启事务

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __block NSUInteger successSave = 0;
        [JEdbQe inDatabase:^(FMDatabase * _Nonnull db) {
            if (isTransaction) {[db beginTransaction];}
            
            [SQLArr enumerateObjectsUsingBlock:^(NSString * _Nonnull SQL, NSUInteger idx, BOOL * _Nonnull stop) {
                if (arguments) {
                    [db executeUpdate:SQL withArgumentsInArray:arguments[idx]] ? (successSave++) : (*stop = YES);//withArgumentsInArray
                }else{
                    [db executeUpdate:SQL] ? (successSave++) : (*stop = YES);
                }
            }];
            
            if (isTransaction) {SQLArr.count == successSave ? [db commit] : [db rollback];}//事务结束
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !done ?: done((SQLArr.count == successSave));
//            DBLog(@"%@",(isTransaction ? Format(@"事务操作完成条数：%@",@(successSave)) : Format(@"executeUpdate \n🔸%@🔸\n",SQLArr.firstObject)));
        });
        
    });
}


#pragma mark -------------------------------------------查询----------------------------------------------

/** executeQuery: 返回处理过的模型 */
+ (NSMutableArray <__kindof JEDBModel *> *)Query:(NSString *)SQL{
    return [self Query:SQL orgin:NO];
}

/** executeQuery: 返回处理过的模型 */
+ (void)Query:(NSString *)SQL done:(JEDBSelectBlock)done{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray <__kindof JEDBModel *> *result = [self Query:SQL];
        dispatch_async(dispatch_get_main_queue(), ^{!done ? : done(result); });
    });
}

/**  executeQuery: 返回原始数据 */
+ (NSMutableArray <__kindof JEDBModel *> *)Query:(NSString *)SQL orgin:(BOOL)orgin{
    NSMutableArray <__kindof JEDBModel *> *result = [NSMutableArray array];
    NSArray <NSString *> *NSDatePropertys = [self NSDatePropertys];
    NSArray <NSString *> *JsonPropertys = [self JsonPropertys];
    
    [JEdbQe inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs =  [db executeQuery:SQL];
        while ([rs next]) {
            if (orgin) {
                [result addObject:(id)rs.resultDictionary];
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
                    [dic setValue:[NSDate dateWithTimeIntervalSince1970:[dic[key] longLongValue]] forKey:key];
                }];
                
                [result addObject:[self.class modelWithJSON:dic]];//用YYkit的Json转模型
            }
        }
        [rs close];
    }];
//    DBLog(@"🔸%@🔸",SQL);
    return result;
}

static NSDateFormatter *staticDateFormatter;
- (NSDateFormatter *)staticDateFormatter{
    if (!staticDateFormatter) {
        staticDateFormatter = [[NSDateFormatter alloc] init];
        [staticDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return staticDateFormatter;
}

#pragma mark -   YY 自定义处理
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

/**  executeQuery: 返回原始数据 */
+ (NSArray <NSDictionary *> *)QuerySchema:(NSString *)SQL{
    return (id)[self Query:SQL orgin:YES];
}

/**  表中的行数（数据个数） */
+ (NSInteger)TableCount{
    return [[self QuerySchema:Format(@"select count(*) as count from %@ ",[self TableName])].firstObject[@"count"] integerValue];
}

/** 表中按date排序的第一个 */
+ (instancetype)FirstModel{
    return [self Query:(Format(@"select * from %@ order by %@ asc limit 1",[self TableName],([self PrimaryKey] ? : kColumn_id)))].firstObject;
}

/** 表中按date排序的最后一个 */
+ (instancetype)LastModel{
    return [self Query:(Format(@"select * from %@ order by %@ desc limit 1",[self TableName],([self PrimaryKey] ? : kColumn_id)))].firstObject;
}

/** 表中所有 */
+ (void)AllModel:(JEDBSelectBlock)done desc:(BOOL)desc{
    [self Select:(Format(@"order by %@ %@",([self PrimaryKey] ? : kColumn_id),desc ? @"desc" : @"asc")) done:done];
}

/** 按表中的 date 根据时间范围查找 */
+ (void)SelectFrom:(NSDate *)begin to:(NSDate *)end desc:(BOOL)desc done:(JEDBSelectBlock)done{
    NSString *range = (Format(@"%@ between \"%lld\" and \"%lld\"",kColumn_Date,((long long)[begin timeIntervalSince1970]),((long long)[end timeIntervalSince1970])));
    [self Select:(Format(@"where %@ order by %@ %@",range,kColumn_Date,desc ? @"desc" : @"asc")) done:done];
}

/** 分页查询 size = 每次多少个 */
+ (void)SelectByPage:(NSInteger )page size:(NSInteger)size desc:(BOOL)desc done:(JEDBSelectBlock)done{
    [self Select:(Format(@"order by %@ %@ limit %@*%@,%@",[self PrimaryKey],desc ? @"desc" : @"asc",@(page),@(size),@(size))) done:done];
}

/** ### SELECT * FROM table (suffix - 传语句后缀) */
+ (void)Select:(NSString *)suffix done:(JEDBSelectBlock)done{
    NSString *SQL = Format(@"select * from %@ %@",[self TableName],suffix ? : @"");
    [self Query:SQL done:done];
}

#pragma mark -------------------------------------------删除----------------------------------------------

/** TRUNCATE TABLE 删除全部 */
+ (void)DeleteAll:(JEDBResult)done{
    [self ExecuteUpdate:@[(Format(@"delete from %@",[self TableName]))] arguments:nil done:done];
}

+ (void)DeleteAll{
    [self DeleteAll:nil];
}

/** 根据选定主键ID删除 */
+ (void)Delete:(NSArray <NSString *> *)ids{
    if (ids.count == 0) {return; }
    NSMutableString *inRange = [NSMutableString string];
    [ids enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [inRange appendFormat:@"%@%@",inRange.length ? @"," : @"",key];
    }];
    [self DeleteQuery:(Format(@"where %@ in (%@)",[self PrimaryKey],inRange))];
}

/** DELETE FROM table ---- 传语句后缀 */
+ (void)DeleteQuery:(NSString *)suffix{
    [self.class ExecuteUpdate:@[(Format(@"delete from %@ %@",[self TableName],suffix ? : @""))] arguments:nil done:nil];
}

/** 删除这条数据 */
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
//@"order by date asc limit 1"//获取第一个数据
//@"order by date desc limit 1"//获取最后一个数据

@end
