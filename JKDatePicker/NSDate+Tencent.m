//
//  NSDate+Tencent.m
//  DeviceManager
//
//  Created by hth on 2/29/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "NSDate+Tencent.h"

@implementation NSDate (Tencent)
+ (NSString *)tc_dateAndTimeStringFromTimeIntervalSince1970:(NSTimeInterval)interval {
    static NSDateFormatter *dateFormatter = nil;

    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
    }
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];

    return timeStr;
}

+ (NSTimeInterval)tc_timeIntervalSince1970FromDateAndTimeString:(NSString *)dateAndTimeString {
    static NSDateFormatter *dateFormatter = nil;

    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
    }

    NSDate         *date    = [dateFormatter dateFromString:dateAndTimeString];
    NSTimeInterval interval = [date timeIntervalSince1970];

    return interval;
}

+ (NSString *)tc_timeStringFromDuration:(NSTimeInterval)duration {
    long time = duration;

    NSString *timeStr = [NSString stringWithFormat:@"%02ld", time%60];

    long minutes = time / 60;

    timeStr = [NSString stringWithFormat:@"%02ld:%@", minutes%60, timeStr];

    long hours = minutes / 60;
    if (hours > 0) {
        timeStr = [NSString stringWithFormat:@"%02ld:%@", hours, timeStr];
    }

    return timeStr;
}

+ (NSString *)tc_dateStringFromTimeIntervalSince1970:(NSTimeInterval)interval {
    NSString *dateAndTimeString = [[self class] tc_dateAndTimeStringFromTimeIntervalSince1970:interval];
    return [dateAndTimeString componentsSeparatedByString:@" "].firstObject;
}

+ (NSString *)tc_timeStringFromTimeIntervalSince1970:(NSTimeInterval)interval {
    NSString *dateAndTimeString = [[self class] tc_dateAndTimeStringFromTimeIntervalSince1970:interval];
    return [dateAndTimeString componentsSeparatedByString:@" "].lastObject;
}

+ (NSString *)tc_timeStringFromTimeInterVal:(NSTimeInterval)duration {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:duration];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:NSLocalizedString(@"NSDate+Tencent.yyyy年MM月dd日HH:mm", nil)];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

- (NSString *)tc_stringValueWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:self];
}

- (NSTimeInterval)tc_timeInterval {
    return [self timeIntervalSince1970] * 1000;
}

+ (instancetype)tc_dateFromTimeInterval:(NSTimeInterval)timeInterval {
    return [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000.0];
}

//获取年月日
- (NSInteger)tc_year {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSInteger year= [components year];
    return year;
}

- (NSInteger)tc_month {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self];
    NSInteger month= [components month];
    return month;
}

- (NSInteger)tc_day {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self];
    NSInteger day= [components day];
    return day;
}

@end
