
#import "JEBluetooth+Category.h"
#import "JEBluetooth.h"

#pragma mark -   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵   BDH_2   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵
@implementation BDH_2

@end

#pragma mark -   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵   BDH_10   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵
@implementation BDH_10

@end

#pragma mark -   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵   BDH_16   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵
@implementation BDH_16

@end


#pragma mark -   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵   NSString (JEBluetoothReadWrite)   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵
@implementation NSString (JEBluetoothReadWrite)

- (BDH_10 *)_2_to_10{
    NSInteger decimal = 0;
    for (int i=0; i< self.length; i++) {
        NSString *number = [self substringWithRange:NSMakeRange(self.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            decimal += pow(2, i);
        }
    }
    return (BDH_10 *)@(decimal).stringValue;
}

- (BDH_16 *)_2_to_16{
    return (BDH_16 *)(self._2_to_10._10_to_16);
}

- (BDH_16 *)_10_to_16{
    NSString *hex = [[NSString alloc] initWithFormat:@"%1llx",self.longLongValue];
    return (BDH_16 *)[NSString stringWithFormat:@"%@%@",hex.length%2 != 0 ? @"0" : @"",hex];
}

- (BDH_10 *)_16_to_10{
    NSScanner * scanner = [NSScanner scannerWithString:self];//16 -> 10
    unsigned int  intValue;
    [scanner scanHexInt:&intValue];
    return (BDH_10 *)[NSString stringWithFormat:@"%.2u",intValue];
}

- (BDH_2 *)_10_to_2{
    return (BDH_2 *)(self._10_to_16._16_to_2);
}

- (BDH_2 *)_16_to_2{
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i<[self length]; i++) {
        NSString *key = [self substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            binary = [binary stringByAppendingString:value];
        }
    }
    if (binary.length != 8) {
        return (BDH_2 *)[@"0000" stringByAppendingString:binary];
    }
    return (BDH_2 *)binary;
}

- (NSData *)_16_to_data{
    NSString *hex = [[self uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    hex = [hex stringByReplacingOccurrencesOfString:@"0X" withString:@""];
//    if ([hex hasPrefix:@"0X"]) {hex = [hex substringFromIndex:2]; }
    if ([hex length]%2 != 0) {
        NSAssert(nil, @"");
        return nil;
    }
    NSMutableData *data = [NSMutableData dataWithCapacity:hex.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < hex.length / 2; i++) {
        byte_chars[0] = [hex characterAtIndex:i*2];
        byte_chars[1] = [hex characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

- (NSArray <BDH_10 *> *)bytes2{
    return [self._10_to_16 separatBytes:2]._to10;
}

- (NSArray <BDH_10 *> *)bytes3{
    return [self._10_to_16 separatBytes:3]._to10;
}

- (NSArray <BDH_10 *> *)bytes4{
    return [self._10_to_16 separatBytes:4]._to10;
}

- (NSArray *)separatBytes:(NSInteger)count{
    if ([self length]%2!=0) {
        NSAssert(nil, @"");return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = (int)self.length - 2; i >= 0; i = i - 2) {
        NSString *string = [self substringWithRange:NSMakeRange(i, 2)];
        [arr addObject:string];
    }
    while (arr.count < count) {  [arr addObject:@"00"];}
    if ([JEBluetooth Shared].highLowType == BLEHighLowTypeHigh) { return arr.reverseArr;}
    return arr;
}

- (NSArray <BDH_16 *> *)float_to_16{
    NSMutableArray *arr = [NSMutableArray array];
    float a = [self floatValue];
    unsigned char * b = (unsigned char*)&a;
    for(int i = 0; i<4; i++){
        [arr addObject:[NSString stringWithFormat:@"%2X",b[i]]];
    }
    return arr;
}

-(NSString *)reverseStr{
    NSMutableString *str = [NSMutableString string];
    for (int i = (int)(self.length - 1); i >= 0; i--) {
        [str appendString:[self substringWithRange:NSMakeRange(i, 1)]];
    }
    return str;
}

- (NSString *)at:(NSInteger)index{
    if (index < self.length && index >= 0) {
        return [self substringWithRange:NSMakeRange(index, 1)];
    }else{
        NSAssert(nil, @"");
        return nil;
    }
}

@end




#pragma mark -   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵   NSArray (JEBluetoothReadWrite)   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵
@implementation NSArray (JEBluetoothReadWrite)

- (NSArray <BDH_16 *> *)_to16{
    NSMutableArray *arr = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) { obj = ((NSNumber*)obj).stringValue;}
        NSString *hex = obj._10_to_16;
        NSAssert(hex.length == 2, @"溢出按255处理");
        if (hex.length > 2) { hex = @"ff";}
        [arr addObject:hex];
    }];
    return arr;
}

- (NSArray <BDH_10 *> *)_to10{
    NSMutableArray *arr = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj._16_to_10];
    }];
    return arr;
}

