
#import <Foundation/Foundation.h>
#import "NSDate+YYAdd.h"

@interface NSDate (JE)

@property (nonatomic,copy,readonly) NSNumber *ts;///< 时间戳(Unix timestamp)
@property (nonatomic,strong,readonly) NSDateComponents *components;///< 时间成分
@property (nonatomic,strong,readonly) NSDate *thatDay;///< 设置时分秒为0
@property (nonatomic,strong,readonly) NSDate *thatDayEnd;///< 设置时分秒为23:59:59
@property (nonatomic,strong,readonly) NSDate *addZone;///< 加上时区秒
@property (nonatomic,strong,readonly) NSDate *delZone;///< 减去时区秒

/// 手机是否12小时制度
+ (BOOL)is12HourFormat;

/// 两个时间比较
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/// 根据年份、月份、日期、小时数、分钟数、秒数返回NSDate
+ (NSDate *)dateWithYear:(NSUInteger)year Month:(NSUInteger)month Day:(NSUInteger)day Hour:(NSUInteger)hour Minute:(NSUInteger)minute Second:(NSUInteger)second;

/// 两个日期相差的天数
+ (NSInteger)GapDayFrom:(NSDate *)from to:(NSDate *)to;

@property (nonatomic, readonly) NSInteger monthDays; ///< 这个月的天数
@property (nonatomic, readonly) NSInteger yearDays; ///< 这年的天数

@property (nonatomic, copy,readonly) NSString *weekDesChiness; ///< 今天星期几来着？
@property (nonatomic, readonly) BOOL IsLeapYear; ///< 是否是闰年
@property (nonatomic, readonly) BOOL IsLeapMonth;///< 是否是29天的2月
- (NSUInteger)weekOfDayInYear;///< 获取当天是当年的第几周
- (NSDate *)oneHourLater;///< 获取一小时后的时间
- (BOOL)isSameDay:(NSDate *)otherDate;///< 判断与某一天是否为同一天
- (BOOL)isSameWeek:(NSDate *)otherDate;///< 判断与某一天是否为同一周
- (BOOL)isSameMonth:(NSDate *)otherDate;///< 判断与某一天是否为同一月

@property (nonatomic,copy,readonly) NSString *je_whatTimeAgo;///< 多久以前呢 ？ 1分钟内 X分钟前 X天前
@property (nonatomic,copy,readonly) NSString *je_whatTimeBefore;///< 前段时间日期的描述 

- (NSDate *)dateInMinute:(NSInteger)minute; ///< +- X 分 后的日期
- (NSDate *)dateInHour:(NSInteger)hour;     ///< +- X 时 后的日期
- (NSDate *)dateInDay:(NSInteger)day;       ///< +- X 天 后的日期
- (NSDate *)dateInWeek:(NSInteger)week;     ///< +- X 周 后的日期
- (NSDate *)dateInMonth:(NSInteger)month;   ///< +- X 月 后的日期
- (NSDate *)dateInYear:(NSInteger)year;     ///< +- X 年 后的日期

@property (nonatomic,copy,readonly) NSString *je_YYYYMMddHHmmss; ///< YYYY-MM-dd HH:mm:ss
@property (nonatomic,copy,readonly) NSString *je_YYYYMMdd;       ///< YYYY.MM.dd
@property (nonatomic,copy,readonly) NSString *je_YYYYMMdd__;     ///< YYYY-MM-dd
@property (nonatomic,copy,readonly) NSString *je_YYYYMMdd___;    ///< YYYY/MM/dd
@property (nonatomic,copy,readonly) NSString *je_ddMMYYYY___;    ///< dd/MM/YYYY
@property (nonatomic,copy,readonly) NSString *je_MMddYYYY___;    ///< MM/dd/YYYY
@property (nonatomic,copy,readonly) NSString *je_YYYYMM__;       ///< YYYY-MM
@property (nonatomic,copy,readonly) NSString *je_MMdd;           ///< MM.dd
@property (nonatomic,copy,readonly) NSString *je_MMdd__;         ///< MM-dd
@property (nonatomic,copy,readonly) NSString *je_HHmm;           ///< HH:mm 24
@property (nonatomic,copy,readonly) NSString *je_HHmm_apM;       ///< HH:mm am pm 随系统格式
@property (nonatomic,copy,readonly) NSString *je_HHmmss;         ///< HH:mm:ss

@property (nonatomic,copy,readonly) NSString *je_MMddHHmm; ///< MM-dd HH:mm
@property (nonatomic,copy,readonly) NSString *je_YYYYMMddHHmm_zh; ///< YYYY年MM月dd日 HH:mm
@property (nonatomic,copy,readonly) NSString *je_YYYYMMdd_zh; ///< YYYY年MM月dd日
@property (nonatomic,copy,readonly) NSString *je_MMddHHmm_zh; ///< MM月dd日 HH:mm

+ (NSDateFormatter *)DateF_YYYYMMddHHmmss;///< yyyy-MM-dd HH:mm:ss
+ (NSDateFormatter *)DateF_YYYYMMddHHmm;///< yyyy-MM-dd HH:mm
+ (NSDateFormatter *)DateF_YYYYMMdd;///< yyyy.MM.dd
+ (NSDateFormatter *)DateF_YYYYMMdd__;///< yyyy-MM-dd
+ (NSDateFormatter *)DateF_YYYYMM__;///< yyyy-MM
+ (NSDateFormatter *)DateF_MMdd__;///< MM-dd
+ (NSDateFormatter *)DateF_MMddHHmm;///< MM-dd HH:mm
+ (NSDateFormatter *)DateF_HHmm;///< HH:mm
+ (NSDateFormatter *)DateF_HHmmss;///< HH:mm:ss
+ (NSDateFormatter *)DateF_YYYYMMddHHmm_zh;///< yyyy年MM月dd日 HH:mm
+ (NSDateFormatter *)DateF_MMddHHmm_zh;///< MM月dd日 HH:mm
+ (NSDateFormatter *)DateF_MMdd_zh;///< MM月dd日
+ (NSDateFormatter *)DateF_YYYYMMdd_zh;///< yyyy年MM月dd日

@end
