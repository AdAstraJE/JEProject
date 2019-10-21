
#import <Foundation/Foundation.h>
@class TransResult;
@class JETranslateResult;
//    http://api.fanyi.baidu.com/api/trans/product/apidoc

NS_ASSUME_NONNULL_BEGIN

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETranslate   🔷 翻译
@interface JETranslate : NSObject

/** 翻译 */
+ (void)Translate:(NSString *)target;

/** 翻译 */
+ (void)Translate:(NSString *)target to:(NSString *)to done:(nullable void(^)(JETranslateResult *result, NSError *error))done;

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   JETranslateResult   🔷
@interface JETranslateResult : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *error_code;
@property (nonatomic, copy) NSString *error_msg;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *from;

@property (nonatomic, strong) NSMutableArray <TransResult *> *trans_result;

@end


#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   TransResult   🔷
@interface TransResult : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *src;///< 要翻译的
@property (nonatomic, copy) NSString *dst;///< 翻译结果

@end


NS_ASSUME_NONNULL_END