- (NSData *)_16_to_data{
    NSMutableString *string = [NSMutableString string];
    [self enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *appand;
        if ([obj isKindOfClass:[NSNumber class]]) {
            appand = [(NSNumber*)obj stringValue];
        }else{
            appand = obj;
        }
        if (appand.length == 1) {
            appand = [NSString stringWithFormat:@"0%@",appand];
        }
        [string appendString:appand];
    }];
    return string._16_to_data;
}

- (float)_16_to_float{
    NSAssert(self.count == 4, @"");
    NSArray <NSString *> *arr = self;
    const char  pMem[] = {arr[0]._16_to_10.intValue,arr[1]._16_to_10.intValue,arr[2]._16_to_10.intValue,arr[3]._16_to_10.intValue};
    return *(float*)pMem;
}

- (BDH_10 *)_16_to_10Sub:(NSInteger)loc len:(NSInteger)len{
    if ([JEBluetooth Shared].highLowType == BLEHighLowTypeHigh) {
        return  [self sub:loc len:len].join._16_to_10;
    }else{
        return  [self sub:loc len:len].reverseArr.join._16_to_10;
    }
}

- (NSString *)join{
    return [self componentsJoinedByString:@""];
}

- (NSArray *)sub:(NSInteger)loc len:(NSInteger)len{
    if (loc + len > self.count) {
        return nil;
    }
    return [self subarrayWithRange:NSMakeRange(loc, len)];
}

- (NSArray *)append:(NSArray *)arr{
    return [self arrayByAddingObjectsFromArray:arr];
}

- (NSArray *)reverseArr{
    return  [[self reverseObjectEnumerator] allObjects];
}

+ (NSArray <BDH_10 *> *)DateBytes{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yy-MM-dd-HH-mm-ss"];
    return (NSArray <BDH_10 *> *)[[format stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"];
}

+ (NSArray <BDH_10 *> *)DateByte:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yy-MM-dd"];
    return (NSArray <BDH_10 *> *)[[format stringFromDate:date] componentsSeparatedByString:@"-"];
}

- (NSMutableArray <NSArray <NSString *> *> *)group:(NSInteger)N{
    if (self.count%N != 0) {
#ifdef DEBUG
        [self JE_Debug_AddLog:[NSString stringWithFormat:@"🔴🔴🔴🔴不能整除count:%@ gourpBy:%@  \n%@",@(self.count),@(N),self._to16.join]];
#endif
//        NSAssert(nil, @"不能整除");
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.count/N; i++) {
        [arr addObject:[self sub:i*N len:N].mutableCopy];
    }
    return arr;
}

-(void)fillToCount:(NSInteger)count{
    while (self.count < count) {
        [(NSMutableArray *)self addObject:@"00"];
    }
}

- (void)JE_Debug_AddLog:(NSString *)log{
#ifdef DEBUG
    BLELog(@"%@",log);
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




#pragma mark -   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵   NSData (JEBluetoothReadWrite)   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵
@implementation NSData (JEBluetoothReadWrite)

- (NSArray <BDH_10 *> *)_10_Arr{
    NSMutableArray *arr = [NSMutableArray array];
    Byte *bytes = (Byte *)[self bytes];
    for(int i = 0; i < [self length];i++){
        [arr addObject:[NSString stringWithFormat:@"%.2x",bytes[i]&0xff]._16_to_10];
    }
    return arr;
}

- (NSArray <BDH_16 *> *)_16_Arr{
    NSMutableArray *arr = [NSMutableArray array];
    Byte *bytes = (Byte *)[self bytes];
    for(int i = 0; i < [self length];i++){
        [arr addObject:[NSString stringWithFormat:@"%.2x",bytes[i]&0xff]];
    }
    return arr;
}

@end





#pragma mark -   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵   CBCharacteristic (JE)   🔵🔵🔵🔵🔵🔵🔵🔵  🔵🔵🔵🔵🔵🔵🔵🔵
@implementation CBCharacteristic (JE)

- (NSString *)propertyDebugInfo{
#ifdef DEBUG
    NSMutableString *info = [NSMutableString string];
    if (self.properties & CBCharacteristicPropertyBroadcast) { [info appendString:@"广播"];}
    if (self.properties & CBCharacteristicPropertyRead) { [info appendString:@",可读"];}
    if (self.properties & CBCharacteristicPropertyWriteWithoutResponse) { [info appendString:@",可写(无响应)"];}
    if (self.properties & CBCharacteristicPropertyWrite) { [info appendString:@",可写"];}
    if (self.properties & CBCharacteristicPropertyNotify) { [info appendString:@",通知"];}
    if (self.properties & CBCharacteristicPropertyIndicate) { [info appendString:@",Indicate"];}
    if (self.properties & CBCharacteristicPropertyAuthenticatedSignedWrites) { [info appendString:@",AuthenticatedSignedWrites"];}
    if (self.properties & CBCharacteristicPropertyExtendedProperties) { [info appendString:@",ExtendedProperties"];}
    if (self.properties & CBCharacteristicPropertyNotifyEncryptionRequired) { [info appendString:@",NotifyEncryptionRequired"];}
    if (self.properties & CBCharacteristicPropertyIndicateEncryptionRequired) { [info appendString:@",IndicateEncryptionRequired"];}
    return info;
#endif
    return nil;
}

@end
