
#import <Foundation/Foundation.h>
#import "JEBLECommand.h"

/// 写入完成的回调
typedef void (^BLE_didWriteValueBlock)(NSError *error);
/// 读取通知回调
typedef void (^BLE_readNotifyBlock)(CBCharacteristic *crt,NSError *error);

@interface JEBLEDevice : NSObject

#pragma mark ---------------------------- 子类重新定义或调用的 ----------------------------
@property(nonatomic,assign)  BOOL autoReconnect;///< 异常断开需要自动重连或重现打开APP重连 ### 默认YES
@property (nonatomic,strong) NSArray <NSString *> *Arr_recordUUID;///< 筛选包含的特征UUID
@property (nonatomic,strong) NSDictionary <NSString *,NSString *> *Dic_debug;///< debug打印用的 特征对应的描述 ###默认nil
@property (nonatomic,copy)   NSString *singleCmdUUID;///< 单写入特征 指令队列操作时的默认特征UUID ### 默认nil
@property (nonatomic,assign) NSTimeInterval timeoutInterval;///< 指令队列反馈超时时间间隔 默认 5秒

/// 子类重写 根据获取的adData 解析出Mac地址
- (NSString *)analysisMac;

/// 子类重写 JEBluetooth 的 scanPeripheral 筛选可显示出来的设备 ### 默认有mac name可显
- (BOOL)siftCanDisplayDevice;

/// 子类重写 (构建指令完整bytes，默认cmd放在第一位，其他情况子类处理)
- (NSMutableArray <NSObject *> *)createCmd:(BDH_10 *)cmd data:(NSArray <NSObject *> *)data;

/// 子类重写log详情
- (NSString *)writeDebugInfoFrom:(NSArray <NSObject *> *)data;

/// 指令队列操作时 子类调用,不重写 (判断收到反馈的cmd,指令队列的可以写入下一个指令了)
- (void)receiveFeedbackCmd:(BDH_10 *)feedbackCmd;


#pragma mark ---------------------------- 基本属性&方法 ----------------------------
@property(nonatomic,strong) CBPeripheral *peripheral;///< 持有的
@property(nonatomic,strong) NSNumber *RSSI;///< RSSI
@property(nonatomic,copy)   NSDictionary *adData;///< advertisementData
@property(nonatomic,assign) BOOL didConnect;///< 持有连接成功 并链接完特征
@property(nonatomic,copy)   NSString *name;///< peripheral.name
@property(nonatomic,copy)   NSString *UUID;///< peripheral.identifier.UUIDString
@property(nonatomic,copy)   NSString *className;///< className
@property(nonatomic,assign) BOOL control;///< 群控时判断 是否选择性控制
@property(nonatomic,copy)   NSString *nickName;///< 重新定义的名字
//----------------------------------------------------------------------------------------------------
@property(nonatomic,copy)   NSString *mac;///< mac地址 大写 : 隔开
@property(nonatomic,copy)   NSString *version;///< 版本号
@property(nonatomic,copy)   NSString *firmware;///< 固件名称
@property (nonatomic,copy)  NSString *haveNewVersion;///< 固件有新版本更新 nil 0 1  仅获取一次
@property(nonatomic,copy)   NSString *battery;///< nil为未获取 电量 0 ~ 100
//----------------------------------------------------------------------------------------------------
@property(nonatomic,assign) NSInteger serviceCount;///< 需要链接的服务数量 用于判断完全链接完了才算设备连接成功
@property(nonatomic,assign) NSInteger linkedService;///< 链接过的服务数量
@property (nonatomic,strong) NSMutableDictionary <NSString *,CBCharacteristic *> *Dic_crts;///< 筛选后的特征

/// 保存设备到设备列表
- (void)saveDevice;




#pragma mark ---------------------------- 主动操作 ----------------------------

/// 根据特征UUID --- 读取值 block处理完置nil
- (void)read:(NSString *)UUID done:(BLE_readNotifyBlock)done;

/// 根据特征UUID --- 开启通知  记得要主动停止 stopNotify:
- (void)notify:(NSString *)UUID done:(BLE_readNotifyBlock)done;

/// 根据特征UUID --- 停止通知
- (void)stopNotify:(NSString *)UUID;

/// 根据特征UUID --- 直接写入
- (NSError *)write:(NSArray <NSObject *> *)arr crt:(NSString *)UUID done:(BLE_didWriteValueBlock)done;



#pragma mark ---------------------------- 指令队列操作 ----------------------------

/// 单特征 队列添加指令bytes 避免硬编码 cmd也可不传 子类需配置 singleCmdUUID JECmdPriDefault
- (void)cmd:(BDH_10 *)cmd data:(NSArray <NSObject *> *)data;

/// 单特征 队列添加指令bytes 避免硬编码 cmd也可不传 子类需配置 singleCmdUUID
- (void)cmd:(BDH_10 *)cmd data:(NSArray <NSObject *> *)data pri:(JECmdPri)pri;

/// 队列添加指令bytes 避免硬编码 cmd也可不传 子类需配置 singleCmdUUID --- 也可指定特征
- (void)cmd:(BDH_10 *)cmd data:(NSArray <NSObject *> *)data pri:(JECmdPri)pri crt:(NSString *)crt;

/// 队列添加指令bytes 避免硬编码 cmd也可不传 子类需配置 singleCmdUUID --- 也可指定特征 --- 简单的检测重复指令，例如某些可能重复写入的获取历史
- (void)cmd:(BDH_10 *)cmd data:(NSArray <NSObject *> *)data pri:(JECmdPri)pri crt:(NSString *)crt checkRepeats:(BOOL)checkRepeats;
    
/// 按照命令删除指令 传nil为全部删除！
- (void)deleteCmd:(BDH_10 *)cmd;


#pragma mark ---------------------------- 被动接收 ----------------------------

/// 链接了指定特征
- (void)discoverCharacteristics:(CBCharacteristic *)crt;

/// 链接完了所有指定特征 = 判断连接成功
- (void)deviceDidConnectedAllCRT;

/// super 蓝牙收到数据  notifiy=主动通知
- (void)receiveData:(CBPeripheral *)peripheral crt:(CBCharacteristic *)crt notifiy:(BOOL)notifiy debug:(NSString *)debug NS_REQUIRES_SUPER;

/// 写入数据响应
- (void)didWrite:(CBCharacteristic *)crt error:(NSError *)error;

/// 断开响应
- (void)didDisconnectWithError:(NSError *)error;

#pragma mark ---------------------------- 静态方法 ----------------------------

/// JEBluetooth 里这个类型的设备
+ (instancetype)Device;

/// 新连接设备
+ (instancetype)NewDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI;

/// 连接过的历史设备
+ (NSMutableArray <__kindof JEBLEDevice *> *)HistoryDevices;

/// 连接过的设备 key:UDID value:mac
+ (NSDictionary <NSString *,NSString *>*)ConnectedDeviceList;

/// 删除一个连接记录
+ (void)DeleteHistoryDeveiceWithUUID:(NSString *)UUID;

/// 删除全部
+ (void)DeleteHistoryDeveices;


#pragma mark ---------------------------- 读取监控用 ----------------------------

@property (nonatomic,strong,readonly) NSMutableArray <JEBLECommand *>*allCmds;///< 获取当前指令队列情况
@property (nonatomic,strong,readonly) JEBLECommand *currentCmd;///< 当前操作指令

/// JEDebugTool__ LogSimple:
+ (void)JE_Debug_AddLog:(NSString *)log;

@end


