
#import <Foundation/Foundation.h>

@interface NSDictionary (JE)

/// create YYmodel xcode @property (nonatomic, ----- 
- (NSString *)je_propertyCodeYY:(NSString*)modName;

/// 将NSDictionary转换成url 参数字符串
@property (nonatomic,copy,readonly) NSString *URLQueryString;

@end




