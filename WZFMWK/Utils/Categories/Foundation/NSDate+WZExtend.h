//
//  NSDate+WZExtend.h
//  WZFMWK
//
//  Created by Walker on 2017/11/27.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <Foundation/Foundation.h>

// MARK: - 日期详情
typedef struct WZNSDateInfo {
    NSInteger year;
    NSInteger month;
    NSInteger day;
    
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
    
    NSInteger weekday; // 1-7: 周日为1，周一为2，......周六为7
} WZNSDateInfo;

@interface NSDate (WZDetail)

- (WZNSDateInfo)wz_dateInfo;
- (WZNSDateInfo)wz_dateInfoWithTimeZone:(NSTimeZone *)timeZone;

+ (NSDate *)wz_dateFromDateInfo:(WZNSDateInfo)dateInfo;
+ (NSDate *)wz_dateFromDateInfo:(WZNSDateInfo)dateInfo timeZone:(NSTimeZone *)timeZone;

@end

// MARK: - 日期字符串格式化
@interface NSDate (WZFormat)

/**
 *  将一个日期字符串转换为一个Date
 *  例如：NSDate *date = [NSDate wz_dateFromString:@"1970.01.01" stringFormat:@"yyyy.MM.dd"];
 */
+ (NSDate *)wz_dateFromString:(NSString *)str stringFormat:(NSString *)strFormat;

/**
 *  将日期转换成字符串
 *  例如：NSString *str = [[NSDate date] wz_stringWithFormat:@"yyyy.MM.dd"]; => @"1970.01.01"
 */
- (NSString *)wz_stringWithFormat:(NSString *)format;

@end

@interface NSString (WZDateStringFormat)

/*
 *  将日期字符串 从 originFormat 格式转换为 targetFormat 格式
 *  例如将“2017-01-01”从“yyyy-MM-dd”转换为“yyyy/MM/dd”
 */
- (NSString *)wz_convertDateStrFromFormat:(NSString *)originFormat
                                  toFormat:(NSString *)targetFormat;

@end

















