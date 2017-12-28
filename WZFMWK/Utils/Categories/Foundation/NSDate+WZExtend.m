//
//  NSDate+WZExtend.m
//  WZFMWK
//
//  Created by Walker on 2017/11/27.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "NSDate+WZExtend.h"

// MARK: - 日期详情
@implementation NSDate (WZDetail)

- (WZNSDateInfo)wz_dateInfo {
    return [self wz_dateInfoWithTimeZone:nil];
}

- (WZNSDateInfo)wz_dateInfoWithTimeZone:(NSTimeZone *)timeZone {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    if (timeZone) [gregorian setTimeZone:timeZone];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitMonth | NSCalendarUnitMinute | NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitSecond) fromDate:self];
    
    WZNSDateInfo info;
    info.year = components.year;
    info.month = components.month;
    info.day = components.day;
    info.hour = components.hour;
    info.minute = components.minute;
    info.second = components.second;
    info.weekday = components.weekday;
    return info;
}

+ (NSDate *)wz_dateFromDateInfo:(WZNSDateInfo)dateInfo {
    return [self wz_dateFromDateInfo:dateInfo timeZone:nil];
}

+ (NSDate *)wz_dateFromDateInfo:(WZNSDateInfo)dateInfo
                        timeZone:(NSTimeZone *)timeZone {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    if (timeZone) gregorian.timeZone = timeZone;
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    components.year = dateInfo.year;
    components.month = dateInfo.month;
    components.day = dateInfo.day;
    components.hour = dateInfo.hour;
    components.minute = dateInfo.minute;
    components.second = dateInfo.second;
    if (timeZone) components.timeZone = timeZone;
    return [gregorian dateFromComponents:components];
}

@end

// MARK: - 日期字符串格式化
@implementation NSDate (WZFormat)

+ (NSDate *)wz_dateFromString:(NSString *)str stringFormat:(NSString *)strFormat {
    NSDateFormatter *strformatter = [[NSDateFormatter alloc] init];
    [strformatter setDateFormat:strFormat];
    NSDate *date = [strformatter dateFromString:str];
    return date;
}

- (NSString *)wz_stringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}

@end

@implementation NSString (WZDateStringFormat)

- (NSString *)wz_convertDateStrFromFormat:(NSString *)originFormat
                                  toFormat:(NSString *)targetFormat {
    NSDate *date = [NSDate wz_dateFromString:self stringFormat:originFormat];
    return [date wz_stringWithFormat:targetFormat];
}

@end























