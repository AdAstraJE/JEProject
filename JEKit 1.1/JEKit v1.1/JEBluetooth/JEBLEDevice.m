
#import "JEBLEDevice.h"
#import "JEBluetooth+Category.h"
#import "JEBluetooth.h"

#define kDeviceKey ([NSString stringWithFormat:@"JEBluetooth.%@",NSStringFromClass([JEBLEDevice class])])
#define kConnectedDeviceKey ([NSString stringWithFormat:@"JEBluetooth.%@.connected",NSStringFromClass([JEBLEDevice class])])

@implementation JEBLEDevice{
    NSMutableDictionary <NSString *,BLE_readNotifyBlock>*_Dic_read;///< 所有读取的回调 特征唯一
    NSMutableDictionary <NSString *,BLE_readNotifyBlock>*_Dic_notify;///< 所有开启通知时的回调 特征唯一
    NSMutableDictionary <NSString *,BLE_didWriteValueBlock>*_Dic_didWrite;///< 写入响应回调 特征唯一
    
    NSMutableArray <JEBLECommand *> *_Arr_cmd;///< 指令队列
    NSTimer *_timeoutTimer;///< 指令超时timer
    JEBLECommand *_currentCmd;///< 当前操作指令 （一应一答）
}

- (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (void)setDidConnect:(BOOL)didConnect{
    _didConnect = didConnect;
    if ([self isSimulator]) { return;}
    
    _Arr_cmd = [NSMutableArray array];
    _currentCmd = nil;
    if (_timeoutTimer) {[_timeoutTimer invalidate];_timeoutTimer = nil; }
    if (didConnect) {
        [self deviceDidConnectedAllCRT];
    }
}

- (NSMutableArray <JEBLECommand *> *)allCmds{return _Arr_cmd;}
- (JEBLECommand *)currentCmd{ return _currentCmd;}

- (instancetype)init{
    self = [super init];
    _Dic_crts = [NSMutableDictionary dictionary];
    _Dic_read = [NSMutableDictionary dictionary];
    _Dic_notify = [NSMutableDictionary dictionary];
    _Dic_didWrite = [NSMutableDictionary dictionary];
    _version = @"";
    _className = NSStringFromClass(self.class);
    _didConnect = NO;
    
    _autoReconnect = YES;
    _Arr_recordUUID = nil;///< 子类写需要纪录的特征UUUID
    _timeoutInterval = 5.0;
 
    return self;
}

#pragma mark ---------------------------- 子类重新定义或调用的 ----------------------------
- (NSString *)analysisMac{
    NSData *macData = [_adData objectForKey:@"kCBAdvDataManufacturerData"];
    NSInteger macBytes = 6;
    NSArray <NSString *> *macArr = macData._16_Arr;
    if (macArr.count >= macBytes) {
        macArr = [macArr sub:macArr.count - macBytes len:macBytes];
        return  [[macArr componentsJoinedByString:@":"] uppercaseString];
    }
    return @"";
}

- (BOOL)siftCanDisplayDevice{
    return _mac.length && _name.length;
}

- (NSMutableArray <NSObject *> *)createCmd:(BDH_10 *)cmd data:(NSArray <NSObject *> *)data{
    NSMutableArray *bytes = [NSMutableArray array];
    if (cmd) { [bytes addObject:cmd];}
    if (data.count) {[bytes addObjectsFromArray:data];}
    return bytes;
}

- (NSString *)writeDebugInfoFrom:(NSArray <NSObject *> *)data{
    return nil;
}

- (void)saveDevice{
    NSMutableDictionary <NSString *,NSDictionary *>*list = [JEBLEDevice HistoryDeviceList];
    NSString *UUID = self.peripheral.identifier.UUIDString ? : _UUID;
    if (UUID == nil) {return;}
    [list setValue:[self dictionaryWithValuesForKeys:@[@"name",@"UUID",@"mac",@"version",@"autoReconnect",@"className"]] forKey:UUID];
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:kDeviceKey];
    
    if (_mac.length) {
        NSMutableDictionary *connectedDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kConnectedDeviceKey]];
        [connectedDic setValue:(_mac ? : @"") forKey:(_UUID ? : @"")];
        [[NSUserDefaults standardUserDefaults] setObject:connectedDic forKey:kConnectedDeviceKey];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark ---------------------------- 指令队列操作 ----------------------------

