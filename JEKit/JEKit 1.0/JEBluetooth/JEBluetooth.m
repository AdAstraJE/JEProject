
#import "JEBluetooth.h"

@interface JEBluetooth ()<CBCentralManagerDelegate,CBPeripheralDelegate>{
    BOOL _reconnectHistoryDevice;///< 预约重连设备
    
    NSMutableDictionary <NSString *,BLE_deviceBlock> *_Dic_deviceChangeBlock;
    NSMutableDictionary <NSString *,BLE_deviceBlock> *_Dic_scanBlock;
    NSTimer *_errorTimer;///< 异常断开需要重连计时
}

@property (nonatomic,strong) BLE_centralState block_state; ///< 蓝牙状态block

@end

@implementation JEBluetooth

static JEBluetooth *_instance;

+ (instancetype)Shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance setupBluetooth];
    });
    return _instance;
}

- (void)setupBluetooth{
    _reconnectHistoryDevice = NO;
    _highLowType = BLEHighLowTypeHigh;
    _deviceClass = [JEBLEDevice class];
    _errorBlock = NO;
    
    _Dic_devices = [NSMutableDictionary dictionary];
    _Dic_deviceChangeBlock = [NSMutableDictionary dictionary];
    _Dic_scanBlock = [NSMutableDictionary dictionary];
    _Arr_errorDisconnectUUID = [NSMutableArray array];
}

- (CBCentralManager *)central{
    if (_central == nil) {
        _central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _central;
}

/** 搜索 唯一key 重复会覆盖block */
- (void)scanPeripheral:(BLE_deviceBlock)block blockKey:(NSString *)blockKey{
    [_Dic_scanBlock setValue:block forKey:blockKey];
    if (block) {
        [JEBLEDevice JE_Debug_AddLog:BLELog__(@"开始搜索")];
        [self.central scanForPeripheralsWithServices:nil options:nil];
    }
}

/** 设备状态改变 回调   唯一key 重复会覆盖block */
- (void)deviceChange:(BLE_deviceBlock)block blockKey:(NSString *)blockKey{
    [_Dic_deviceChangeBlock setValue:block forKey:blockKey];
}

/** 断开当前设备 */
- (void)cancelDevice:(JEBLEDevice *)device{
    [JEBLEDevice JE_Debug_AddLog:BLELog__(@"主动断开 %@",[self debug:device.peripheral device:device])];
    if (device.peripheral.state == CBPeripheralStateConnecting || device.peripheral.state == CBPeripheralStateConnected) {
        [_central cancelPeripheralConnection:device.peripheral];
    }
    
    [self deviceChangeToConnectState:NO device:device];
}

/** 更改当前设备连接状态 */
- (void)deviceChangeToConnectState:(BOOL)connect device:(JEBLEDevice *)device{
    if (device == nil) { return;}
    
    device.didConnect = (device.peripheral.state == CBPeripheralStateConnected);
    for (BLE_deviceBlock obj in _Dic_deviceChangeBlock.allValues) { ! obj ? : obj(device);}
    if (!connect && device.UUID) {
        [_Dic_devices removeObjectForKey:device.UUID];
    }
}

- (void)centralState:(BLE_centralState)block{
    _block_state = block;
    !_block_state ? : _block_state((CBCentralManagerState)self.central.state);
}

/** 尝试连接 以前连接过的设备 */
- (void)reconnectHistoryPeripheral{
    if ([JEBLEDevice HistoryDevices].count == 0) {
        return;
    }
    
    _reconnectHistoryDevice = YES;
    [self willConnectHistoryPeripheral];
}

- (void)willConnectHistoryPeripheral{
    if (self.central.state == CBCentralManagerStatePoweredOn && _reconnectHistoryDevice) {
        [[JEBLEDevice HistoryDevices] enumerateObjectsUsingBlock:^(__kindof JEBLEDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //            BLELog(@"autoReconnect : %@",@(obj.autoReconnect));
            BOOL canConnect = YES;
            if (self->_canConnectHistoryDeviceBlock) {  canConnect = self->_canConnectHistoryDeviceBlock(obj);}
            if (canConnect && obj.autoReconnect && !self->_Dic_devices[obj.UUID].didConnect) {
                [self connectDevice:obj];
            }
        }];
        _reconnectHistoryDevice = NO;
    }
}

/** 停止搜索 实际有需要断开重现中不会停止 */
- (void)stopScan{
    if (_Arr_errorDisconnectUUID.count == 0) {
        [JEBLEDevice JE_Debug_AddLog:BLELog__(@"停止搜索")];
        [_central stopScan];
    }
    
    [_Dic_scanBlock removeAllObjects];
}

#pragma mark - CBCentralManagerDelegate - 蓝牙

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    BLELog(@"蓝牙状态 ：【%@】",@[@"0 - 未知",@"1 - 重置",@"2 - 不支持",@"3 - 未授权",@"4 - 关闭",@"5 - 打开"][central.state]);
    !_block_state ? : _block_state((CBCentralManagerState)_central.state);
    
    if (_Arr_errorDisconnectUUID.count) { _reconnectHistoryDevice = YES; }
    [self willConnectHistoryPeripheral];
    
    if (_Dic_scanBlock.count) {
        [self.central scanForPeripheralsWithServices:nil options:nil];
    }
    
    //关闭蓝牙 回调断开状态
    if (central.state == CBCentralManagerStatePoweredOff) {
        [_Dic_devices.allValues enumerateObjectsUsingBlock:^(__kindof JEBLEDevice * _Nonnull device, NSUInteger idx, BOOL * _Nonnull stop) {
            if (device.peripheral) {
                device.didConnect = NO;
                for (BLE_deviceBlock obj in self->_Dic_deviceChangeBlock.allValues.reverseObjectEnumerator) { ! obj ? : obj(device);}
                [[JEBLEDevice HistoryDevices] enumerateObjectsUsingBlock:^(__kindof JEBLEDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([self->_Arr_errorDisconnectUUID containsObject:obj.UUID] && obj.autoReconnect) {
                        [self->_Arr_errorDisconnectUUID addObject:device.peripheral.identifier.UUIDString];
                    }
                }];
            }
        }];
    }
    
}

