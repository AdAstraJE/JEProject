
#import "NSDate+JE.h"

@implementation NSDate (JE)

/** 字符时间戳 */
- (NSNumber *)ts{
    return @((long long)[self timeIntervalSince1970]);
}

- (long)TimeStamp{
    return [self timeIntervalSince1970];
}

/** 时间成分 */
- (NSDateComponents *)components{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
}

- (NSDate *)thatDay{
    NSDateComponents *com = self.components;
    return [NSDate dateWithYear:com.year Month:com.month Day:com.day Hour:0 Minute:0 Second:0];
}

- (NSDate *)thatDayEnd{
    NSDateComponents *com = self.components;
    return [NSDate dateWithYear:com.year Month:com.month Day:com.day Hour:23 Minute:59 Second:59];
}

- (NSDate *)addZone{
    NSTimeInterval timeZone = [[NSTimeZone localTimeZone] secondsFromGMTForDate:self] - [[NSTimeZone timeZoneWithAbbreviation:@"UTC"] secondsFromGMTForDate:self];;
    return [self dateByAddingTimeInterval:timeZone];
}

- (NSDate *)delZone{
    NSTimeInterval timeZone = [[NSTimeZone localTimeZone] secondsFromGMTForDate:self] - [[NSTimeZone timeZoneWithAbbreviation:@"UTC"] secondsFromGMTForDate:self];;
    return [self dateByAddingTimeInterval:-timeZone];
}

+ (BOOL)is12HourFormat{
    return ([[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]] rangeOfString:@"a"].location != NSNotFound);
}

/** 两个时间比较 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    return [[NSCalendar currentCalendar] components:unit fromDate:fromDate toDate:toDate options:0];
}

/** 根据年份、月份、日期、小时数、分钟数、秒数返回NSDate */
+ (NSDate *)dateWithYear:(NSUInteger)year Month:(NSUInteger)month Day:(NSUInteger)day Hour:(NSUInteger)hour  Minute:(NSUInteger)minute  Second:(NSUInteger)second{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    dateComponents.year = year;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;
    
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

+ (NSInteger)GapDayFrom:(NSDate *)from to:(NSDate *)to{
    NSDate *fromDate = from.thatDay;
    NSDate *toDate = to.thatDay;
    NSInteger gapDay = [NSDate dateComponents:NSCalendarUnitDay fromDate:fromDate toDate:toDate].day;
    return gapDay;
}

/** 这个月的天数 */
- (NSInteger)monthDays{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

/** 这年的天数 */
- (NSInteger)yearDays{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self].length;
}

/** 获取当天是当年的第几周 */
- (NSUInteger)weekOfDayInYear{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:self];
}

/** 获取一小时后的时间 */
- (NSDate *)oneHourLater{
    return [NSDate dateWithTimeInterval:3600 sinceDate:self];
}

/** 判断与某一天是否为同一天 */
- (BOOL)sameDayWithDate:(NSDate *)otherDate{
    return  (self.year == otherDate.year && self.month == otherDate.month && self.day == otherDate.day);
}

/** 判断与某一天是否为同一周 */
- (BOOL)sameWeekWithDate:(NSDate *)otherDate{
    return  (self.year == otherDate.year  && self.month == otherDate.month && self.weekOfDayInYear == otherDate.weekOfDayInYear);
}

/** 判断与某一天是否为同一月 */
- (BOOL)sameMonthWithDate:(NSDate *)otherDate{
    return (self.year == otherDate.year && self.month == otherDate.month);
}

- (BOOL)IsLeapYear {
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)IsLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}


/** 多久以前呢 ？ 1分钟内 X分钟前 X天前 */
- (NSString *)je_whatTimeAgo{
    if (self == nil) {
        return @"";
    }
    NSTimeInterval  timeInterval = - [self timeIntervalSinceNow];
    long temp = 0; NSString *result;
    if (timeInterval < 60) {result = [NSString stringWithFormat:@"1分钟内"]; }
    else if((temp = timeInterval/60) <60){result = [NSString stringWithFormat:@"%ld分钟前",temp]; }
    else if((temp = temp/60) <24){result = [NSString stringWithFormat:@"%ld小时前",temp];}
    else if((temp = temp/24) <30){result = [NSString stringWithFormat:@"%ld天前",temp]; }
    else if((temp = temp/30) <12){ result = [NSString stringWithFormat:@"%ld个月前",temp]; }
    else{ temp = temp/12;result = [NSString stringWithFormat:@"%ld年前",temp]; }
    return  result;
}