- (void)read:(NSString *)UUID done:(BLE_readNotifyBlock)done{
    [self readNotify:UUID done:done notify:NO];
}

- (void)notify:(NSString *)UUID done:(BLE_readNotifyBlock)done{
    [self readNotify:UUID done:done notify:YES];
}

- (void)stopNotify:(NSString *)UUID{
    [_Dic_notify removeObjectForKey:UUID];
    if (_Dic_crts[UUID]) { [_peripheral setNotifyValue:NO forCharacteristic:_Dic_crts[UUID]];}
}

- (NSError *)checkCharacts:(NSString *)UUID{
    if (_peripheral.state == CBPeripheralStateDisconnected) {
        return [NSError errorWithDomain:@"蓝牙未连接" code:0 userInfo:nil];
    }
    if (UUID == nil || _Dic_crts[UUID] == nil) {
        return [NSError errorWithDomain:[NSString stringWithFormat:@"🔴 未链接特征：%@",UUID] code:0 userInfo:nil];
    }
    return nil;
}

- (void)readNotify:(NSString *)UUID done:(BLE_readNotifyBlock)done notify:(BOOL)notify{
    NSError *error = [self checkCharacts:UUID];;
    CBCharacteristic *crt = _Dic_crts[UUID];
    if (notify) {
        if (!(crt.properties & CBCharacteristicPropertyNotify)) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"🔴 无通知属性!：%@ ",crt] code:0 userInfo:nil];
        }
    }else{
        if (!error && !(crt.properties & CBCharacteristicPropertyRead)) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"🔴 不可读!：%@ ",crt] code:0 userInfo:nil];
        }
    }
   
    if (error) {
        if ([JEBluetooth Shared].errorBlock) { !done ? : done(nil,error);}
        else{
//            NSAssert(error == nil, error.domain);
            [JEBLEDevice JE_Debug_AddLog:BLELog__(@"%@",error)];
        }
        return;
    }
//    NSAssert(_didConnect, @"不算完全连接");

    if (notify) {
        [_peripheral setNotifyValue:(notify ? YES : NO) forCharacteristic:crt];
        [_Dic_notify setValue:done forKey:UUID];
    }else{
        [_peripheral readValueForCharacteristic:crt];
        [_Dic_read setValue:done forKey:UUID];
    }

}

- (NSError *)write:(NSArray <NSObject *> *)arr crt:(NSString *)UUID done:(BLE_didWriteValueBlock)done{
    if ([self isSimulator]) { return nil;}
    NSError *error = [self checkCharacts:UUID];
    CBCharacteristic *crt = UUID ? _Dic_crts[UUID] : nil;
    if (!error && !(crt.properties & CBCharacteristicPropertyWrite) && !(crt.properties & CBCharacteristicPropertyWriteWithoutResponse)) {
        error = [NSError errorWithDomain:[NSString stringWithFormat:@"🔴 不可写!：%@",crt] code:0 userInfo:nil];
    }
    if (!error && (crt.properties & CBCharacteristicPropertyWriteWithoutResponse) && done) {
        error = [NSError errorWithDomain:[NSString stringWithFormat:@"🔴 无响应-block无效!：%@",crt] code:0 userInfo:nil];
    }
    if (error) {
        !done ? : done(error);
//        NSAssert(error == nil, error.domain);
        BLELog(@"%@",error);
        return error;
    }
    
    [_Dic_didWrite setValue:done forKey:UUID];
    
    NSData *data = arr._to16._16_to_data;//这里统一转16进制！！！！！！
    @synchronized (self) {
        [_peripheral writeValue:data forCharacteristic:crt type:(crt.properties & CBCharacteristicPropertyWriteWithoutResponse)];
    }
    
#ifdef DEBUG
    NSString *debugInfo = [self writeDebugInfoFrom:arr];
//    if (debugInfo.length == 0) { debugInfo = Format(@"%@_%@",(UUID.length > 5 ? @"-" : UUID),_Dic_debug[UUID]);}
    if (debugInfo.length == 0) { debugInfo = Format(@"%@",_Dic_debug[UUID] ? : UUID);}
    NSString *duilie = (_Arr_cmd.count == 0 ? @"" : Format(@"队列【%@】",@(_Arr_cmd.count)));
    [JEBLEDevice JE_Debug_AddLog:BLELog__(@"🔯写 %@, %@, %@ %@ %@",data,@((long long)[[NSDate date] timeIntervalSince1970]),debugInfo,duilie,error ? : @"")];
#endif

    return nil;
}


