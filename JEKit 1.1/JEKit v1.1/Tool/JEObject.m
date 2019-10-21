
#import "JEObject.h"
#import "JEDataBase.h"
#import "NSObject+YYModel.h"

@implementation JEObject

+ (instancetype)Cache{
    JEObject *obj = [self modelWithJSON:[[JEDataBase JEObjectCache] objectForKey:NSStringFromClass([self class])]];
    if (obj == nil) {
        obj = [[self alloc] init];
        [obj initialConfig];
        [obj cache:nil];
    }
    return obj;
}

- (void)cache:(void (^_Nullable)(void))block{
    [[JEDataBase JEObjectCache] setObject:[self modelToJSONObject] forKey:NSStringFromClass([self class]) withBlock:block];
}

- (void)initialConfig{
    
}

@end
