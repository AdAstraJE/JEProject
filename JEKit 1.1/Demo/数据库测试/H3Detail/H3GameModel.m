
#import "H3GameModel.h"



@implementation H3ArmModel

+ (NSString *)PrimaryKey{ return @"name";}

@end





@implementation H3HeroModel

+ (NSString *)PrimaryKey{ return @"name";}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"arms" : [H3ArmModel class]};
}

- (NSMutableArray<H3ArmModel *> *)arms{
    if (_arms == nil) {
        _arms = [NSMutableArray array];
    }
    return _arms;
}

@end




@implementation H3GameModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"heros" : [H3HeroModel class]};
}

@end
