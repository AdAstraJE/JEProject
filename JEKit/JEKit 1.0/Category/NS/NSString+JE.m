
#import "NSString+JE.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (JE)

- (NSString *)loc{
    return NSLocalizedString(self, nil);
}

- (UIImage *)img{
    return [UIImage imageNamed:self];
}

- (NSString *)value{
    return self.length == 0 ? nil : self;
}

/** 去空格  */
- (NSString *)delSpace{
    NSString *_ = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/** 去掉字符 */
- (NSString *(^)(NSString*))del{
    return  ^NSString * (NSString *delStr) {
        NSString *_ = [self stringByReplacingOccurrencesOfString:delStr withString:@""];
        return _;
    };
}

//时间戳对应的NSDate
- (NSDate *)Date{
    return [NSDate dateWithTimeIntervalSince1970:self.longLongValue];
}

- (NSString *)HH_MM{
   return [NSString stringWithFormat:@"%.2d:%.2d",self.intValue/60,self.intValue%60];
}

//转为 Data
- (NSData*)data{
    return   [self dataUsingEncoding:NSUTF8StringEncoding];
}

// 转为 base64String
- (NSString*)base64{
    return  [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

//解 base64为Str 解不了就返回原始的数值
- (NSString*)decodeBase64{
    NSString *WillDecode = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:self options:0] encoding:NSUTF8StringEncoding];
    return (WillDecode.length != 0) ? WillDecode : self;
}

// 解 为字典 if 有
- (NSDictionary*)JsonDic{
    return [NSJSONSerialization  JSONObjectWithData:self.data options:NSJSONReadingMutableContainers  error:nil];
}

// 解 为数组 if 有
- (NSArray*)JsonArr{
    return [NSJSONSerialization  JSONObjectWithData:self.data options:NSJSONReadingMutableContainers  error:nil];
}

- (NSURL *)url{
    return [NSURL URLWithString:[self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

#pragma mark -

//适合的高度 默认 systemFontOfSize:font]
- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)W{
    return [self boundingRectWithSize:CGSizeMake(W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
}

//适合的宽度 默认 systemFontOfSize:font]
- (CGFloat)widthWithFont:(UIFont *)font height:(CGFloat)H{
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, H) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.width;
}

//真实string的Size
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//是否包含对应字符
- (BOOL)containStr:(NSString *)subString{
    if (!subString) {return NO;}
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}
//拼上字符串
- (NSString *)addStr:(NSString *)string{
    if(!string || string.length == 0){return self;}
    return [self stringByAppendingString:string];
}

//32位MD5加密
- (NSString *)MD5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}
//SHA1加密
- (NSString *)SHA1{
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return [result copy];
}

- (NSString *)F2f{
    return [NSString stringWithFormat:@"%.2f",[self floatValue]];
}

static NSNumberFormatter *_DS_numFormatter;
- (NSString *)DS{
    if (!_DS_numFormatter) {
        _DS_numFormatter = [[NSNumberFormatter alloc] init];
        [_DS_numFormatter setNumberStyle:(NSNumberFormatterDecimalStyle)];
    }
    return [_DS_numFormatter stringFromNumber:@(self.integerValue)];
}

- (UIImage*)je_QRcode{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    [filter setValue:[self dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    CIContext *context1 = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context1 createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:1 orientation:UIImageOrientationUp];

    CGImageRelease(cgImage);
    return image;
}


#pragma mark -

//是否中文
- (BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
//计算字符串长度 1中文2字符
- (int)textLength{
    float number = 0.0;
    for (int index = 0; index < [self length]; index++) {
        NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)  {
            number = number + 2;
        }  else {
            number = number + 1;
        }
    }
    return ceil(number);
}
//限制最大显示长度
- (NSString*)LimitMaxTextShow:(NSInteger)limit{
    NSString *Orgin = [self copy];
    for (NSInteger i = Orgin.length; i > 0; i--) {
        NSString *Get = [Orgin substringToIndex:i];
        if (Get.textLength <= limit) {
            return Get;
        }
    }
    return self;
}


//邮箱格式验证
- (BOOL)validateEmail{
    NSString *emailRegex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//手机号格式验证
- (BOOL)checkPhoneNumInput{
    NSString *Phoneend = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([Phoneend hasPrefix:@"1"] && Phoneend.textLength == 11) {
        return YES;
    }
    return NO;
}

//验证是否字母数字码
//@"@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/"""
//isASCII @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/"
- (BOOL)isASCII{
    return [self haveCharater:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/"];
}

- (BOOL)is_A_Z_0_9{
    return [self haveCharater:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"];
}

// 验证是否是数字
- (BOOL)isNumber{
    return  [self haveCharater:@"0123456789"];
}

- (BOOL)haveCharater:(NSString*)string{
    NSRange specialrang =  [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:string]];
    return (specialrang.location != NSNotFound);
}


//随机字符串
+ (NSString *)RandomStr:(NSInteger)N{
#ifdef DEBUG
    if (N == 0) {  N = 1;}
//    NSString *sourceString = @"你我他她它上下左右东南西北前后人物无";
    NSString *sourceString = @"一二三四五六七八九十";
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < N; i++){
        [result appendString:[sourceString substringWithRange:NSMakeRange(rand() % [sourceString length], 1)]];
    }
    return result;
#endif
    return nil;
}

+(NSString *)RandomUserName{
#ifdef DEBUG
    NSArray *arr = @[@"保尔柯察金",@"安达利尔",@"迪亚波罗",@"墨菲斯托",@"泰瑞尔",@"丹妮莉丝",@"罗德-哈特",@"凯琳",@"耿纳",@"山德鲁",@"骑士",@"牧师",@"巡逻兵",@"德鲁伊",@"炼金术士",@"术士",@"异教徒",@"驯兽师",@"女巫",@"元素使",@"色不异空",@"空不异色",@"色即是空",@"空即是色",@"受想行识",@"亦复如是",@"不生不灭",@"不垢不净",@"不增不减",@"苦集灭道",@"心无挂碍"];
    return arr[arc4random_uniform((int)arr.count)];
#endif
    return @"";
}

+ (NSString *)RandomIconUrl{
#ifdef DEBUG
    return Format(@"https://jieqi.supfree.net/huge/%@.jpg",@(arc4random_uniform(24) + 1));
//    return Format(@"https://img.supfree.net/jieqi/images/%@.jpg",@(arc4random_uniform(24) + 1));
#endif
    return @"";
}

+ (NSString *)RandomDesc:(NSString *)iconUrl{
#ifdef DEBUG
    NSInteger idx = @(arc4random_uniform(24) + 1).integerValue;
    if (iconUrl.length) {
        idx = [[iconUrl componentsSeparatedByString:@"huge/"].lastObject componentsSeparatedByString:@"."].firstObject.integerValue;
    }
    if (idx == 1) {return @"立春：立是开始的意思，立春就是春季的开始。";}
    if (idx == 2) {return @"雨水：降雨开始，雨量渐增。";}
    if (idx == 3) {return @"惊蛰：蛰是藏的意思。惊蛰是指春雷乍动，惊醒了蛰伏在土中冬眠的动物。";}
    if (idx == 4) {return @"春分：分是平分的意思。春分表示昼夜平分。";}
    if (idx == 5) {return @"清明：天气晴朗，草木繁茂。";}
    if (idx == 6) {return @"谷雨：雨生百谷。雨量充足而及时，谷类作物能茁壮成长。";}
    if (idx == 7) {return @"立夏：夏季的开始。";}
    if (idx == 8) {return @"小满：麦类等夏熟作物籽粒开始饱满。";}
    if (idx == 9) {return @"芒种：麦类等有芒作物成熟。";}
    if (idx == 10) {return @"夏至：炎热的夏天来临。";}
    if (idx == 11) {return @"小暑：暑是炎热的意思。小暑就是气候开始炎热。";}
    if (idx == 12) {return @"大暑：一年中最热的时候。";}
    if (idx == 13) {return @"立秋：秋季的开始。";}
    if (idx == 14) {return @"处暑：处是终止、躲藏的意思。处暑是表示炎热的暑天结束。";}
    if (idx == 15) {return @"白露：天气转凉，露凝而白。";}
    if (idx == 16) {return @"秋分：昼夜平分。";}
    if (idx == 17) {return @"寒露：露水以寒，将要结冰。";}
    if (idx == 18) {return @"霜降：天气渐冷，开始有霜。";}
    if (idx == 19) {return @"立冬：冬季的开始。";}
    if (idx == 20) {return @"小雪：开始下雪。";}
    if (idx == 21) {return @"大雪：降雪量增多，地面可能积雪。";}
    if (idx == 22) {return @"冬至：寒冷的冬天来临。";}
    if (idx == 23) {return @"小寒：气候开始寒冷。";}
    if (idx == 24) {return @"大寒：一年中最冷的时候。";}
#endif
    return @"";
}


/** 解析不同的类型 为字符串 可为nil */
+ (NSString *)StringFrom:(id)obj{
    NSString *desStr = nil;
    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
        desStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
    }else if ([obj isKindOfClass:[NSString class]]){
        desStr = obj;
    }else if ([obj isKindOfClass:[NSNumber class]]){
        desStr = ((NSNumber *)obj).stringValue;
    }else if (obj){
        desStr = [NSString stringWithFormat:@"%@",obj];
    }
    return desStr;
}

- (void)callTelephone{
    UIWebView *callWebview = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.delSpace]];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [callWebview loadRequest:[NSURLRequest requestWithURL:url]];
        [([[UIApplication sharedApplication] delegate]).window addSubview:callWebview];
    }
}

#pragma mark - 网站地址 转码 解码

- (BOOL)isNetUrl{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http+:[^\\s]*"] evaluateWithObject:self];
}

- (NSMutableDictionary *)parameters{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *key = [kv objectAtIndex:0];
        if ([key rangeOfString:@"?"].location != NSNotFound) {
            key = [key substringFromIndex:[key rangeOfString:@"?"].location + 1];
        }
        NSString *val = [[kv objectAtIndex:1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [params setObject:val forKey:key];
    }
    return params;
}

#define JELog(fmt, ...)     fprintf(stderr,"%s\n",[[NSString stringWithFormat:@"" fmt, ##__VA_ARGS__] UTF8String]);
+ (void)JE_Locailzable{
#if TARGET_OS_SIMULATOR
    //InfoPlist
    //Localizable
    NSString *JEBaseLang = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JEBaseLang" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray <NSString *> *baseArr = [JEBaseLang componentsSeparatedByString:@"\n"];
//    baseArr = [JEBaseLang componentsSeparatedByString:@"\r"];
    NSMutableString *willTranslate = [NSMutableString string];//粘贴到网上翻译的
    
    NSMutableArray <NSString *> *filterArr = [NSMutableArray array];
    [baseArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length) {
            if ([obj containStr:@"\" = \""]) {
                [filterArr addObject:[[obj componentsSeparatedByString:@"\" = \""].firstObject stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
            }else{
                [filterArr addObject:obj];
            }
        }
    }];
    
    NSString *JELang = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JELang" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray <NSString *> *TranslateArr = [JELang componentsSeparatedByString:@"\n"].mutableCopy;
//    TranslateArr = [JELang componentsSeparatedByString:@"\r"].mutableCopy;
    if (TranslateArr.lastObject.length == 0) {
        [TranslateArr removeLastObject];
    }
    BOOL translate = NO;
    NSMutableString *Locailzable = [NSMutableString string];//复制到 Locailzable 的
    if (filterArr.count == TranslateArr.count) {
        translate = YES;
    }else{
        NSLog(@"%@ - %@ 🔴不对应翻译个数",@(filterArr.count),@(TranslateArr.count));
    }
    
    [filterArr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        if (str.length) {
            NSArray <NSString *> *arr = [str componentsSeparatedByString:@"="];
            NSString *left = arr.firstObject.delSpace;
            [willTranslate appendFormat:@"%@\n",[left stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
            if (![left hasPrefix:@"\""]) {
                left = [NSString stringWithFormat:@"\"%@\"",left];
            }
            if (translate) {
                NSString *insert = TranslateArr[idx];
                insert = insert.del(@"\r");
                insert = [insert capitalizedString];
                [Locailzable appendString:[NSString stringWithFormat:@"%@ = \"%@\";\n",left,insert]];
            }
        }else{
            [willTranslate appendString:@"\n"];
            [Locailzable appendString:@"\n"];
        }
    }];

    if (Locailzable.length) {
        JELog(@"%@",Locailzable);
        return;
    }
    NSLog(@"\n%@",willTranslate);
    TranslateArr = nil;
#endif
}

@end



@implementation NSNumber (JE)

//时间戳对应的NSDate
- (NSDate *)Date{
    return [NSDate dateWithTimeIntervalSince1970:self.longLongValue];
}

@end