//凌晨(3：00—6：00) 早上(6：00—8：00) 上午(8：00—11：00) 中午(11：00—14：00) 下午(14：00—19：00) 晚上(19：00—24：00)  深夜0：00—3：00) JE准则
/** 前段时间日期的描述 上午？？ 星期二 下午？？ */
- (NSString *)je_whatTimeBefore{
    if (self == nil) {
        return @"";
    }
    NSDate  *yesterday = [[NSDate date] dateByAddingTimeInterval: - (24 * 60 * 60)];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = /*NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitHour |NSCalendarUnitMinute | */NSCalendarUnitDay;
    NSDateComponents *Compareday = [calendar components:unitFlags fromDate:self];
    NSDateComponents *Yesterday = [calendar components:unitFlags fromDate:yesterday];
    NSDateComponents *Today = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateFormatter* F_Mon_Day=[[NSDateFormatter alloc]init];
    [F_Mon_Day setDateFormat:@"MM-dd"];
    NSDateFormatter* F_H_M=[[NSDateFormatter alloc]init];
    [F_H_M setDateFormat:@"HH:mm"];
    NSString *S_H = [[F_H_M stringFromDate:self] substringWithRange:NSMakeRange(0, 2)];
    NSString *S_M = [[F_H_M stringFromDate:self] substringWithRange:NSMakeRange(3, 2)];
    NSString *sunormoon = @"";
    NSInteger Hour = [S_H integerValue];
    
    if (Hour >= 3 && Hour < 6) {
        sunormoon = @"凌晨";
    }else if (Hour >= 6 && Hour < 8){
        sunormoon = @"早上";
    }else if (Hour >= 8 && Hour < 11){
        sunormoon = @"上午";
    }else if (Hour >= 11 && Hour < 14){
        sunormoon = @"中午";
    }else if (Hour >= 14 && Hour < 19){
        sunormoon = @"下午";
    }else if (Hour >= 19 /*&& Hour < 23*/){
        sunormoon = @"晚上";
    }else if (Hour >= 0 && Hour < 3){
        sunormoon = @"深夜";
    }
    
    if (Hour > 12) {
        Hour = Hour - 12;
    }
    
    NSString *Mon_Day= [F_Mon_Day stringFromDate:self];
    NSString *Hou_Min = [NSString stringWithFormat:@"%@ %d:%@",sunormoon,(int)Hour,S_M];
    //    NSString *Week = [self weekDesChiness];
    NSTimeInterval oldtime= [self timeIntervalSince1970];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    if ([[[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear fromDate:self] year] != [[[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]] year]) {
        [F_Mon_Day setDateFormat:@"YYYY-MM-dd"];
        Mon_Day= [F_Mon_Day stringFromDate:self];
        
    }
    
    if ([Today day] == [Compareday day]) {
        return [NSString stringWithFormat:@"%@",Hou_Min];
    }
    
    if ([Yesterday day] == [Compareday day]) {
        return [NSString stringWithFormat:@"昨天  %@",Hou_Min];
    }
    
    if ((nowTime - oldtime)/60/60/24 >= 7){
        return [NSString stringWithFormat:@"%@   %@",Mon_Day,Hou_Min];
    }
    
    if ((nowTime - oldtime)/60/60/24 < 7){
        return [NSString stringWithFormat:@"%@   %@",Mon_Day,Hou_Min];
        //        return [NSString stringWithFormat:@"%@  %@",Week,Hou_Min];
    }
    
    return [NSString stringWithFormat:@"%@   %@",Mon_Day,Hou_Min];
}

/** 今天星期几来着？ */
- (NSString *)weekDesChiness{
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return [@{@"1" : @"星期日",@"2" : @"星期一",@"3" : @"星期二",@"4" : @"星期三",@"5" : @"星期四",@"6" : @"星期五",@"7" : @"星期六"} objectForKey:@([componets weekday]).stringValue];
}

/** 差 X 分钟 后的日期 */
- (NSDate *)dateInMinute:(NSInteger)minute{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.minute = minute;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/** 差 X 小时 后的日期  */
-(NSDate *)dateInHour:(NSInteger)hour{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = hour;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/** 差 X 天 后的日期  */
- (NSDate *)dateInDay:(NSInteger)day{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/** 差 X 周 后的日期  */
- (NSDate *)dateInWeek:(NSInteger)week{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.weekOfYear = week;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/** 差 X 月 后的日期  */
- (NSDate *)dateInMonth:(NSInteger)month{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/** 差 X 年 后的日期  */
- (NSDate *)dateInYear:(NSInteger)year{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = year;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSString *)je_YYYYMMddHHmmss{return [[NSDate DateF_YYYYMMddHHmmss] stringFromDate:self];}
- (NSString *)je_YYYYMMdd{return [[NSDate DateF_YYYYMMdd] stringFromDate:self];}
- (NSString *)je_YYYYMMdd__{return [[NSDate DateF_YYYYMMdd__] stringFromDate:self];}
- (NSString *)je_YYYYMMdd___{return [[NSDate DateF_YYYYMMdd___] stringFromDate:self];}
- (NSString *)je_ddMMYYYY___{return [[NSDate DateF_ddMMYYYY___] stringFromDate:self];}
- (NSString *)je_MMddYYYY___{return [[NSDate DateF_MMddYYYY___] stringFromDate:self];}
- (NSString *)je_YYYYMM__{  return [[NSDate DateF_YYYYMM__] stringFromDate:self];}
- (NSString *)je_MMdd{  return [[NSDate DateF_MMdd] stringFromDate:self];}
- (NSString *)je_MMdd__{  return [[NSDate DateF_MMdd__] stringFromDate:self];}
- (NSString *)MMddHHmm{ return [[NSDate DateF_MMddHHmm] stringFromDate:self];}
- (NSString *)je_HHmm{
    NSDateComponents *com = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self];
    return [NSString stringWithFormat:@"%.2d:%.2d",(int)com.hour,(int)com.minute];
//    return [[NSDate DateF_HHmm] stringFromDate:self];//系统可能有bug
}
- (NSString *)je_HHmm_apM{  return [[NSDate DateF_HHmm_apM] stringFromDate:self];}
- (NSString *)je_HHmmss{  return [[NSDate DateF_HHmmss] stringFromDate:self];}
- (NSString *)YYYYMMddHHmmInChinese{return [[NSDate DateF_YYYYMMddHHmmInChinese] stringFromDate:self];}
- (NSString *)MMddHHmmInChinese{ return [[NSDate DateF_MMddHHmmInChinese] stringFromDate:self];}
- (NSString *)YYYYMMddInChinese{  return [[NSDate DateF_YYYYMMddInChinese] stringFromDate:self];}

//G: 公元时代，例如AD公元
//yy: 年的后2位
//yyyy: 完整年
//MM: 月，显示为1-12
//MMM: 月，显示为英文月份简写,如 Jan
//MMMM: 月，显示为英文月份全称，如 Janualy
//dd: 日，2位数表示，如02
//d: 日，1-2位显示，如 2
//EEE: 简写星期几，如Sun
//EEEE: 全写星期几，如Sunday
//aa: 上下午，AM/PM
//H: 时，24小时制，0-23
//K：时，12小时制，0-11
//m: 分，1-2位
//mm: 分，2位
//s: 秒，1-2位
//ss: 秒，2位
//S: 毫秒
//Z：GMT


+ (NSDateFormatter *)DateF_YYYYMMddHHmmss{
    static NSDateFormatter *sDF_YYYYMMddHHmmss;
    if (!sDF_YYYYMMddHHmmss) {
        sDF_YYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [sDF_YYYYMMddHHmmss setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return sDF_YYYYMMddHHmmss;
}


+ (NSDateFormatter *)DateF_YYYYMMddHHmm{
    static NSDateFormatter *sDF_YYYYMMddHHmm;
    if (!sDF_YYYYMMddHHmm) {
        sDF_YYYYMMddHHmm = [[NSDateFormatter alloc] init];
        [sDF_YYYYMMddHHmm setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    return sDF_YYYYMMddHHmm;
}

+ (NSDateFormatter *)DateF_YYYYMMdd{
    static NSDateFormatter *sDF_YYYYMMdd;
    if (!sDF_YYYYMMdd) {
        sDF_YYYYMMdd = [[NSDateFormatter alloc] init];
        [sDF_YYYYMMdd setDateFormat:@"yyyy.MM.dd"];
    }
    
    return sDF_YYYYMMdd;
}

+ (NSDateFormatter *)DateF_YYYYMMdd__{
    static NSDateFormatter *sDF_YYYYMMdd__;
    if (!sDF_YYYYMMdd__) {
        sDF_YYYYMMdd__ = [[NSDateFormatter alloc] init];
        [sDF_YYYYMMdd__ setDateFormat:@"yyyy-MM-dd"];
    }
    
    return sDF_YYYYMMdd__;
}

+ (NSDateFormatter *)DateF_YYYYMMdd___{
    static NSDateFormatter *sDF_YYYYMMdd___;
    if (!sDF_YYYYMMdd___) {
        sDF_YYYYMMdd___ = [[NSDateFormatter alloc] init];
        [sDF_YYYYMMdd___  setDateFormat:@"yyyy/MM/dd"];
    }
    
    return sDF_YYYYMMdd___;
}

+ (NSDateFormatter *)DateF_ddMMYYYY___{
    static NSDateFormatter *sDF_ddMMYYYY___;
    if (!sDF_ddMMYYYY___) {
        sDF_ddMMYYYY___ = [[NSDateFormatter alloc] init];
        [sDF_ddMMYYYY___  setDateFormat:@"dd/MM/YYYY"];
    }
    
    return sDF_ddMMYYYY___;
}

+ (NSDateFormatter *)DateF_MMddYYYY___{
    static NSDateFormatter *sDF_MMddYYYY___;
    if (!sDF_MMddYYYY___) {
        sDF_MMddYYYY___ = [[NSDateFormatter alloc] init];
        [sDF_MMddYYYY___  setDateFormat:@"MM/dd/YYYY"];
    }
    
    return sDF_MMddYYYY___;
}


+ (NSDateFormatter *)DateF_YYYYMM__{
    static NSDateFormatter *sDF_YYYYMM__;
    if (!sDF_YYYYMM__) {
        sDF_YYYYMM__ = [[NSDateFormatter alloc] init];
        [sDF_YYYYMM__ setDateFormat:@"yyyy-MM"];
    }
    
    return sDF_YYYYMM__;
}

+ (NSDateFormatter *)DateF_MMdd{
    static NSDateFormatter *sDF_DateF_MMdd;
    if (!sDF_DateF_MMdd) {
        sDF_DateF_MMdd = [[NSDateFormatter alloc] init];
        [sDF_DateF_MMdd setDateFormat:@"MM.dd"];
    }
    
    return sDF_DateF_MMdd;
}

+ (NSDateFormatter *)DateF_MMdd__{
    static NSDateFormatter *sDF_DateF_MMdd__;
    if (!sDF_DateF_MMdd__) {
        sDF_DateF_MMdd__ = [[NSDateFormatter alloc] init];
        [sDF_DateF_MMdd__ setDateFormat:@"MM-dd"];
    }
    
    return sDF_DateF_MMdd__;
}

+ (NSDateFormatter *)DateF_MMddHHmm{
    static NSDateFormatter *sDF_MMddHHmm;
    if (!sDF_MMddHHmm) {
        sDF_MMddHHmm = [[NSDateFormatter alloc] init];
        [sDF_MMddHHmm setDateFormat:@"MM-dd HH:mm"];
    }
    
    return sDF_MMddHHmm;
}

+ (NSDateFormatter *)DateF_HHmm{
    static NSDateFormatter *sDF_HHmm;
    if (!sDF_HHmm) {
        sDF_HHmm = [[NSDateFormatter alloc] init];
        [sDF_HHmm setDateFormat:@"HH:mm"];
    }
    return sDF_HHmm;
}

+ (NSDateFormatter *)DateF_HHmm_apM{
    static NSDateFormatter *sDF_HHmm_apM;
    if (!sDF_HHmm_apM) {
        sDF_HHmm_apM = [[NSDateFormatter alloc] init];
        [sDF_HHmm_apM setDateFormat:@"hh:mm aa"];
    }
    return sDF_HHmm_apM;
}

+ (NSDateFormatter *)DateF_HHmmss{
    static NSDateFormatter *sDF_HHmmss;
    if (!sDF_HHmmss) {
        sDF_HHmmss = [[NSDateFormatter alloc] init];
        [sDF_HHmmss setDateFormat:@"HH:mm:ss"];
    }
    return sDF_HHmmss;
}

+ (NSDateFormatter *)DateF_YYYYMMddHHmmInChinese{
    static NSDateFormatter *sDF_YYYYMMddHHmmssInChines;
    if (!sDF_YYYYMMddHHmmssInChines) {
        sDF_YYYYMMddHHmmssInChines = [[NSDateFormatter alloc] init];
        [sDF_YYYYMMddHHmmssInChines setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    }
    
    return sDF_YYYYMMddHHmmssInChines;
}

+ (NSDateFormatter *)DateF_YYYYMMddInChinese{
    static NSDateFormatter *sDF_YYYYMMddInChines;
    if (!sDF_YYYYMMddInChines) {
        sDF_YYYYMMddInChines = [[NSDateFormatter alloc] init];
        [sDF_YYYYMMddInChines setDateFormat:@"yyyy年MM月dd日"];
    }
    return sDF_YYYYMMddInChines;
}

+ (NSDateFormatter *)DateF_MMddHHmmInChinese{
    static NSDateFormatter *sDF_MMddHHmmInChinese;
    if (!sDF_MMddHHmmInChinese) {
        sDF_MMddHHmmInChinese = [[NSDateFormatter alloc] init];
        [sDF_MMddHHmmInChinese setDateFormat:@"MM月dd日 HH:mm"];
    }
    
    return sDF_MMddHHmmInChinese;
}

+ (NSDateFormatter *)DateF_MMddInChinese{
    static NSDateFormatter *sDF_MMddInChinese;
    if (!sDF_MMddInChinese) {
        sDF_MMddInChinese = [[NSDateFormatter alloc] init];
        [sDF_MMddInChinese setDateFormat:@"MM月dd日"];
    }
    
    return sDF_MMddInChinese;
}

@end
