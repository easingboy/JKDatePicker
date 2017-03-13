//
//  NSDate+Tencent.h
//  DeviceManager
//
//  Created by hth on 2/29/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tencent)
//from timeInterval to yyyy-MM-dd HH:mm:ss
+ (NSString *)tc_dateAndTimeStringFromTimeIntervalSince1970:(NSTimeInterval)interval;

//from yyyy-MM-dd HH:mm:ss to timeInterval
+ (NSTimeInterval)tc_timeIntervalSince1970FromDateAndTimeString:(NSString *)dateAndTimeString;

//from duration to HH:mm:ss
+ (NSString *)tc_timeStringFromDuration:(NSTimeInterval)duration;

//from timeInterval to yyyy-MM-dd
+ (NSString *)tc_dateStringFromTimeIntervalSince1970:(NSTimeInterval)interval;
//from timeInterval to HH:mm:ss
+ (NSString *)tc_timeStringFromTimeIntervalSince1970:(NSTimeInterval)interval;

+ (NSString *)tc_timeStringFromTimeInterVal:(NSTimeInterval)duration;

- (NSString *)tc_stringValueWithDateFormat:(NSString *)dateFormat;

//毫秒时间戳
- (NSTimeInterval)tc_timeInterval;
+ (instancetype)tc_dateFromTimeInterval:(NSTimeInterval)timeInterval;

//获取年月日
- (NSInteger)tc_year;
- (NSInteger)tc_month;
- (NSInteger)tc_day;

@end