#pragma mark ---------------------------- 指令队列操作 ----------------------------

- (void)cmd:(BDH_10 *)cmd data:(NSArray <NSObject *> *)data{
    [self cmd:cmd data:data pri:(JECmdPriDefault)];
}
    
- (void)cmd:(BDH_10 *)cmd data:(NSArray <NSObject *> *)data pri:(JECmdPri)pri{
    NSAssert(_singleCmdUUID != nil, @"子类需配置 singleCmdUUID");
    [self cmd:cmd data:data pri:pri crt:_singleCmdUUID checkRepeats:NO];
}

- (void)cmd:(BDH_10 *)cmd data:(NSArray <NSObject *> *)data pri:(JECmdPri)pri crt:(NSString *)crt{
    [self cmd:cmd data:data pri:pri crt:_singleCmdUUID checkRepeats:NO];
}

- (void)cmd:(BDH_10 *)cmd data:(NSArray <NSObject *> *)data pri:(JECmdPri)pri crt:(NSString *)crt checkRepeats:(BOOL)checkRepeats{
    if (!_didConnect) { return;}
    if (crt == nil) { crt = _singleCmdUUID;}
    
    NSMutableArray <NSObject *> *bytes = [self createCmd:cmd data:data];
    if (bytes.count == 0) {  return; }
    
    //直接写入 不放进指令队列
    if (pri == JECmdPriNow) {
        [self write:bytes crt:crt done:nil];
        return;
    }
    
    JEBLECommand *cmdModel = [[JEBLECommand alloc] init];
    cmdModel.cmd = cmd;
    cmdModel.crt = crt;
    cmdModel.priority = pri;
    cmdModel.Arr_byte = bytes;
    
    //检查重复指令
    if (checkRepeats) {
        __block BOOL repeats = NO;
        [_Arr_cmd enumerateObjectsUsingBlock:^(JEBLECommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.Arr_byte isEqualToArray:bytes] && [obj.cmd isEqualToString:cmd] && [obj.crt isEqualToString:crt] ) {
                repeats = YES;*stop = YES;
            }
        }];
        if (repeats) {
            return;
        }
    }
    
    if (pri == JECmdPriDefault && _Arr_cmd.count != 0) {
        //默认的放前面 优先度低的放后面
        BOOL inserted = NO;
        for (int i = (int)(_Arr_cmd.count - 1); i >= 0; i--) {
            JEBLECommand *mod = _Arr_cmd[i];
            if (mod.priority == JECmdPriDefault) {
                inserted = YES;
                [_Arr_cmd insertObject:cmdModel atIndex:i+1];break;
            }
        }
        if (!inserted) {
            [_Arr_cmd insertObject:cmdModel atIndex:0];
        }
    }else{
        [_Arr_cmd addObject:cmdModel];
    }

    if (!_timeoutTimer.isValid) {//当前空闲状态
        [self writeNextCmd];
    }
}


- (void)receiveFeedbackCmd:(BDH_10 *)feedbackCmd{
    if (_currentCmd.cmd.integerValue == feedbackCmd.integerValue) {
        [self writeNextCmd];
    }else{
//        NSAssert(0,@"");
    }
}

- (void)writeNextCmd{
    @synchronized (self) {
        if (_timeoutTimer) {[_timeoutTimer invalidate];_timeoutTimer = nil; }
        
        JEBLECommand *thisCmd = _Arr_cmd.firstObject;
        _currentCmd = nil;
        if (thisCmd == nil) { return;}
        
        NSError *writeError = [self write:thisCmd.Arr_byte crt:thisCmd.crt done:nil];
        _currentCmd = thisCmd;
        [_Arr_cmd removeObject:thisCmd];
        
        if (writeError == nil) {
            _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:_timeoutInterval target:self selector:@selector(cmdTimeout) userInfo:nil repeats:NO];
        }else{
            [self writeNextCmd];
        }
    }
}

- (void)cmdTimeout{
    [JEBLEDevice JE_Debug_AddLog:BLELog__(@"🔴超时指令:%@",_currentCmd.cmd._10_to_16)];
    [self writeNextCmd];
}

