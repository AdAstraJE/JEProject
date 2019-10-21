
#import "NSDictionary+JE.h"

//JE Object Property Code Type
typedef NS_ENUM(NSUInteger, JEOJPCType) {
    JEOJPCTypeMJExtension,
    JEOJPCTypeYYmodel,
};

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  @interface JEObjcJsonPropertyCreate : NSObject   🔷🔷🔷🔷🔷🔷🔷🔷

@interface JEObjcJsonPropertyCreate : NSObject{
    NSMutableString       *_Str_interface;        //interface Code
    NSMutableString       *_Str_implementation;   //implementation Code
    NSString              *_Str_ModName;
    
    NSMutableDictionary   <NSString *,NSArray *> *_Dic_haveReplacedKey;/**< 有需要替换的键值对 */
    NSMutableDictionary   <NSString *,NSString *> *_Dic_ChildArrClass;/**< dic - dic */
    
    NSString *_Str_arrayClass;
    NSString *_Str_customProperty;
}

/** @[interface,implementation] */
- (NSArray <NSMutableString *>*)JsonPropertyCreateWihtModelName:(NSString*)modName dic:(NSDictionary*)dict type:(JEOJPCType)type;

@end


@implementation JEObjcJsonPropertyCreate

#define __interface         (@("\n%@#pragma mark - 🔷🔷🔷🔷🔷🔷🔷🔷 %@ 🔷🔷🔷🔷🔷🔷🔷🔷 \n@interface %@ : NSObject\n\n%@\n@end\n"))
#define __implementation    (@("@implementation %@\n\n@end\n"))
#define __property          (@("@property (nonatomic,strong) %@  *%@; ///< <#...#>\n"))
#define __propertyCopy      (@("@property (nonatomic,copy)   %@  *%@; ///< <#...#>\n"))
#define __propertyAssign    (@("@property (nonatomic,assign) %@   %@; ///< <#...#>\n"))

- (NSArray <NSMutableString *>*)JsonPropertyCreateWihtModelName:(NSString*)modName dic:(NSDictionary*)dict type:(JEOJPCType)type{
    switch (type) {
        case JEOJPCTypeMJExtension:{
            _Str_arrayClass = @"objectClassInArray";
            _Str_customProperty = @"replacedKeyFromPropertyName";
        } break;
        case JEOJPCTypeYYmodel:{
            _Str_arrayClass = @"modelContainerPropertyGenericClass";
            _Str_customProperty = @"modelCustomPropertyMapper";
        } break;
        default:
            break;
    }
    
    _Str_ModName = modName;
    
    _Str_interface = [(_Str_implementation = [NSMutableString string]) mutableCopy];
    _Dic_ChildArrClass = [(_Dic_haveReplacedKey = [NSMutableDictionary dictionary]) mutableCopy];
    
    [_Str_implementation appendFormat:__implementation,_Str_ModName];
    [_Str_interface appendFormat:__interface,(_Str_interface.length ? @"\n\n" : @""),_Str_ModName,_Str_ModName,[self createCode:dict type:(JEOJPCType)type]];
    
    return @[_Str_interface,[_Str_implementation stringByReplacingOccurrencesOfString:@"@@" withString:@"@"].mutableCopy];
}

