
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Format(...)    ([NSString stringWithFormat:__VA_ARGS__])
#define Str__(str)     ((str && [str isKindOfClass:[NSString class]]) ? str : @"") ///< 返回字符串 (nil 或格式有问题的至少返回 @"")

#define __Name(...)    (__VA_ARGS__ ? @#__VA_ARGS__ : @#__VA_ARGS__)
#define __jeKey(...)   ([(__VA_ARGS__ ? @#__VA_ARGS__ : @#__VA_ARGS__) componentsSeparatedByString:@"."].lastObject)

@interface NSString (JE)

- (NSString *)loc;              ///< NSLocalizedString(self, nil)
- (UIImage *)img;               ///< [UIImage imageNamed:self]
- (NSString *)value;            ///< nil | 长度为0 返回 nil else 返回原始值
- (NSString *)delSpace;         ///< 去空格 stringByReplacingOccurrencesOfString:@" " withString:@""
- (NSString *(^)(NSString*))del;///< 去掉某些字符
- (NSURL *)url;                 ///< [NSURL URLWithString:(NSString *)CFB
- (NSString *)filePathName;     ///< [self stringByReplacingOccurrencesOfString:@"/" withString:@":"]
- (NSURL *)fileUrl;             ///< [NSURL fileURLWithPath:self]
- (NSDate *)date;               ///< 1970 长时间戳对应的NSDate
- (NSString *)HH_MM;            ///< min -> HH:MM
- (NSString *)escapedXcode;     ///< -> 转义
- (NSData *)data;               ///< -> data
- (NSString *)base64;           ///< -> base64String
- (NSString *)decodeBase64;     ///< 解 base64str 为 string 解不了就返回原始的数值
- (NSDictionary *)jsonDic;      ///< 解 为字典
- (NSArray *)jsonArr;           ///< 解 为数组
- (NSString *)MD5;              ///< 32位大写MD5加密
- (NSString *)f2f;              ///< 数字化 保留两位数 Format(@"%.2f",[self floatValue])
- (NSString *)decimal;          ///< 12345678 -> 12,345,678 NSNumberFormatterDecimalStyle,
- (UIImage*)je_QRcode;          ///< 二维码图片 
- (NSMutableDictionary*)parameters;///< url参数转字典

- (BOOL)isChinese;              ///< 是否中文
- (int)textLength;              ///< 计算字符串长度 1个中文算2 个字符
- (BOOL)je_validateEmail;       ///< 验证邮箱是否合法
- (BOOL)je_checkPhoneNumInput;  ///< 验证手机号码合法性
- (BOOL)isASCII;                ///< 单个字符 是否ASCII码
- (BOOL)is_A_Z_0_9;             ///< 单个字符 验证是否字母数字码
- (BOOL)isNumber;               ///< 单个字符 验证是否是数字
- (BOOL)isLink;                 ///< 是否为链接
- (void)callTel;                ///< 拨打电话

#pragma mark -

+ (NSString *)RandomStr:(NSInteger)length;///< 随机字符串
+ (NSString *)RandomUserName;///< 随机名字
+ (NSString *)RandomIconUrl;///< 随机头像(图片)地址
+ (NSString *)RandomDesc:(NSString *)iconUrl;///< 随机描述
+ (NSString *)StringFrom:(id)obj;///< 解析不同的类型 为字符串 可为nil

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)W;///< 适合的高度 默认 font 宽
- (CGFloat)widthWithFont:(UIFont *)font height:(CGFloat)H;///< 适合的宽度 默认 font 高
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;///< 计算真实文字的Size
- (BOOL)contain:(NSString *)subString;///< 是否包含对应字符
- (NSString *)addStr:(NSString *)string;///< 拼上字符串
- (NSString*)je_limitTo:(NSInteger)limit;///< 限制的最大显示长度字符

/// JE的国际化“脚本” 
+ (void)JE_Locailzable;

@end



@interface NSNumber (JE)

- (NSDate *)date;///<  1970 长时间戳对应的NSDate
- (NSString *)timeDesc;///< eg. 01:28
- (NSString *)timeDesc_;///< eg. 1分28秒

@end
