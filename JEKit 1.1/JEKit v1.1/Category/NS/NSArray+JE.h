
#import <Foundation/Foundation.h>

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   NSArray   🔷🔷🔷🔷🔷🔷🔷🔷
@interface NSArray (JE)

/// 按 字段 给数组排序
- (NSArray*)je_sortByKey:(NSString*)key asc:(BOOL)ascend;

@property (nonatomic,strong,readonly) NSNumber *sum;///< @[@(1),@(2),@"3"] 总和
@property (nonatomic,strong,readonly) NSNumber *max;///< 最大值
@property (nonatomic,strong,readonly) NSNumber *min;///< 最小值
@property (nonatomic,strong,readonly) NSNumber *avg;///< 平均值

@property (nonatomic,strong,readonly) NSNumber *min_;///< 忽略0 最小值
@property (nonatomic,strong,readonly) NSNumber *avg_;///< 忽略0 平均值

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   NSMutableArray   🔷🔷🔷🔷🔷🔷🔷🔷
@interface NSMutableArray(SafeAccess)

/// if (obj != nil) {[self addObject:obj];}
- (NSMutableArray * (^)(id obj))add;

@end