#pragma mark 发现设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
//    BLELog(@"%@      mac： %@      RSSI %@",peripheral.name,advertisementData,RSSI);
    Class class = _deviceClass;
    if (_handleDeviceClassBlock) { class = _handleDeviceClassBlock(peripheral);}
    
    __kindof JEBLEDevice *device = [class NewDevice:peripheral advertisementData:advertisementData RSSI:RSSI];
    if ([device siftCanDisplayDevice]) {
        BLELog(@"筛选发现设备：%@      mac： %@      RSSI %@ %@",peripheral.name,device.mac,RSSI,device.UUID);
        for (BLE_deviceBlock obj in _Dic_scanBlock.allValues) { ! obj ? : obj(device);}
        
        if ([_Arr_errorDisconnectUUID containsObject:peripheral.identifier.UUIDString]) {
            BLELog(@"🔶 指定的或异常断开需要重连的设备：%@ UUID：%@",device.name,device.UUID);
            [self connectDevice:device];
        }
    }
}

#pragma mark 持有&尝试连接
- (void)connectDevice:(JEBLEDevice *)device{
    [JEBLEDevice JE_Debug_AddLog:BLELog__(@"持有&尝试连接设备 %@",[self debug:device.peripheral device:device])];
    
    if (device.peripheral == nil) {
        NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:device.UUID];
        if (UUID == nil) { return;}
        NSArray<CBPeripheral *> *peripherals = [self.central retrievePeripheralsWithIdentifiers:@[UUID]];
        if (peripherals.count == 0) {
            return;
        }
        device.peripheral = peripherals.firstObject;
    }
    if (device.peripheral == nil || device.peripheral.state == CBPeripheralStateConnected) {
        return;
    }

    [_Dic_devices setValue:device forKey:device.UUID];//持有
    [self.central connectPeripheral:device.peripheral options:nil];
    for (BLE_deviceBlock obj in _Dic_deviceChangeBlock.allValues) { ! obj ? : obj(device);}
}

#pragma mark  连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
     __kindof JEBLEDevice *device = _Dic_devices[peripheral.identifier.UUIDString];
    if (!device) {return; }
    
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    
    [device saveDevice];
    [JEBLEDevice JE_Debug_AddLog:BLELog__(@"✅ 连接成功 %@",[self debug:peripheral device:device])];
    
    if ([_Arr_errorDisconnectUUID containsObject:peripheral.identifier.UUIDString]) {
        [_Arr_errorDisconnectUUID removeObject:peripheral.identifier.UUIDString];
    }
    
    if (_Arr_errorDisconnectUUID.count == 0) {[self stopScan];}
    //等 连接完服务特征才算连接成功
}

#pragma mark 连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [JEBLEDevice JE_Debug_AddLog:BLELog__(@"🔴 连接失败 %@",[self debug:peripheral device:nil])];
    [self deviceChangeToConnectState:NO device:_Dic_devices[peripheral.identifier.UUIDString]];
}

#pragma mark 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    JEBLEDevice *device = _Dic_devices[peripheral.identifier.UUIDString];
    [device didDisconnectWithError:error];
    [self deviceChangeToConnectState:NO device:device];

    [JEBLEDevice JE_Debug_AddLog:BLELog__(@"🔴 断开连接 %@ \nerror：%@",[self debug:peripheral device:device],error)];
    
    //异常断开需要重连
    if (error && device.autoReconnect) {
        if (![_Arr_errorDisconnectUUID containsObject:peripheral.identifier.UUIDString]) {
            [_Arr_errorDisconnectUUID addObject:peripheral.identifier.UUIDString];
        }
        _errorTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reconnectDisConnectDevice) userInfo:nil repeats:YES];
        [_central scanForPeripheralsWithServices:nil options:nil];
    }
}

