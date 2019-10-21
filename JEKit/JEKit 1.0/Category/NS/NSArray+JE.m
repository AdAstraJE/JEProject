
#import "NSArray+JE.h"
#include <execinfo.h>
#import "NSDictionary+JE.h"


@implementation NSArray (JE)

/** 按 字段 给数组排序 */
- (NSArray*)je_sortByKey:(NSString*)key Asc:(BOOL)ascend{
    return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascend]]];
}

- (NSNumber *)sum{return [self valueForKeyPath:@"@sum.floatValue"];}
- (NSNumber *)max{return [self valueForKeyPath:@"@max.floatValue"];}
- (NSNumber *)min{return [self valueForKeyPath:@"@min.floatValue"];}
- (NSNumber *)avg{return [self valueForKeyPath:@"@avg.floatValue"];}

- (NSNumber *)min_{
    __block NSNumber *min = self.max;
    [self enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue != 0) {
            if (obj.floatValue < min.floatValue) { min = obj;}
        }
    }];
    return min;
}

- (NSNumber *)avg_{
    __block float total = 0;
    __block float count = 0;
    [self enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue != 0) {
            total += obj.floatValue;
            count += 1;
        }
    }];
    
    return @(count == 0 ? 0 : (total/count));
}

@end


@implementation NSMutableArray (SafeAccess)

- (void)add:(id)obj{
    NSAssert(obj != nil, @"nilwhat");
    if (obj != nil) {[self addObject:obj]; }
}

- (NSMutableArray * (^)(id obj))add{
    return ^id (id obj){
        if (obj != nil) {[self addObject:obj];}
        return self;
    };
}

@end


