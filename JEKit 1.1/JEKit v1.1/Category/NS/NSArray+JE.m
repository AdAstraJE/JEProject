
#import "NSArray+JE.h"
#include <execinfo.h>
#import "NSDictionary+JE.h"

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   NSArray   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation NSArray (JE)

- (NSArray*)je_sortByKey:(NSString*)key asc:(BOOL)ascend{
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




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   NSMutableArray   🔷🔷🔷🔷🔷🔷🔷🔷
@implementation NSMutableArray (SafeAccess)

- (NSMutableArray * (^)(id obj))add{
    return ^id (id obj){
        if (obj) {[self addObject:obj];}else{NSAssert(nil, @"nil");}
        return self;
    };
}

@end