/** 重连段开的设备 */
- (void)reconnectDisConnectDevice{
    if (_Arr_errorDisconnectUUID.count == 0) {
        [_errorTimer invalidate];
        return;
    }
    
    [[JEBLEDevice HistoryDevices] enumerateObjectsUsingBlock:^(__kindof JEBLEDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self->_Arr_errorDisconnectUUID containsObject:obj.UUID] && obj.autoReconnect) { [self connectDevice:obj]; }
    }];
}


#pragma mark - CBPeripheralDelegate - 发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {BLELog(@"🔴 发现服务出错：%@",error); return; }
    
    _Dic_devices[peripheral.identifier.UUIDString].serviceCount = peripheral.services.count;
    
    for (CBService *oneService in peripheral.services) {
        BLELog(@"发现服务：%@",oneService.UUID.UUIDString);
        [peripheral discoverCharacteristics:nil forService:oneService];
    }
    
}

#pragma mark 发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) { BLELog(@"🔴 发现特征出错：%@",error); return;}
    
    __kindof JEBLEDevice *device = _Dic_devices[peripheral.identifier.UUIDString];
    NSArray *UUIDs = device.Arr_recordUUID;
//    BLELog(@"服务%@ 包含特征\n",service.UUID.UUIDString);
    for (CBCharacteristic *crt in service.characteristics) {
        if ([UUIDs containsObject:crt.UUID.UUIDString]) {
            [device.Dic_crts setValue:crt forKey:crt.UUID.UUIDString];
            [device discoverCharacteristics:crt];
        }else{
//            BLELog(@"🔴 项目未纪录的特征%@ %@",crt.UUID.UUIDString,crt.propertyDebugInfo);
        }
    }
    device.linkedService += 1;
    
#ifdef DEBUG
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@\n{\n",service.UUID.UUIDString];
    for (CBCharacteristic *crt in service.characteristics) {
        [str appendFormat:@"       %@ [%@]\n",crt.UUID.UUIDString,crt.propertyDebugInfo];
    }
    [str appendString:@"\n}\n"];
    [JEBLEDevice JE_Debug_AddLog:BLELog__(@"⚛️服务:%@",str)];
#endif
    
    if (device.linkedService >= device.serviceCount && !device.didConnect) {//连接完服务特征才算连接成功
#ifdef DEBUG
        NSMutableString *debug = [NSMutableString string];
        [device.Dic_crts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CBCharacteristic * _Nonnull obj, BOOL * _Nonnull stop) {
            [debug appendFormat:@"%@%@ 【%@】 %@",debug.length ? @"\n" : @"",key,device.Dic_debug[key]?:@"?",obj.propertyDebugInfo];
        }];
        [JEBLEDevice JE_Debug_AddLog:BLELog__(@"✅ 链完特征 %@\n%@\n\n",[self debug:peripheral device:device],debug)];
#endif
        
        [self deviceChangeToConnectState:YES device:device];
    }
 
}

#pragma mark 收到数据的更新
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    [self receiveData:peripheral crt:characteristic notifiy:NO];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    [self receiveData:peripheral crt:characteristic notifiy:YES];
}

- (void)receiveData:(CBPeripheral *)peripheral crt:(CBCharacteristic *)crt notifiy:(BOOL)notifiy{
    if (crt.value == nil) { return;}
    __kindof JEBLEDevice *device = _Dic_devices[peripheral.identifier.UUIDString];

    NSString *debug = BLELog__(@"%@ %@, %@",(crt.isNotifying ? @"🔔收" : @"💬收"),crt.value,@((long long)[[NSDate date] timeIntervalSince1970]));
    [device receiveData:peripheral crt:crt notifiy:notifiy debug:debug];
}


#pragma mark 写入数据成功
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) { BLELog(@"🔴 写入数据出错：%@",error);return;}
//    BLELog(@"写入成功：%@",characteristic.UUID.UUIDString);
    [_Dic_devices[peripheral.identifier.UUIDString] didWrite:characteristic error:error];
}

//- (NSString *)debug:(CBPeripheral *)peripheral{
//    return Format(@"【%@】--- %@ --- %@",peripheral.name,_Dic_devices[peripheral.identifier.UUIDString].mac,@([[NSDate date] timeIntervalSince1970]));
//}

- (NSString *)debug:(CBPeripheral *)peripheral device:(JEBLEDevice *)device{
    if (peripheral) {
        return Format(@"【%@】--- %@ --- %@",peripheral.name,_Dic_devices[peripheral.identifier.UUIDString].mac,@([[NSDate date] timeIntervalSince1970]));
    }
    return Format(@"【%@】--- %@ --- %@",device.name,device.mac,@([[NSDate date] timeIntervalSince1970]));
}

@end

