//
//  NSString+JE.h
//
//
//  Created by JE on 15/6/15.
//  Copyright © 2015年 JE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Format(...)    ([NSString stringWithFormat:__VA_ARGS__])
#define Str__(str)     ((str && [str isKindOfClass:[NSString class]]) ? str : @"") ///< 返回字符串 (nil 或格式有问题的至少返回 @"")

#define __Name(...)    (__VA_ARGS__ ? @#__VA_ARGS__ : @#__VA_ARGS__)
#define __jeKey(...)   ([(__VA_ARGS__ ? @#__VA_ARGS__ : @#__VA_ARGS__) componentsSeparatedByString:@"."].lastObject)

@interface NSString (JE)

@property (nonatomic,strong,readonly) NSString *loc;///< NSLocalizedString(self, nil)
@property (nonatomic,strong,readonly) UIImage *img;///< [UIImage imageNamed:self]
@property (nonatomic,copy,readonly) NSString *value;///< nil | 长度为0 返回 nil else 返回原始值
@property (nonatomic,copy,readonly) NSString *delSpace;///< 去空格 stringByReplacingOccurrencesOfString:@" " withString:@""
- (NSString *(^)(NSString*))del;///< 去掉字符
@property (nonatomic,copy,readonly) NSURL *url;///< [NSURL URLWithString:(NSString *)CFB
@property (nonatomic,strong,readonly) NSDate *Date;///<  1970 长时间戳对应的NSDate
@property (nonatomic,strong,readonly) NSString *HH_MM;///<  分钟 转 HH:MM
@property(nonatomic,copy,readonly)  NSData    *data;///< 转为 data
@property (nonatomic,copy,readonly) NSString  *base64;///< 转为 base64String
@property (nonatomic,copy,readonly)   NSString        *decodeBase64;///< 解 base64str 为 Str 解不了就返回原始的数值
@property (nonatomic,strong,readonly) NSDictionary    *JsonDic;///<  解 为字典 if 有
@property (nonatomic,strong,readonly) NSArray         *JsonArr;///< 解 为数组 if 有


#pragma mark -

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)W;///< 适合的高度 默认 font 宽
- (CGFloat)widthWithFont:(UIFont *)font height:(CGFloat)H;///< 适合的宽度 默认 font 高
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;///< 计算真实文字的Size
- (BOOL)containStr:(NSString *)subString;///< 是否包含对应字符
- (NSString *)addStr:(NSString *)string;///< 拼上字符串

@property (nonatomic,copy,readonly) NSString *MD5;///< 32位大写MD5加密
@property (nonatomic,copy,readonly) NSString *SHA1;///< SHA1加密
@property (nonatomic,copy,readonly) NSString *F2f;///< 数字化 保留两位数 [NSString stringWithFormat:@"%.2f",[self floatValue]]
@property (nonatomic,copy,readonly) NSString *DS;///< NSNumberFormatterDecimalStyle

- (UIImage*)je_QRcode;///< 二维码图片 可以 再用JE_Resize>>放大一下

- (BOOL)isChinese;///< 是否中文
- (int)textLength;///< 计算字符串长度 1个中文算2 个字符
- (NSString*)LimitMaxTextShow:(NSInteger)limit;///< 限制的最大显示长度字符

- (BOOL)validateEmail;///< 验证邮箱是否合法
- (BOOL)checkPhoneNumInput;///< 验证手机号码合法性
- (BOOL)isASCII;///< 是否ASCII码
- (BOOL)is_A_Z_0_9;///< 验证是否字母数字码
- (BOOL)isNumber;///< 验证是否是数字

+ (NSString *)RandomStr:(NSInteger)length;///< 随机字符串
+ (NSString *)RandomUserName;///< 随机名字
+ (NSString *)RandomIconUrl;///< 随机头像(图片)地址
+ (NSString *)RandomDesc:(NSString *)iconUrl;///< 随机描述
+ (NSString *)StringFrom:(id)obj;///< 解析不同的类型 为字符串 可为nil

- (void)callTelephone;///< 当做电话 打

#pragma mark - 网站地址 转码 解码

@property (nonatomic, assign, readonly) BOOL isNetUrl;///< 是否为链接
@property (nonatomic, copy, readonly) NSMutableDictionary *parameters;///< url参数转字典

/** JE的国际化“脚本” */
+ (void)JE_Locailzable;

@end



@interface NSNumber (JE)

@property (nonatomic,strong,readonly) NSDate *Date;///<  1970 长时间戳对应的NSDate

@end
