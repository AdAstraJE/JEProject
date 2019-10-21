
#import <Foundation/Foundation.h>
#import "JEBluetooth+Category.h"

#define Format(...)    ([NSString stringWithFormat:__VA_ARGS__])

#ifdef DEBUG
#define BLELog(fmt, ...)     fprintf(stderr,"%s\n",[[NSString stringWithFormat:@"🔹 " fmt, ##__VA_ARGS__] UTF8String]);
#define BLELog__(fmt, ...) (({NSString *_ = [NSString stringWithFormat:@"🔹 " fmt, ##__VA_ARGS__];fprintf(stderr,"%s\n",[_ UTF8String]); _;}))
#else
#define BLELog(...)
#define BLELog__(fmt, ...)   (@"")
#endif


/** 指令优先度  priority */
typedef NS_ENUM(NSUInteger, JECmdPri) {
    JECmdPriNow = 0,///< 立即写入
    JECmdPriDefault = 1,///< 默认 上一个指令响应后写入
    JECmdPriLow = 2,///< 空闲的时候写入
};

/** 设备指令队列处理 (主要定义指令避免命令硬编码)  */
@interface JEBLECommand : NSObject

/** 既下列定义的指令 转了10进制 */
+ (instancetype)Cmd;

/* eg...  @property (nonatomic,copy) BDH_10 *_FF;///<   _开头定义的指令 ### 先16进制定义 实际值为10进制 */


@property (nonatomic,copy) BDH_10 *cmd;///< 操作命令
@property (nonatomic,copy) NSString  *crt;///< 特征UUID

@property (nonatomic,assign) JECmdPri priority;///< 指令优先度
@property (nonatomic,strong) NSMutableArray <NSObject *> *Arr_byte;///< 原始数据  BDH_10 |  NSNumber

@end
