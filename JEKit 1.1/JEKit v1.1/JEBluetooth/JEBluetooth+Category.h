
#import <CoreBluetooth/CoreBluetooth.h>

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  BDH_16  🔷🔷🔷🔷🔷🔷🔷🔷
/// 16进制字符串 length = 2    (Binary Decimal Hexadecimal)
@interface BDH_16 : NSString
@end

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  BDH_10   🔷🔷🔷🔷🔷🔷🔷🔷
/// 10进制字符串 length = 2    (Binary Decimal Hexadecimal)
@interface BDH_10 : NSString
@end

#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷  BDH_2   🔷🔷🔷🔷🔷🔷🔷🔷
/// 2进制字符串 length = 8    (Binary Decimal Hexadecimal)
@interface BDH_2 : NSString
@end





#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   NSString (JEBluetoothReadWrite)  🔷🔷🔷🔷🔷🔷🔷🔷
@interface NSString (JEBluetoothReadWrite)

@property (nonatomic,readonly) BDH_10 *_2_to_10;///< 2进制 转 10进制
@property (nonatomic,readonly) BDH_16 *_2_to_16;///< 2进制 转 16进制
@property (nonatomic,readonly) BDH_16 *_10_to_16;///< 10进制 转 16进制
@property (nonatomic,readonly) BDH_10 *_16_to_10;///< 16进制 转 10进制
@property (nonatomic,readonly) BDH_2 *_10_to_2;///< 10进制 转 2进制 8位
@property (nonatomic,readonly) BDH_2 *_16_to_2;///< 16进制 转 2进制 8位
@property (nonatomic,readonly) NSData *_16_to_data;///< 16进制 转 data

/// 分割为数组 count 长度不够前面补@"00"
- (NSArray *)separatBytes:(NSInteger)count;

@property (nonatomic,readonly) NSArray <BDH_10 *> *bytes2;///< 原10转16进制 -> 转数组 -> 转10进制 (count == 2)
@property (nonatomic,readonly) NSArray <BDH_10 *> *bytes3;///< 原10转16进制 -> 转数组 -> 转10进制 (count == 3)
@property (nonatomic,readonly) NSArray <BDH_10 *> *bytes4;///< 原10转16进制 -> 转数组 -> 转10进制 (count == 4)
@property (nonatomic,readonly) NSArray <BDH_16 *> *float_to_16;///< float转16进制的数组  (count == 4)

@property (nonatomic,readonly) NSString *reverseStr;///<  倒转的字符串

/// 🙄 ==  substringWithRange:NSMakeRange(index, 1)
- (NSString *)at:(NSInteger)index;

@end




#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   NSArray (JEBluetoothReadWrite)   🔷🔷🔷🔷🔷🔷🔷🔷
@interface NSArray (JEBluetoothReadWrite)

@property (nonatomic,readonly) NSArray <BDH_16 *> *_to16;///< 10进制的数组转 16进制  溢出按255处理
@property (nonatomic,readonly) NSArray <BDH_10 *> *_to10;///< 16进制的数组转 10进制
@property (nonatomic,readonly) NSData *_16_to_data;///< 16进制的数组转 data
@property (nonatomic,readonly) float _16_to_float;///< (count == 4)    16进制的数组转 float
@property (nonatomic,readonly) NSString *join;///< 🙄 == componentsJoinedByString
@property (nonatomic,readonly) NSArray *reverseArr;///< 🙄 == [[ reverseObjectEnumerator] allObjects]  倒转的数组

/// 根据高低位 16进制的数据取部分 按当前高低位 转10进制
- (BDH_10 *)_16_to_10Sub:(NSInteger)loc len:(NSInteger)len;

/// 🙄 ==  subarrayWithRange:NSMakeRange(loc, len)
- (NSArray *)sub:(NSInteger)loc len:(NSInteger)len;

/// 🙄 == arrayByAddingObjectsFromArray
- (NSArray *)append:(NSArray *)arr;

/// yy-MM-dd 时间  (count = =3)
+ (NSArray <BDH_10 *> *)DateByte:(NSDate *)date;

/// yy-MM-dd-HH-mm-ss 时间  (count = =6)
+ (NSArray <BDH_10 *> *)DateBytes;

/// 每N个分一组
- (NSMutableArray <NSArray <NSString *> *> *)group:(NSInteger)N;

/// 填充 @"00" 到count
- (void)fillToCount:(NSInteger)count;

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   NSData (JEBluetoothReadWrite)   🔷🔷🔷🔷🔷🔷🔷🔷
@interface NSData (JEBluetoothReadWrite)

@property (nonatomic,readonly) NSArray <BDH_10 *> *_10_Arr;///< data 分组 每2个字符 转10进制
@property (nonatomic,readonly) NSArray <BDH_16 *> *_16_Arr;///< data 分组 每2个字符 转16进制

@end



#pragma mark -   🔷🔷🔷🔷🔷🔷🔷🔷   CBCharacteristic (JE)   🔷🔷🔷🔷🔷🔷🔷🔷
@interface CBCharacteristic (JE)
@property (nonatomic,readonly) NSString *propertyDebugInfo;///< debug 描述属性。。。
@end

