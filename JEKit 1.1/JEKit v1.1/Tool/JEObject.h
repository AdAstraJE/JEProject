
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JEObject : NSObject

+ (instancetype)Cache;///< 唯一缓存
- (void)cache:(void (^_Nullable)(void))block;///< 按className缓存一个模型
- (void)initialConfig;///< 首次创建时配置

@end

NS_ASSUME_NONNULL_END