- (NSString *)createCode:(id)object type:(JEOJPCType)type{
    if(![object isKindOfClass:[NSDictionary class]]){
        return @"";
    }
    
    NSMutableString  *Str_propertys = [NSMutableString new];
    NSDictionary  *dict_ = object;
    NSArray       *keyArr = [dict_ allKeys];
    
    for (NSInteger idx = 0; idx < dict_.count; idx++)
    {
        NSString *Key = keyArr[idx];
        id subObject = object[Key];
        NSArray *someSpecial = @[@"description",@"class"];
        if ([Key hasPrefix:@"new"] || [Key hasPrefix:@"copy"] || [someSpecial containsObject:Key]) {//id alloc，new，copy，mutableCopy ....
            Key = [Key capitalizedString];
            [_Dic_haveReplacedKey setValue:@[keyArr[idx],Key] forKey:Key];
        }
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        void (^createSubclassBlock)(NSDictionary *ChildDic,Boolean isArr) = ^(NSDictionary *ChildDic,Boolean isArr){
            NSString * ChildclassName = [NSString stringWithFormat:@"%@_%@",self->_Str_ModName,Key];
            [Str_propertys appendFormat:__property,isArr ? [NSString stringWithFormat:@"NSMutableArray  <%@ *>",ChildclassName] : ChildclassName,Key];
            if (isArr) {
                [self->_Dic_ChildArrClass setValue:ChildclassName forKey:Key];
            }
            
            NSArray *nextObj = [[JEObjcJsonPropertyCreate alloc] JsonPropertyCreateWihtModelName:ChildclassName dic:ChildDic type:type];
            [self->_Str_interface appendFormat:@"\n%@",[nextObj firstObject]];
            [self->_Str_implementation appendFormat:@"\n%@",[nextObj lastObject]];
        };
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        NSString *eachProperty;
        
        if([subObject isKindOfClass:[NSDictionary class]]){//-------------------------------------------  NSDictionary
            createSubclassBlock(subObject,NO);
        }else if ([subObject isKindOfClass:[NSArray class]]){//-----------------------------------------  NSArray
            if ([((NSArray*)subObject).firstObject isKindOfClass:[NSDictionary class]]) {//数组里面是模型
                createSubclassBlock(((NSArray*)subObject).firstObject,YES);
            }else{//数组里面其他的  懒得细搞  🙄
                [Str_propertys appendFormat:__property,[NSString stringWithFormat:@"NSMutableArray  <%@ *>",NSStringFromClass([NSObject class])],Key];
            }
            
        }else if ([subObject isKindOfClass:[NSString class]]){//----------------------------------------  NSString
            eachProperty = [NSString stringWithFormat:__propertyCopy,@"NSString",Key];
        }else if([subObject isKindOfClass:[@(YES) class]]){//-------------------------------------------  BOOL
            eachProperty = [NSString stringWithFormat:__propertyAssign,@"BOOL",Key];
            
        }else if ([subObject isKindOfClass:[NSNumber class]]){//----------------------------------------  NSNumber
            BOOL maybeFloat = [[(NSNumber *)subObject stringValue] containsString:@"."];
            eachProperty = [NSString stringWithFormat:__propertyAssign,maybeFloat ? @"CGFloat" : @"NSInteger",Key];
        }else{
//            eachProperty = [NSString stringWithFormat:__property,@"NSObject",Key];//--------------------  NSObject ?
            eachProperty = [NSString stringWithFormat:__propertyCopy,@"NSString",Key];
        }
        
        if (eachProperty) {
            NSString *comment = [NSString stringWithFormat:@"%@",subObject];
            comment = [comment stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            comment = (comment.length >= 128 ? [comment substringToIndex:128] : comment);
            [Str_propertys appendString:[eachProperty stringByReplacingOccurrencesOfString:@"<#...#>" withString:comment]];
        }
        
    }
    
    if ((_Dic_haveReplacedKey).count != 0) {
        NSString *jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:_Dic_haveReplacedKey options:0 error:NULL] encoding:NSUTF8StringEncoding];
        [_Str_implementation insertString:[NSString stringWithFormat:@"+ (NSDictionary *)%@{ \nreturn @%@;\n}\n\n",_Str_customProperty,jsonStr] atIndex:[_Str_implementation rangeOfString:@"@end"].location];
    }
    
    if (_Dic_ChildArrClass.count != 0) {
        __block NSString *jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:_Dic_ChildArrClass options:0 error:NULL] encoding:NSUTF8StringEncoding];
        [_Dic_ChildArrClass enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([jsonStr rangeOfString:obj].location != NSNotFound) {
                jsonStr = [jsonStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\"%@\"",obj] withString:[NSString stringWithFormat:@"[%@ class]",obj]];
            }
        }];
        
        [_Str_implementation insertString:[NSString stringWithFormat:@"+ (NSDictionary *)%@{ \nreturn @%@;\n}\n\n",_Str_arrayClass,jsonStr] atIndex:[_Str_implementation rangeOfString:@"@end"].location];
    }
    
    //构建obcj Code
    BOOL firstChar = YES;
    for (int idx = 0; idx < _Str_implementation.length; idx ++) {
        NSString *chars = [_Str_implementation substringWithRange:NSMakeRange(idx, 1)];
        if ([chars isEqualToString:@"["] && [[_Str_implementation substringWithRange:NSMakeRange(idx + 1, 1)] isEqualToString:@"\""]) {//   is  [
            [_Str_implementation insertString:@"@" atIndex:idx];idx++;
        }
        if ([chars isEqualToString:@"\""]) {//  is  "
            if (firstChar) {
                [_Str_implementation insertString:@"@" atIndex:idx];idx++;
            }
            firstChar = !firstChar;
        }
    }
    
    return Str_propertys;
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  @implementation NSDictionary (JE)   🔷🔷🔷🔷🔷🔷🔷🔷

@implementation NSDictionary (JE)

- (NSString *)je_propertyCodeMJ:(NSString*)modName{
    return [self je_propertyCode:modName type:JEOJPCTypeMJExtension];
}

- (NSString *)je_propertyCodeYY:(NSString*)modName{
    return [self je_propertyCode:modName type:JEOJPCTypeYYmodel];
}

/**  xcode @property (nonatomic, ----- *** */
- (NSString *)je_propertyCode:(NSString*)modName type:(JEOJPCType)type{
#ifdef DEBUG
    NSArray <NSMutableString *> *int_imp = [[JEObjcJsonPropertyCreate alloc] JsonPropertyCreateWihtModelName:modName dic:self type:type];
    NSMutableString *interface = [int_imp firstObject];
    if ([interface containsString:@"CGFloat"]) {
        [interface insertString:@"\n#import <UIKit/UIKit.h>\n" atIndex:0];
    }
    NSString *code = [NSString stringWithFormat:@"// 🔵 ========= @interface ========= \n%@\n// 🔵 ========= @implementation ========= \n\n\n%@",[int_imp firstObject],[int_imp lastObject]];
    NSLog(@"\n\n %@\n",code);
    return code;
#endif
    return nil;
}

/** 将NSDictionary转换成url 参数字符串 */
- (NSString *)URLQueryString{
    NSMutableString *urlString =[NSMutableString string];
    for (id key in self) {
        [urlString appendFormat:@"%@%@=%@",(urlString.length == 0) ? @"?" : @"&",key,[self valueForKey:key]];
    }
    
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end

