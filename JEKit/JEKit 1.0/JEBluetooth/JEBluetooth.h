//
//  JEBluetooth.h
//  
//
//  Created by JE on 2017/6/27.
//  Copyright © 2017年 JE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JEBluetooth+Category.h"
#import "JEBLEDevice.h"

typedef NS_ENUM(NSUInteger, BLEHighLowType) {
    BLEHighLowTypeHigh,///< 高位 1 = 01 00 00 00
    BLEHighLowTypeLow,///< 底位  1 = 00 00 00 01
};

typedef void (^BLE_centralState)(CBCentralManagerState state);/**< 状态回调 */
typedef void (^BLE_deviceBlock)(__kindof JEBLEDevice *device);/**< 设备回调 */

/** 单设备蓝牙处理工具 */
@interface JEBluetooth : NSObject

/** 单例 */
+ (instancetype)Shared;
//----------------------------------------------------------------------------------------------------
@property (nonatomic,strong) __kindof JEBLEDevice *simulatorDevice;///< 模拟器用

//----------------------------------------------------------------------------------------------------
@property (nonatomic,strong) CBCentralManager *central;///< CBCentralManager
@property (nonatomic,strong) NSMutableDictionary <NSString *,__kindof JEBLEDevice *> *Dic_devices;///< 连接过的设备

//----------------------------------------------------------------------------------------------------
@property(nonatomic,strong)  Class         deviceClass;///< 设备Class  ### 默认 JEBLEDevice class 匹配当前搜索设备类型用
@property (nonatomic,copy) Class (^handleDeviceClassBlock)(CBPeripheral *peripheral);///< 或根据发现的设备判断class 覆盖上面的deviceClass
@property (nonatomic,copy) BOOL (^canConnectHistoryDeviceBlock)(JEBLEDevice *device);///< 判断是否可连这个历史设备 默认YES 登录不同用户时用到

@property(nonatomic,strong)  __kindof JEBLECommand  *commandModel;///< 操作指令模型
@property (nonatomic,assign) BLEHighLowType highLowType;///< 高底位 ### 默认高
@property (nonatomic,assign) BOOL errorBlock;///< 蓝牙读，通知处理出错时也回调block ### 默认NO

@property (nonatomic,strong) NSMutableArray <NSString *> *Arr_errorDisconnectUUID;///< 异常断开连接的设备的UUID


/** 尝试连接 以前连接过的设备 */
- (void)reconnectHistoryPeripheral;

/** 蓝牙状态 */
- (void)centralState:(BLE_centralState)block;

/** 搜索 唯一key 重复会覆盖block */
- (void)scanPeripheral:(BLE_deviceBlock)block blockKey:(NSString *)blockKey;

/** 设备状态改变 回调   唯一key 重复会覆盖block */
- (void)deviceChange:(BLE_deviceBlock)block blockKey:(NSString *)blockKey;

/** 停止搜索 实际有需要断开重现中不会停止 */
- (void)stopScan;

/** 持有&尝试连接 */
- (void)connectDevice:(JEBLEDevice *)device;

/** 断开当前设备 */
- (void)cancelDevice:(JEBLEDevice *)device;

@end
