
#import "JETranslate.h"
#import <CommonCrypto/CommonDigest.h>

#define JELog(fmt, ...)     fprintf(stderr,"%s\n",[[NSString stringWithFormat:@"🔹 " fmt, ##__VA_ARGS__] UTF8String]);

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETranslate   🔷 翻译

@implementation JETranslate

+ (void)Translate:(NSString *)target{
#if DEBUG
    NSArray <NSArray <NSString *> *> *arr = @[
//        @[@"cht",@"繁体中文"],
        @[@"en",@"英语"],
//        @[@"de",@"德语"],
//        @[@"spa",@"西班牙语"],
//        @[@"fra",@"法语"],
//        @[@"it",@"意大利语"],
//        @[@"jp",@"日语"],
//        @[@"pt",@"葡萄牙语"],
//        @[@"pl",@"波兰语"],
//        @[@"ru",@"俄语"],
//        @[@"kor",@"韩语"],
//        @[@"ara",@"阿拉伯语"],
    ];
    
    [arr enumerateObjectsUsingBlock:^(NSArray<NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((float)idx*(1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self Translate:target to:obj.firstObject done:^(JETranslateResult *result, NSError *error) {
                NSMutableString *string = [NSMutableString string];
                [result.trans_result enumerateObjectsUsingBlock:^(TransResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [string appendFormat:@"\n\"%@\" = \"%@\";",obj.src,obj.dst];
                }];
                JELog(@"👁‍🗨%@\n%@\n\n\n",obj.lastObject,string);
            }];
        });
        
    }];
#endif
}


+ (void)Translate:(NSString *)target to:(NSString *)to done:(nullable void(^)(JETranslateResult *result, NSError *error))done{
#if DEBUG
    NSDictionary *secret = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JESecret" ofType:@"plist"]];
    NSString *appid = (secret[@"api.fanyi.baidu_appid"]);
    NSString *appsecret = (secret[@"api.fanyi.baidu_appsecret"]);
    if (appid.length == 0 || appsecret.length == 0 ) {
        JELog(@"🛑appid appsecret");
        return;
    }
    
    NSString *salt = @"JE";
    NSString *q = target;
    
    NSString *from = @"zh";
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.fanyi.baidu.com/api/trans/vip/translate?appid=%@&q=%@&from=%@&to=%@&salt=%@&sign=%@",
                           appid,
                           q,
                           from,
                           to,
                           salt,
                           ([self MD5:[@[appid,q,salt,appsecret] componentsJoinedByString:@""]])];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){ dispatch_async(dispatch_get_main_queue(), ^{ !done ? : done(nil, error);}); return;}
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (dict[@"error_code"]) {
            JELog(@"👁‍🗨 🛑%@ %@",dict[@"error_code"],dict[@"error_msg"]);
        }
        JETranslateResult *result = [[JETranslateResult alloc] initWithDict:dict];
        if (result.error_code.length) {done(nil,[NSError errorWithDomain:@"" code:0 userInfo:dict]);return;}
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (done) {
                done(result, nil);
            }else{
                NSMutableString *string = [NSMutableString string];
                [result.trans_result enumerateObjectsUsingBlock:^(TransResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [string appendFormat:@"\n\"%@\" = \"%@\";",obj.src,obj.dst];
                }];
                JELog(@"👁‍🗨\n%@",string);
            }
        });
    }] resume];
#endif
}

+ (NSString *)MD5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETranslateResult   🔷

@implementation JETranslateResult

- (NSMutableArray <TransResult *> *)trans_result{
    if (_trans_result == nil) { _trans_result = [NSMutableArray array];}
    return _trans_result;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    [self setValuesForKeysWithDictionary:dict];
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"trans_result"]) {
        for (NSDictionary *dict in value) { [self.trans_result addObject:[[TransResult alloc] initWithDict:dict]];}
    }else{
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   TransResult   🔷

@implementation TransResult

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    [self setValuesForKeysWithDictionary:dict];
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
