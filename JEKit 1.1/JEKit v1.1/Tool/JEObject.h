
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JEObject : NSObject

/// 唯一缓存
+ (instancetype)Cache;

/// 按className缓存一个模型
- (void)cache:(void (^_Nullable)(void))block;

/// 首次创建时配置
- (void)initialConfig;

@end

NS_ASSUME_NONNULL_END
