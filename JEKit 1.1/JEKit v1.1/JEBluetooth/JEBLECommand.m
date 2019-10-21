
#import "JEBLECommand.h"
#import "JEBluetooth.h"
#import <objc/runtime.h>

@implementation JEBLECommand

+ (instancetype)Cmd{
    JEBLECommand *Cmd = [JEBluetooth Shared].commandModel;
    if (Cmd == nil) {
        Cmd = [[self alloc] init];
        [[self ClassPropertyList] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger CommandIdx, BOOL * _Nonnull stop) {
            //指令必须 _ 开头
            if ([obj hasPrefix:@"_"]) {
                NSString *string = [obj stringByReplacingOccurrencesOfString:@"_" withString:@""];
                [Cmd setValue:string._16_to_10 forKey:obj];
            }
        }];
        [JEBluetooth Shared].commandModel = Cmd;
    }
    
    return Cmd;
}

+ (NSArray <NSString *> *)ClassPropertyList {
    NSMutableArray *allProperties = [[NSMutableArray alloc] init];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList(self, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        if (propName) {
            [allProperties addObject:propName];
        }
    }
    free(props);
    return [NSArray arrayWithArray:allProperties];
}

@end