- (void)deleteCmd:(BDH_10 *)cmd{
    if (cmd == nil) {
        [_Arr_cmd removeAllObjects];
        [_timeoutTimer invalidate];_timeoutTimer = nil;
        return;
    }
    
    for (int i = 0; i < _Arr_cmd.count; i ++) {
        JEBLECommand *thisCmd = _Arr_cmd[i];
        if ([thisCmd.cmd isEqualToString:cmd]) {
            [_Arr_cmd removeObjectAtIndex:i];
            i--;
        }
    }
    
}

#pragma mark ---------------------------- 被动接收 ----------------------------

- (void)discoverCharacteristics:(CBCharacteristic *)crt{
    
}

- (void)deviceDidConnectedAllCRT{
    
}

- (void)receiveData:(CBPeripheral *)peripheral crt:(CBCharacteristic *)crt notifiy:(BOOL)notifiy debug:(NSString *)debug{
    if (!crt.isNotifying && !notifiy) {
        //readValueForCharacteristic 读取到值就删除block
        BLE_readNotifyBlock readBlock = _Dic_read[crt.UUID.UUIDString];
        !readBlock ? : readBlock(crt,nil);

        [_Dic_read removeObjectForKey:crt.UUID.UUIDString];
    }else{
        //NotifyValue
        BLE_readNotifyBlock notifyBlock = _Dic_notify[crt.UUID.UUIDString];
        !notifyBlock ? : notifyBlock(crt,nil);
    }
}

- (void)didWrite:(CBCharacteristic *)crt error:(NSError *)error{
    BLE_didWriteValueBlock didBlock = _Dic_didWrite[crt.UUID.UUIDString];
    !didBlock ? : didBlock(error);
    [_Dic_didWrite removeObjectForKey:crt.UUID.UUIDString];
    if (error) {
        [JEBLEDevice JE_Debug_AddLog:BLELog__(@"%@",error)];
    }
}

- (void)didDisconnectWithError:(NSError *)error{
    
}




#pragma mark ---------------------------- 静态方法 ----------------------------
+ (instancetype)Device{
#if TARGET_OS_SIMULATOR
    JEBLEDevice *test = [JEBluetooth Shared].simulatorDevice;
    if (test == nil) {
        test = [[self alloc] init];
        test.name = @"SIMULATOR";
        test.didConnect = NO;
        test.version = @"1.0";
        test.mac = @"AA:BB:CC:DD:EE:FF";
        [JEBluetooth Shared].simulatorDevice = test;
    }
    return test;
#endif
    
    __block JEBLEDevice *device = nil;
    [[JEBluetooth Shared].Dic_devices.allValues enumerateObjectsUsingBlock:^(__kindof JEBLEDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[self class]]) {
            device = obj;*stop = YES;
        }
    }];
    return device;
}

+ (instancetype)NewDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    __kindof JEBLEDevice *device = [[self alloc] init];
    device.peripheral = peripheral;
    device.name = peripheral.name;
    device.UUID = peripheral.identifier.UUIDString;
    device.RSSI = RSSI ? : @(0);
    device.adData = advertisementData;
    device.mac = [device analysisMac];
    return device;
}

+ (NSMutableDictionary <NSString *,NSDictionary *>*)HistoryDeviceList{
    return [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kDeviceKey]];
}

+ (NSMutableArray <__kindof JEBLEDevice *> *)HistoryDevices{
    NSMutableArray *Arr = [NSMutableArray array];
    
    [[JEBLEDevice HistoryDeviceList] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        Class class = NSClassFromString(obj[@"className"]);
        __kindof JEBLEDevice *device = [[class alloc] init];
        if (device) {
            [device setValuesForKeysWithDictionary:obj];
            device.version = @"";
            [Arr addObject:device];
        }
    }];
    return Arr;
}

+ (NSDictionary <NSString *,NSString *>*)ConnectedDeviceList{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kConnectedDeviceKey];
}

+ (void)DeleteHistoryDeveiceWithUUID:(NSString *)UUID{
    if (UUID == nil) {return;}
    NSMutableDictionary <NSString *,NSDictionary *>*list = [JEBLEDevice HistoryDeviceList];
    [list removeObjectForKey:UUID];
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:kDeviceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)DeleteHistoryDeveices{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDeviceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)JE_Debug_AddLog:(NSString *)log{
#ifdef DEBUG
    Class debug = NSClassFromString(@"JEDebugTool__");
    if (debug) {
        SEL addLog = NSSelectorFromString(@"LogSimple:");
        if ([debug respondsToSelector:addLog]) {
            [debug performSelectorOnMainThread:addLog withObject:log waitUntilDone:YES];
        }
    }
#endif
}

@end
